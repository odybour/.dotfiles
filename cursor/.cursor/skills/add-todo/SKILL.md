---
name: add-todo
description: Append a new todo line to a domain file under ~/programming/aux/nokia-notes/todos/. Use when the user asks to add, create, log, or record a todo / task for a specific work domain (e.g. a microservice, IDE config, refactor effort).
---

# Add Todo

Append a single todo line to the AsciiDoc file for a work domain.

## Inputs

- `domain` (string, required) — file stem, e.g. `microservice-x`. Sanitized to `[a-z0-9._-]+`.
- `priority` (int, required) — positive integer; lower = higher priority.
- `description` (string, required) — free text, single line.

If any input is missing, ask the user for it before proceeding.

## Behavior

1. Resolve `FILE="$HOME/programming/aux/nokia-notes/todos/<domain>.adoc"`.
2. Resolve `TODAY="$(date +%F)"`.
3. If `FILE` does not exist, create it with a title line:
   ```
   = <domain> todos

   ```
4. Append exactly one line at column 0:
   ```
   TODO P<priority> <TODAY> <description>
   ```
5. Do not modify any existing lines. Do not insert blank lines between todos.
6. Print the appended line and the relative path back to the user as confirmation.

## Reference shell

```bash
domain="microservice-x"; priority=1; description="implement retry logic for API client"
file="$HOME/programming/aux/nokia-notes/todos/${domain}.adoc"
[ -f "$file" ] || printf '= %s todos\n\n' "$domain" > "$file"
printf 'TODO P%s %s %s\n' "$priority" "$(date +%F)" "$description" >> "$file"
```

## Rules

- Never rewrite or reorder existing lines.
- Never invent a domain — if the user is vague, ask which file to append to and show existing files via `ls ~/programming/aux/nokia-notes/todos/`.
- `description` must be a single line; collapse newlines to spaces if needed.
