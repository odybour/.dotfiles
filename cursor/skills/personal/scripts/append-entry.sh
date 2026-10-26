#!/usr/bin/env bash
# Append a single journal line to today's section in notes.adoc.
# Append-only: never edits existing lines.
# Format: AsciiDoc description list — TODO:: | DONE:: | ONGOING::
set -euo pipefail

JOURNAL="${HOME}/programming/aux/personal-notes/notes.adoc"
TODAY="$(date +%F)"
SECTION="== ${TODAY}"
STATUS="TODO"

usage() {
  echo "usage: append-entry.sh [--done | --ongoing | --todo] <entry text>" >&2
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --done) STATUS="DONE"; shift ;;
    --ongoing) STATUS="ONGOING"; shift ;;
    --todo) STATUS="TODO"; shift ;;
    -*) usage ;;
    *) break ;;
  esac
done

if [[ $# -lt 1 ]]; then
  usage
fi

if [[ ! -f "$JOURNAL" ]]; then
  echo "journal not found: $JOURNAL" >&2
  exit 1
fi

# Collapse to a single line.
entry="$*"
entry="${entry//$'\n'/ }"
entry="${entry//$'\r'/ }"
entry="$(printf '%s' "$entry" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

if [[ -z "$entry" ]]; then
  echo "entry text is empty" >&2
  exit 1
fi

# Strip legacy bullet or redundant status prefix from text.
entry="$(printf '%s' "$entry" | sed -E 's/^\* //;s/^(DONE|TODO|ONGOING):: //')"

entry="${STATUS}:: ${entry}"

# Create today's section if missing (check last 500 lines for performance).
if ! tail -n 500 "$JOURNAL" | grep -qxF "$SECTION"; then
  printf '\n%s\n\n' "$SECTION" >> "$JOURNAL"
fi

printf '%s\n' "$entry" >> "$JOURNAL"
printf 'appended to %s under %s:\n%s\n' "$JOURNAL" "$SECTION" "$entry"
