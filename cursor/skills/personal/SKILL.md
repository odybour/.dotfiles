---
name: personal
description: >-
  Personal-project journal over ~/programming/aux/personal-notes/notes.adoc.
  Use for /personal, personal journal, personal-notes, side project log,
  "what am I forgetting" (personal), /personal add, update, remove, history.
  Today-editable lines (TODO:: / DONE:: / ONGOING::); past days immutable.
  Not for /work or nokia-notes. Not a task manager — no todos/ or Jira.
---

# Personal — side-project journal organizer

`notes.adoc` under personal-notes is a chronological journal for personal projects.
`/personal` produces an **AI-inferred current view** over that history.

## Journal

```
JOURNAL="$HOME/programming/aux/personal-notes/notes.adoc"
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
TODO:: Wire up auth for the hobby API.
DONE:: Shipped v0.1 of the dotfiles sync script.
ONGOING:: Refactor the personal-notes Cursor skill.
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
"$SCRIPT" --done "Finished the README draft."
```

### Other

- **Never** write to `~/programming/aux/nokia-notes/` or use the `work` skill's journal.
- **Never** create Jira tickets or write to `todos/` under personal-notes.

## Not a task manager

This skill is **not** Nokia `add-todo` or `get-todos-sorted`. Do not create or use
`personal-notes/todos/` for this workflow.

## Ambiguous routing

If the user logs work without `/personal` or `/work`:

- Workspace is `personal-notes`, or they mention personal / side project → this skill.
- They use `/work`, nokia-notes, or Nokia work context → `work` skill.
- Otherwise ask which journal.

---

## Intent routing

Classify the user message, then act:

| Intent | Triggers (examples) | Action |
|--------|---------------------|--------|
| **view** | `/personal`, "personal status", "what's on my plate" (personal) | Read journal → infer → output view |
| **add** | `/personal add: …`, "log for personal …", "note in personal journal …" | `append-entry.sh` → `TODO::` |
| **update** | `/personal update …`, "change today's …" (personal) | `replace` (preserve status unless flags say otherwise) |
| **status** | "mark … ONGOING" (personal context) | `replace --ongoing` |
| **remove** | "drop … from today" (personal) | `remove` |
| **complete** | "I finished …" (personal / `/personal`) | Today's line → `replace --done`; else `append-entry.sh --done` |
| **history** | `/personal history`, `/personal 2026-10-06`, "last week" (personal) | Read matching sections → summarize (no writes) |
| **forget** | `/personal what am I forgetting?` | View with emphasis on stale active items |
| **prioritize** | `/personal what should I work on now?` | View ranked by urgency/recency |
| **close** | `/personal close`, "wrap up" (personal session) | Session summary in chat only; append only if user gives explicit closing text |

Natural language is fine — do not require exact command syntax.

When updating or removing, match on the **shortest distinctive substring** of the
line body (case-insensitive), not the `TODO::` prefix. If ambiguous, run `list` first and ask.

---

## Read strategy

Avoid loading the full file unless the query is broad ("all history").

**Default view (`/personal`):**

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
- Legacy: `Finished …`, `completed`, `shipped`, `released`, or suffix `— DONE`
- A later dated entry explicitly says the item is done

### Still active

- Line starts with `TODO::` or `ONGOING::`
- Legacy: imperatives (`need to`, `must`, …), suffix `— ONGOING`
- Urgency: `Very important`, `!!`, deadlines (`before launch`)
- No later completion signal and line not removed

### Easy to forget

- Mentioned ≥3 days ago
- No recent re-mention in the last few days
- No completion signal
- Often softer phrasing (`think about`, `what about`, `perhaps`)

### Longer-running threads

- Same theme, repo, or project name across 2+ date sections
- Examples: dotfiles sync, a hobby app release, scaffolding setup

### Important today

- Today's `TODO::` / `ONGOING::` lines
- Items with urgency markers or named deadlines

Stay tentative when ambiguous: "likely still open", "may be done".

---

## Output template (view intents)

Use markdown (not AsciiDoc). Include today's date in the title.
Group today's items by status when the section uses `TODO::` / `DONE::` / `ONGOING::`.

```markdown
# Personal — YYYY-MM-DD

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
SCRIPT="$HOME/.cursor/skills/personal/scripts/append-entry.sh"
UPDATE="$HOME/.cursor/skills/personal/scripts/update-today-entry.sh"
```

(or `~/.cursor/skills/personal/scripts/…` when symlinked)

### Add (default `TODO::`)

```bash
"$SCRIPT" "add retry logic to the hobby API client"
"$SCRIPT" --ongoing "Draft personal skill SKILL.md"
"$SCRIPT" --done "Finished the README draft."   # completions from a past day
```

### Update today (replace text)

Preserves existing `TODO::` / `ONGOING::` / `DONE::` unless you pass a status flag
or the new text already starts with `DONE::` / `TODO::` / `ONGOING::`.

```bash
"$UPDATE" replace "README" "Expand README with install steps"
"$UPDATE" replace --ongoing "README" "Expand README with install steps"
"$UPDATE" replace --done "README" "Finished the README draft."
"$UPDATE" replace "README" "DONE:: Finished the README draft."
```

### Remove from today

```bash
"$UPDATE" remove "spike old auth approach"
```

### List today's lines

```bash
"$UPDATE" list
```

### Complete

**Item already in today's section** — set status to done (keep or shorten body):

```bash
"$UPDATE" replace --done "README" "Finished the README draft."
```

**Item from an earlier day** — append under today; do not edit the old line:

```bash
"$SCRIPT" --done "Finished the README draft."
```

Rules for entry text:

- Single line; collapse internal newlines to spaces
- Pass **body text only** to scripts (no `TODO::` prefix unless you intend to set status explicitly)
- Preserve the user's phrasing for completions (`Finished …`, `Shipped …`, etc.)

---

## Examples

**`/personal`** → produce the default view from recent sections; split today by status when present.

**`/personal add: wire up CI for personal-notes repo`**
→ `TODO:: wire up CI for personal-notes repo`

**`I finished the README draft.`** (today's line was `ONGOING:: Expand README …`)
→ `replace --done "README" "Finished the README draft."`

**`I no longer need to spike the old auth approach.`**
→ `remove "spike old auth approach"`

**`/personal update: mark dotfiles sync as ONGOING`**
→ `replace --ongoing "dotfiles sync" "Dotfiles sync — finish rsync excludes"`

**`/personal history dotfiles`**
→ summarize dotfiles-related entries across matching dates.

**`/personal 2026-10-02`**
→ recap that day only.

**`/personal what am I forgetting?`**
→ emphasize stale personal-project items.

**`/personal close`**
→ end-of-session summary in chat; no file write unless user supplies text to log.
