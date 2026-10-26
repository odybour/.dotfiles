---
name: work
description: >-
  Personal work journal over ~/programming/aux/nokia-notes/notes.adoc.
  Use for /work, "what am I forgetting", "what should I work on now",
  "I finished …", "I also need to …", /work add, /work update, /work remove,
  /work history, date/history queries. Today-editable lines (TODO:: / DONE:: / ONGOING::);
  past days immutable. Not for /personal or personal-notes. Not a task manager — do not use todos/ files or Jira for this workflow.
---

# Work — personal journal organizer

`notes.adoc` is a chronological work journal.
`/work` produces an **AI-inferred current view** over that history.

## Journal

```
JOURNAL="$HOME/programming/aux/nokia-notes/notes.adoc"
```

Recent sections use `== YYYY-MM-DD` with **AsciiDoc description-list status lines**
(`TODO::`, `DONE::`, `ONGOING::`). Older sections may use `* ` bullets, `== DD/MM/YYYY`,
or free-form prose — read all when scanning history.

**New writes always use ISO dates** (`YYYY-MM-DD`) and the description-list format.

File legend (top of journal):

```asciidoc
// Journal status: DONE:: | TODO:: | ONGOING:: (description lists under == YYYY-MM-DD)
```

## Entry format (mandatory for new writes)

One line per item under today's section:

```asciidoc
TODO:: Continue Quarkus native stress tests on the cluster.
DONE:: Built native IPFIX FE collector on Quarkus…
ONGOING:: Compare Karaf FE with Serial GC vs native Quarkus.
```

The `::` is AsciiDoc description-list syntax (term + description). Do not use `* ` bullets
for new entries under today's date.

| Status | Meaning |
|--------|---------|
| `TODO::` | Not started or queued |
| `ONGOING::` | Actively working on it |
| `DONE::` | Finished (same day) |

## Mutability rules (mandatory)

### Today only

Lines under **today's** `== YYYY-MM-DD` section may be:

- **added** — `scripts/append-entry.sh` (defaults to `TODO::`)
- **updated** — `scripts/update-today-entry.sh replace`
- **removed** — `scripts/update-today-entry.sh remove`

Use `update-today-entry.sh list` to see today's lines with line numbers (body text only)
before changing one.

**Never** use `StrReplace`, `Write`, or hand edits on `notes.adoc` — always use
the scripts above.

### Past days (immutable)

- **Never** delete, rewrite, reorder, or edit any line in a **past** date section.
- **Never** copy unfinished items to a new date.
- **Never** mark an older-day item done by editing its original line.

When something from a past day is finished or dropped, append under **today**:

```bash
"$SCRIPT" --done "Finished the CI build."
```

### Other

- **Never** create Jira tickets, update Jira, or write to `todos/` domain files.

## Not a task manager

This skill is **not** `add-todo` or `get-todos-sorted`. Those skills manage
`~/programming/aux/nokia-notes/todos/<domain>.adoc`. The journal is separate.
Do not cross-write between them.

---

## Intent routing

Classify the user message, then act:

| Intent | Triggers (examples) | Action |
|--------|---------------------|--------|
| **view** | `/work`, "what should I work on", "status", "what's on my plate" | Read journal → infer → output view |
| **add** | `/work add: …`, "I also need to …", "note that …", "log …" | `append-entry.sh` → `TODO::` |
| **update** | `/work update …`, "change today's …", reword a today item | `replace` (preserve status unless flags say otherwise) |
| **status** | "mark … ONGOING", "start …" | `replace --ongoing` |
| **remove** | "no longer need to …", "drop …", "remove … from today" | `remove` |
| **complete** | "I finished …", "done with …", "completed …" | Today's line → `replace --done`; else `append-entry.sh --done` |
| **history** | `/work history`, `/work 2026-10-06`, "last week" | Read matching sections → summarize (no writes) |
| **forget** | `/work what am I forgetting?` | View with emphasis on stale active items |
| **prioritize** | `/work what should I work on now?` | View ranked by urgency/recency |
| **close** | `/work close`, "wrap up" | Session summary in chat only; append only if user gives explicit closing text |

Natural language is fine — do not require exact command syntax.

When updating or removing, match on the **shortest distinctive substring** of the
line body (case-insensitive), not the `TODO::` prefix. If ambiguous, run `list` first and ask.

---

## Read strategy

Avoid loading the full ~5k-line file unless the query is broad ("all history").

**Default view (`/work`):**

1. List date sections: `rg '^== ' "$JOURNAL" | tail -30`
2. Read the last ~21 days of sections (from the newest `==` heading backward).
3. Optionally `rg -i '<keyword>'` for threads that span beyond 21 days.
4. For today: `rg '^(DONE|TODO|ONGOING)::' "$JOURNAL"` after locating today's section.

**History / date query:**

- Specific date: read the `== YYYY-MM-DD` (or `== DD/MM/YYYY`) section only.
- Topic: `rg -i '<topic>' "$JOURNAL"` then read surrounding context.
- "Last week": sections from 7 days ago through today.

**Date formats:** `2026-10-06`, `06/10/2026`, `6/10/2026`, "last Tuesday" —
resolve relative to today's date when the user is vague.

---

## Inference heuristics

Infer state from journal text. **Prefer explicit `DONE::` / `TODO::` / `ONGOING::`
on today's lines.** Older entries may use legacy markers.

### Completed

- Line starts with `DONE::`
- Legacy: `Finished …`, `completed`, `sent`, `replied`, or suffix `— DONE`
- A later dated entry explicitly says the item is done

### Still active

- Line starts with `TODO::` or `ONGOING::`
- Legacy: imperatives (`need to`, `must`, …), suffix `— ONGOING`
- Urgency: `Very important`, `!!`, deadlines (`before review`)
- People + commitment: `With Stamatis`, `Answer Peter`, …
- No later completion signal and line not removed

### Easy to forget

- Mentioned ≥3 days ago
- No recent re-mention in the last few days
- No completion signal
- Often softer phrasing (`think about`, `what about`, `perhaps`)

### Longer-running threads

- Same theme, epic, ticket, or person across 2+ date sections
- Examples: optimization epic FNMS-195097, FOSS, calculator deployment,
  Quarkus migration, IPFIX load generator

### Important today

- Today's `TODO::` / `ONGOING::` lines
- Items with urgency markers or named deadlines

Stay tentative when ambiguous: "likely still open", "may be done".

---

## Output template (view intents)

Use markdown (not AsciiDoc). Include today's date in the title.
Group today's items by status when the section uses `TODO::` / `DONE::` / `ONGOING::`.

```markdown
# Work — YYYY-MM-DD

## Suggested focus
(only for prioritize intent)

## Today — ONGOING
- …

## Today — TODO
- …

## Today — DONE
- …

## Likely still active
- … (first seen YYYY-MM-DD)

## Easy to forget
- …

## Longer-running threads
- …

## Recently completed (inferred)
- …
```

Omit empty sections. Cite source dates.

For **close**, summarize what was touched today, what likely carries over,
and one-line suggestions for tomorrow — chat only unless the user asks to log
a closing note (then `append-entry.sh`).

---

## Write workflows

Resolve script paths relative to this skill:

```
SCRIPT="$HOME/.cursor/skills/work/scripts/append-entry.sh"
UPDATE="$HOME/.cursor/skills/work/scripts/update-today-entry.sh"
```

(or `~/.cursor/skills/work/scripts/…` when symlinked)

### Add (default `TODO::`)

```bash
"$SCRIPT" "investigate the IPFIX load generator"
"$SCRIPT" --ongoing "Compare Karaf with Serial GC"
"$SCRIPT" --done "Finished the CI build."   # completions from a past day
```

### Update today (replace text)

Preserves existing `TODO::` / `ONGOING::` / `DONE::` unless you pass a status flag
or the new text already starts with `DONE::` / `TODO::` / `ONGOING::`.

```bash
"$UPDATE" replace "CI build" "Execute a CI build in quarkus migration FB"
"$UPDATE" replace --ongoing "CI build" "Execute a CI build in quarkus migration FB"
"$UPDATE" replace --done "CI build" "Finished the CI build."
"$UPDATE" replace "CI build" "DONE:: Finished the CI build."
```

### Remove from today

```bash
"$UPDATE" remove "review a new document"
```

### List today's lines

```bash
"$UPDATE" list
```

### Complete

**Item already in today's section** — set status to done (keep or shorten body):

```bash
"$UPDATE" replace --done "CI build" "Finished the CI build."
```

**Item from an earlier day** — append under today; do not edit the old line:

```bash
"$SCRIPT" --done "Finished the CI build."
```

Rules for entry text:

- Single line; collapse internal newlines to spaces
- Pass **body text only** to scripts (no `TODO::` prefix unless you intend to set status explicitly)
- Preserve the user's phrasing for completions (`Finished …`, `Sent …`, etc.)

---

## Examples

**`/work`** → produce the default view from recent sections; split today by status when present.

**`/work add: investigate the IPFIX load generator`**
→ `TODO:: investigate the IPFIX load generator`

**`I finished the CI build.`** (today's line was `ONGOING:: Execute a CI build …`)
→ `replace --done "CI build" "Finished the CI build."`

**`I no longer need to review the new document.`**
→ `remove "review a new document"`

**`/work update: mark Peter's document review as ONGOING`**
→ `replace --ongoing "Peter's document" "Review Peter's document (must be done before review)"`

**`/work history optimization`**
→ summarize FNMS-195097 / footprint / GC threads across matching dates.

**`/work 2026-10-02`**
→ recap that day only.

**`/work what am I forgetting?`**
→ emphasize stale items (calculator FOSS/deployment, AI SDLC, etc.).

**`/work close`**
→ end-of-session summary in chat; no file write unless user supplies text to log.
