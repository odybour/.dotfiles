---
name: gc-pressure-analysis
description: >-
  Analyze HotSpot G1 unified GC logs for live-set pressure using gc_analyze.py.
  Use when the user asks for GC pressure analysis, live-object / promotion /
  heap-after-young-GC interpretation, or optimization room from a -Xlog:gc* log.
disable-model-invocation: true
---

# GC pressure analysis

## Required input

- `log_path` — path to the GC log file to analyze.
- `output_path` (optional) — where to write the Markdown report; default below.

Substitute `<PATH>` below with that path, then follow the prompt **verbatim**.

## Output

Write the full analysis to a Markdown file. Default location: same directory as
`<PATH>`, filename `<log-stem>-gc-findings.md` (e.g. `input.log` →
`input-findings.md`). Use `output_path` when the user specifies another
path or name.

## Prompt

Analyze GC pressure in file <PATH>
Do not change code or JVM flags.
  Source: HotSpot JVM (G1 unless the init lines say otherwise), unified
  logging -Xlog:gc*:stdout:time,uptime,level,tags (gc*=info). The file also
  holds application logs: use only lines containing "[gc".
  First, check completeness: report first/last uptime and GC(N) ids. If the
  first GC id is not 0 or the ids have gaps, say the log is truncated.
  Use python script gc_analyze.py that is available in PATH. Run it (default
  load-window detection; --load-start 0 only if asked). Quote its table, then
  interpret. Do not treat allocation MiB/s as the verdict.
  Quote the script's verdict line, then give your own verdict.
  Core idea (do not skip):
    Live data = objects reachable from GC roots; young/mixed/full GC cannot
    discard them. Pause cost is dominated by copying/scanning live data, not by
    how many dead eden objects you throw away. High MiB/s with a tiny heap-after
    young GC means objects died in eden (cheap reclaim). Long pauses with a
    growing heap-after mean survivors were still reachable mid-pipeline and
    were copied toward old gen (expensive), which then enlarges remembered-set
    scan work on later young GCs.
    Heap after young GC ≈ survivor + old + humongous (eden emptied).
    Heap after Full GC  ≈ true live floor (young GC cannot see old-gen garbage).
    If after-young >> after-Full, old gen holds reclaimable garbage; mixed GC /
    concurrent mark are already in play.
    Humongous (object > half region size) is allocated outside eden. Dead
    humongous primitive arrays can be eagerly reclaimed at young GC; other
    humongous objects wait for concurrent mark + mixed GC or Full GC. A
    humongous count that stays flat across young GCs is therefore likely live.
    A Humongous Allocation pause means G1 needed contiguous free regions.
  Report, whole run excluding warm-up until load starts:
  1) Live-set proxies (primary)
     - heap after young GC: min/median/max; trend up vs band
     - old regions after young GC: min/median/max and MiB (region size × count);
       trend
     - survivor regions after young GC: min/median/max (promotion / mid-request
       survival)
     - humongous regions after young GC: min/median/max and MiB; stable vs growing
     - heap after Full GC (true live floor) if any Full GC exists in the
       process log; if none, say the floor is unknown and treat
       heap-after-young as an upper bound
     - GC count by cause, especially: Pause Young (Normal), Mixed, Concurrent
       Start, Remark, Cleanup, G1 Humongous Allocation, Pause Full, Evacuation
       Failure, To-space exhausted
  2) Pause cost (consequence of live set, not of MiB/s)
     - pause p50/p99/max
     - STW time / wall time
     - Concurrent Mark time / wall time and cycle count (old gen crossed
       marking threshold; mixed GC will follow; marking steals CPU from the
       app and can cascade into more live data)
     - Per 1-minute window: STW %, allocation MiB/s, median heap-after-young,
       and if the script/log allows: median old regions, median humongous
  3) Allocation rate (secondary only)
     - MiB/s = (before of GC n − after of GC n−1) / interval
     - Use it to explain *why young GC fires often* (fills eden faster), not
       to declare pressure. Mention premature young GC: a burst of short-lived
       objects (e.g. exceptions) can fill eden while a request/IPFIX message is
       still on-stack, so *other* still-reachable pipeline objects survive and
       get copied.
  4) CPU starvation (orthogonal)
     - Real vs User+Sys; flag pauses where Real > 1.5 × (User+Sys)
     - This is scheduling/throttling, not live-set size
  Optimization room (say yes/no with evidence):
    - Live set already small and flat after young GC, tiny survivor, no Mixed /
      concurrent mark / Full / humongous-allocation pauses
      → little GC-shape win; leftover MiB/s is dead-eden churn (JFR allocators
      if you care about CPU, not pause shape).
    - Heap-after-young climbing, old regions climbing, Mixed + concurrent mark
      present, after-young >> after-Full
      → room: shorten object lifetime so a request finishes before young GC
      (stop filling eden with avoidable objects such as exceptions); shrink
      retained caches / graphs that survive into old.
    - Humongous regions large or growing, or Pause Young/Full (G1 Humongous
      Allocation)
      → room: find large byte[]/char[]/JSON/buffers (JFR/heap dump); they skip
      young GC.
    - Survivor after young GC not near-empty
      → mid-GC the pipeline still holds the working set; young GC is hitting
      during in-flight work.
  Verdict, one of (live-set first):
    - no pressure: heap-after-young flat and small vs heap max; survivor tiny;
      no Mixed/marking storm, no evacuation failure or Full GC; STW under
      ~7.7% (G1 GCTimeRatio=12) is supporting evidence only
    - young-only churn (not pressure): high MiB/s, STW may tick up, but
      heap-after-young flat, objects die in eden, no old-gen growth
    - promotion / heap pressure: heap-after-young or old/humongous regions
      climbing; Mixed, concurrent mark, Humongous Allocation pauses, evacuation
      failure, or Full GC
    - CPU starvation: Real much greater than User+Sys (can coexist with the
      others)
  Put verdict + summary table first, then 3–5 quoted [gc log lines that
  support the live-set story (heap after young, Old/Humongous region lines,
  a Mixed or Concurrent Start / Humongous Allocation cause, a Full GC
  before/after if any). Do not lead with MiB/s.

JFR follow-up hypothesis

Based on this GC analysis, identify the application-level questions that JFR
must answer. Rank them by expected optimization value.

For each, provide:
- Priority: P0 / P1 / P2
- Hypothesis/question
- GC evidence motivating it
- What JFR should look for
- What result would confirm or weaken the hypothesis

Focus on questions that can lead to lower CPU, memory, disk I/O, network I/O,
GC cost, or latency.

Do not invent application-specific classes, components, caches, queues, or
libraries unless they are explicitly present in the GC log or supplied context.
Use generic categories such as "cache", "queue", "request graph", "parser",
or "buffer" when the specific component is unknown.

Do not equate allocation volume with retained memory. JFR allocation data can
show where objects are created, but does not by itself prove that those objects
survive GC or account for retained heap. If JFR cannot establish retention,
say so and recommend a heap dump only when it would resolve the question.

Do not recommend increasing CPU/heap as an optimization merely because it could
reduce GC or pause time. CPU and heap increases may be useful diagnostic
experiments, but the primary goal is reducing the application's resource
footprint.

Typical questions include:
- Which allocation sites create the survivor/old-gen working set?
- Which allocation sites/classes could explain the gap between after-young
  heap and the Full-GC live floor?
- Which allocation sites create humongous byte[]/char[]/buffer objects?
- Which code paths generate exceptions or short-lived allocation bursts?
- Which threads are responsible for allocation and CPU consumption?
- Which caches, queues, request graphs, or other structures may retain objects
  across young collections?
- Is CPU scheduling/throttling materially contributing to wall-clock latency?

