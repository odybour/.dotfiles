---
name: add-todo-with-plan
description: Create a written-out plan file under ~/programming/aux/nokia-notes/<domain>/plans/<slug>.adoc and append a single TODO line referencing it. Use when the user asks to record a TODO that has an associated plan, design note, or step-by-step that should be picked up later.
---

# Add Todo With Plan

Author a per-TODO plan file under the domain's `plans/` subfolder and
append a single TODO line that references it. Use this whenever a TODO
ships with a written-out plan; for bare one-line TODOs, use the
`add-todo` skill instead.

## Inputs

- `domain` (string, required) — file stem, e.g. `microservice-x`. Sanitized to `[a-z0-9._-]+`.
- `priority` (int, required) — positive integer; lower = higher priority.
- `slug` (string, required) — kebab-case file stem for the plan, e.g. `restore-jacoco-coverage-gate`. Sanitized to `[a-z0-9-]+`.
- `description` (string, required) — free text, single line, summary for the TODO row.
- `plan_content` (string, required) — multi-line AsciiDoc body to write as the plan.

If any input is missing, ask the user for it before proceeding.

## Behavior

1. Resolve `PLAN_DIR="$HOME/programming/aux/nokia-notes/<domain>/plans"` and create it with `mkdir -p` if missing.
2. Resolve `PLAN_FILE="$PLAN_DIR/<slug>.adoc"`. If it already exists, refuse to overwrite — fail with a clear message asking the user to pick a new slug.
3. Write `plan_content` verbatim to `PLAN_FILE`.
4. Delegate the TODO-line append to the `add-todo` skill, passing `plan_path="<domain>/plans/<slug>.adoc"` so the appended line ends with `(plan: <domain>/plans/<slug>.adoc)`.
5. Print the plan path and the appended TODO line back to the user as confirmation.

## Reference shell

```bash
domain="microservice-x"; priority=2
slug="add-retry-logic"
description="implement retry logic for API client"
plan_dir="$HOME/programming/aux/nokia-notes/${domain}/plans"
plan_file="${plan_dir}/${slug}.adoc"
mkdir -p "$plan_dir"
[ -e "$plan_file" ] && { echo "refusing to overwrite $plan_file"; exit 1; }
cat > "$plan_file" <<'EOF'
= <plan title>

== Why
...

== Change
...

== Validation
...
EOF
# then invoke add-todo with plan_path="${domain}/plans/${slug}.adoc"
todo_file="$HOME/programming/aux/nokia-notes/todos/${domain}.adoc"
[ -f "$todo_file" ] || printf '= %s todos\n\n' "$domain" > "$todo_file"
printf 'TODO P%s %s %s (plan: %s)\n' \
  "$priority" "$(date +%F)" "$description" "${domain}/plans/${slug}.adoc" \
  >> "$todo_file"
```

## Rules

- Plan files only go to `<domain>/plans/<slug>.adoc`. Never anywhere else.
- Never overwrite an existing plan file; each TODO gets its own. If a follow-up is needed, write a new plan file under a new slug and link it from a new TODO.
- `slug` must match `[a-z0-9-]+` and should roughly mirror the TODO description.
- `description` must be a single line; collapse newlines to spaces if needed.
- The plan-path reference in the TODO description is always **relative to** `~/programming/aux/nokia-notes/` (e.g. `microservice-x/plans/add-retry-logic.adoc`), never the absolute `~/...` form.
- Never modify existing lines in the `<domain>.adoc` todo file — only append.
