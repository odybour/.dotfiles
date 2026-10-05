---
name: jfr-analysis
description: >-
  Analyze a JFR recording against an existing GC report to find application-level
  causes of CPU, memory, GC, I/O, and latency cost. Use after gc-pressure-analysis
  when the user asks for JFR analysis, allocation/retention investigation, or what
  code to change based on profiling evidence.
disable-model-invocation: true
---

# JFR Analysis

Second step in the profiling pipeline:

- **gc-pressure-analysis** — What kind of GC pressure exists, and what questions
  should JFR answer?
- **jfr-analysis** (this skill) — What does the application actually do that
  explains those questions?
- **Code agent** — What code should we change to fix it?

## Required input

- `jfr_path` — path to the `.jfr` recording.
- `gc_report_path` — path to the GC findings Markdown produced by
  `gc-pressure-analysis` (e.g. `<log-stem>-gc-findings.md`). Contains the verdict
  and ranked JFR follow-up hypotheses.
- `output_path` (optional) — where to write the Markdown report; default below.

Substitute `<PATH>` below with `jfr_path`.

## Output

Write the full analysis to a Markdown file. Default location: same directory as
`<PATH>`, filename `<jfr-stem>-jfr-findings.md` (e.g. `karaf.jfr` →
`karaf-jfr-findings.md`). Use `output_path` when the user specifies another
path or name.

End the report with a **Code change handoff** section (see template below) so a
follow-up code agent can act without re-reading the JFR.

## Pre-flight (before the prompt)

Run these checks and record results in the report preamble:

```bash
jfr summary <PATH>
jfr metadata --categories 'GC' <PATH> | head -80
jfr metadata --categories 'Java Application' <PATH> | head -80
```

Confirm:

- Recording start/end time and duration overlap the GC report load window.
- Identify which relevant events are present for the GC hypotheses under test:
  `jdk.ObjectAllocationInNewTLAB`, `jdk.ObjectAllocationOutsideTLAB`,
  `jdk.OldObjectSample` (if enabled), `jdk.JavaExceptionThrow`,
  `jdk.ExceptionStatistics`, `jdk.ExecutionSample` or `jdk.CPULoad`,
  `jdk.ThreadCPULoad`, `jdk.JavaMonitorEnter` / `jdk.ThreadPark` (if
  investigating blocking), `jdk.FileRead` / `jdk.FileWrite`,
  `jdk.SocketRead` / `jdk.SocketWrite`.
- Note missing events and downgrade confidence for affected hypotheses.
- State explicitly which important GC events or periods are outside the JFR
  recording window.

## Investigation commands

Use `jfr` (JDK Flight Recorder CLI) on `<PATH>`. Prefer views; use
`jfr print --events <name> --stack-depth 20` for drill-down.

| Question | Command |
|----------|---------|
| Top allocators by site | `jfr view allocation-by-site <PATH>` |
| Top allocators by class | `jfr view allocation-by-class <PATH>` |
| Per-thread allocation | `jfr view allocation-by-thread <PATH>` |
| Old-gen retainers | `jfr view memory-leaks-by-site <PATH>` then `memory-leaks-by-class` |
| Large / outside-TLAB allocations | `jfr print --events jdk.ObjectAllocationOutsideTLAB --stack-depth 20 <PATH>` |
| CPU hot methods | `jfr view hot-methods <PATH>` and `cpu-time-hot-methods <PATH>` |
| Per-thread CPU | `jfr view thread-cpu-load <PATH>` |
| Exceptions | `jfr view exception-count <PATH>`, `exception-by-type`, `exception-by-site` |
| Locking / contention | `jfr view contention-by-site <PATH>`, `contention-by-thread <PATH>` |
| Disk I/O | `jfr view file-reads-by-path <PATH>`, `file-writes-by-path <PATH>` |
| Network I/O | `jfr view socket-reads-by-host <PATH>`, `socket-writes-by-host <PATH>` |
| CPU throttling | `jfr view container-cpu-throttling <PATH>`, `cpu-load <PATH>` |
| GC phases (correlate only) | `jfr view gc-pauses <PATH>`, `gc <PATH>` |

For each GC hypothesis (P0 first), run the relevant commands, quote the top
rows, and state confirmed / partially confirmed / weakened / inconclusive.

Do **not** redo the GC-log analysis. Use `gc_report_path` as context only.

Focus on findings that are materially relevant to the GC hypotheses or total
hardware footprint; do not report every minor JFR hotspot.

## Analysis rules

Analyze the JFR recording to identify application-level causes of JVM
performance and hardware-footprint cost.

Goal: reduce CPU, memory, GC cost, disk I/O, network I/O, and latency. Do not
assume the solution is to increase CPU or heap.

- Check that the JFR recording covers the relevant load period and that the
  required events are present.
- Investigate the GC hypotheses using JFR evidence.
- Focus on what the application is doing, not just JVM metrics.
- Distinguish measured facts from hypotheses.
- Do not claim causality from correlation alone.
- Do not invent application components, classes, or code paths that are not
  present in the evidence.
- Prefer conclusions that are supported by multiple independent JFR signals
  when available: for example allocation + stack trace, allocation + CPU,
  or JFR + GC evidence.
- Do not turn a plausible explanation into a confirmed root cause merely because
  it fits the GC behavior.
- Preserve distinct optimization mechanisms as separate findings when they
  have different evidence, source locations, or expected resource savings. Do
  not merge them merely because they occur in the same application path.

### Exception evidence

Treat exception evidence according to the events actually available:

- `jdk.JavaExceptionThrow` with stacks can directly identify hot exception
  throw sites.
- `jdk.ExceptionStatistics` provides aggregate exception/throwable counts but
  does not, by itself, attribute the total count to a particular application
  stack.
- If `JavaExceptionThrow` is absent, use `ExceptionStatistics` only for the
  aggregate rate and use allocation/CPU stacks to identify likely contributors.
- Never state that a particular stack accounts for all exceptions unless the JFR
  data actually establishes that.
- When exception construction is responsible for substantial allocation,
  distinguish exception count, exception allocation, and stack-trace allocation.

### Retention evidence

Allocation volume alone does not prove memory retention.

- Use `OldObjectSample` and `memory-leaks-*` as retention evidence, but account
  for their sampling limitations.
- A sparse `OldObjectSample` result is a retention hint, not proof that the
  sampled site owns the entire reported heap.
- Do not infer the complete retained heap of an application component from one
  sampled object or stack.
- If GC roots / reachability are unavailable, say so.
- If the important question is "what keeps these objects alive?" and JFR cannot
  answer it, identify a heap dump as the next measurement.

Distinguish:

- **allocation churn** — objects created rapidly and likely reclaimed young;
- **promotion pressure** — objects surviving young collections;
- **retention** — evidence that objects remain reachable and contribute to the
  old-gen working set.

### Humongous allocations

When investigating humongous objects:

- Identify the real allocation class/size and application-owned caller where
  possible.
- Correlate JFR allocation sites with GC humongous-allocation causes.
- Do not assume every large allocation is the cause of a GC pause merely because
  it is large.
- Distinguish allocation frequency, object size, and whether the objects remain
  live.
- Prefer application-level fixes such as bounded payloads, chunking, streaming,
  or avoiding unnecessary materialization over increasing heap.

### Package focus

Prefer **application-owned packages** (for example, `com.nokia.*` and
`com.alcatel.*`) when ranking allocation sites, CPU hotspots, exceptions, and
code-change candidates.

**Include all Nokia/Alcatel code in findings and handoff** — even when the
source lives in a sibling repo or Maven dependency (`base-platform`,
`netconf-lib`, `java-base-nano`, `ipfix-platform`, etc.) rather than the
workspace being profiled. Rank by JFR impact, not by which git repo is open.
Note the likely target repo/artifact when known; do not omit or downgrade a
hotspot because it is "platform" or "outside this repo".

Do **not** restrict the analysis to application-owned packages. Follow into
third-party and JDK packages when they are materially responsible for the
observed cost or are part of the relevant stack trace.

When a third-party library is a hotspot, identify the **application-owned caller
or entry point** that drives it where possible. Do not recommend changing
third-party code unless there is a clear configuration, usage, or replacement
option available to the application.

Prioritize findings that lead back to code or configuration that the application
team can actually change.

### Investigation discipline

For every major finding, answer:

- What is measured?
- What application code is involved?
- What does that imply?
- What remains unproven?
- What change or measurement should happen next?

Do not recommend a code change merely because a method is hot. Explain how the
method contributes to the observed resource cost.

Do not recommend a configuration or infrastructure change as the primary fix
when application behavior is the demonstrated source of avoidable work.

### Investigate

At minimum, determine:

- Which allocation sites/classes contribute to the survivor/old-gen working set?
- What creates humongous allocations?
- What allocation patterns or object lifetimes contribute to evacuation failures?
- Which code paths generate the allocation churn?
- Which threads consume CPU and/or allocate heavily?
- Are CPU scheduling, blocking, locking, or contention contributing to latency?
- Are exceptions unusually frequent or expensive?
- Are disk or network operations contributing materially to the cost?

Correlate JFR findings with the GC report where useful.

For evacuation failures specifically, verify that the JFR recording actually
covers the relevant failure window. If it does not, mark the hypothesis
inconclusive rather than inferring the failure mechanism from an earlier or
later period.

### Output

Start with a clear verdict.

Then provide:

- **Top findings** — ranked by likely impact on total hardware footprint.
- **Evidence** — the JFR events/metrics supporting each finding.
- **Likely root cause** — only where evidence is sufficient.
- **Optimization opportunity** — what should be investigated or changed.
- **Confidence** — High / Medium / Low.
- **Next step** — source-code investigation, heap dump, benchmark, or other
  measurement if needed.

Rank findings by expected ability to reduce actual resource consumption or
latency, not merely by how large a JFR number looks.

Do not collapse separate application optimization opportunities into one
finding just because they share a component, thread, or call path. If two
findings have materially different mechanisms or fixes, report them separately
and rank them independently.

For each major optimization candidate, classify it as one of:

- **Implement / inspect now** — evidence is strong enough that the code agent can
  investigate the named code and propose a concrete patch.
- **Investigate before changing** — evidence is meaningful but causality,
  retention, semantics, or scope is not sufficiently established.
- **Measurement required** — the current JFR cannot answer the question reliably.

Do not present an unconfirmed hypothesis as an approved code change.

## Code change handoff

After the findings, add this section so a code agent can implement fixes without
re-analyzing the JFR. Only include items backed by JFR evidence.

### Verdict (one line)

<same verdict as above>

### Change candidates (ranked)

#### 1. <short title>

- **Action class:** Implement / inspect now | Investigate before changing
- **Confidence:** High / Medium / Low
- **GC hypothesis addressed:** <P0/P1 hypothesis from gc report>
- **Evidence:** <class, method, allocation site, or thread from JFR>
- **Likely problem:** <what the code appears to be doing inefficiently>
- **Suggested fix direction:** <concrete investigation/fix direction — do not
  prescribe implementation details that require source-code validation>
- **Source investigation:** <fully-qualified class/method or package to open>
- **Target repo:** <sibling repo or Maven artifact if known, e.g. `base-platform/netconf-alarm-app`; omit only if unknown>
- **Validation:** <metrics that should improve if the change is effective>

#### 2. ...

### Do not change yet

- <hypotheses that JFR could not confirm; what measurement is needed>

### Heap dump needed?

- Yes / No — <which question only a heap dump can answer, and what load/GC
  condition should be present when capturing it>

### Handoff rules

- Name **real classes and methods** from JFR stack traces — this is what the code
  agent searches for. Include `com.nokia.*` / `com.alcatel.*` hotspots from any
  repo; the handoff is not limited to code authored in the profiled workspace.
- For third-party/JDK hotspots, cite the **application-owned caller** in
  **Source investigation** when the stack trace provides one; keep the library
  frame in **Evidence**.
- Separate **allocation churn** (high rate, likely short-lived) from **promotion
  pressure** and **retention**.
- Keep independently actionable findings separate when they have different
  mechanisms or fixes, even if they share the same component or call path.
- Never use allocation volume alone as proof of retention.
- Never attribute an aggregate exception count to a specific stack unless the JFR
  events establish that attribution.
- Do not recommend increasing CPU or heap as the primary fix.
- Do not turn a JFR hypothesis into a required code change unless the evidence
  supports it.
- If evidence is insufficient, put it in **Do not change yet** and state exactly
  what measurement is needed.
- Validation metrics are before/after checks, not assumed target values.
- Do not claim that a code change fixes an evacuation failure, Full GC, or other
  GC event when the JFR recording did not cover the relevant event window.
- The handoff must contain enough concrete evidence and source locations for a
  code agent to begin source investigation without re-analyzing the JFR.
