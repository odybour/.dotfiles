---
name: get-todos-sorted
description: List open todos (TODO and ONGOING) for a given work domain, sorted by priority ascending. Reads ~/programming/aux/nokia-notes/todos/<domain>.adoc. Use when the user asks what's open, what's next, or to show todos for a domain.
---

# Get Todos Sorted

Read a domain todo file and emit only its open items, ordered by priority.

## Inputs

- `domain` (string, required) — file stem, e.g. `microservice-x`.

## Behavior

1. Resolve `FILE="$HOME/programming/aux/nokia-notes/todos/<domain>.adoc"`.
2. If `FILE` does not exist, tell the user there are no todos for that domain and list available domains via `ls ~/programming/aux/nokia-notes/todos/`.
3. Extract only lines matching `^(TODO|ONGOING) P[0-9]+ `.
4. Sort by the numeric priority (`sort -k2.2n -k3` — priority asc, then creation date asc as tiebreaker).
5. Print the sorted list verbatim. Do not include `CLOSED` items. Do not include indented `UPDATE` lines.

## Reference shell

```bash
domain="microservice-x"
file="$HOME/programming/aux/nokia-notes/todos/${domain}.adoc"
grep -E '^(TODO|ONGOING) P[0-9]+ ' "$file" | sort -k2.2n -k3
```

## Rules

- Output is read-only; never modify the file.
- Preserve original line text exactly (status, priority, date, description).
- Do not infer or invent items; if the file is empty or has no open todos, say so.
