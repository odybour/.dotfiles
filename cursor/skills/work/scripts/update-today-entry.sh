#!/usr/bin/env bash
# Update or remove journal lines in today's section only. Past days stay immutable.
# Lines use TODO:: | DONE:: | ONGOING:: (legacy "* " bullets still matched).
set -euo pipefail

JOURNAL="${HOME}/programming/aux/nokia-notes/notes.adoc"
TODAY="$(date +%F)"
SECTION="== ${TODAY}"

usage() {
  cat <<'EOF' >&2
usage:
  update-today-entry.sh list
  update-today-entry.sh replace [--done | --ongoing | --todo] <match> <new text>
  update-today-entry.sh remove <match>

<match> is a case-insensitive substring of the line body (text after TODO:: / DONE:: / ONGOING:: or "* ").
Only lines under today's == YYYY-MM-DD section are changed.
EOF
  exit 1
}

# body = text without list prefix; prints STATUS:: body
format_entry() {
  local status="$1"
  local body="$2"
  body="${body//$'\n'/ }"
  body="${body//$'\r'/ }"
  body="$(printf '%s' "$body" | sed -E 's/^[[:space:]]*//;s/[[:space:]]*$//;s/^\* //;s/^(DONE|TODO|ONGOING):: //')"
  if [[ -z "$body" ]]; then
    echo ""
    return
  fi
  printf '%s:: %s' "$status" "$body"
}

# If new text already has STATUS::, use as-is; else apply status (default: preserve via caller).
normalize_replace_line() {
  local status="$1"
  local raw="$2"
  raw="${raw//$'\n'/ }"
  raw="${raw//$'\r'/ }"
  raw="$(printf '%s' "$raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  if [[ "$raw" =~ ^(DONE|TODO|ONGOING):: ]]; then
    printf '%s' "$raw"
  elif [[ "$raw" == "* "* ]]; then
    format_entry "$status" "${raw#* }"
  else
    format_entry "$status" "$raw"
  fi
}

require_journal() {
  if [[ ! -f "$JOURNAL" ]]; then
    echo "journal not found: $JOURNAL" >&2
    exit 1
  fi
}

section_exists() {
  awk -v section="$SECTION" '
    $0 == section { found=1; exit }
    END { exit !found }
  ' "$JOURNAL"
}

is_journal_line() {
  [[ "$1" =~ ^(DONE|TODO|ONGOING):: ]] || [[ "$1" == "* "* ]]
}

line_body() {
  local line="$1"
  if [[ "$line" =~ ^(DONE|TODO|ONGOING)::[[:space:]]*(.*) ]]; then
    printf '%s' "${BASH_REMATCH[2]}"
  elif [[ "$line" == "* "* ]]; then
    printf '%s' "${line#* }"
  else
    printf '%s' "$line"
  fi
}

line_status() {
  local line="$1"
  if [[ "$line" =~ ^(DONE|TODO|ONGOING):: ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "TODO"
  fi
}

list_today() {
  awk -v section="$SECTION" '
    function body(line,   m) {
      if (match(line, /^(DONE|TODO|ONGOING)::[ \t]+(.*)$/, m))
        return m[2]
      if (substr(line, 1, 2) == "* ")
        return substr(line, 3)
      return ""
    }
    $0 == section { in_section=1; next }
    in_section && /^== / { exit }
    in_section {
      b = body($0)
      if (b != "")
        print NR ":" b
    }
  ' "$JOURNAL"
}

apply_change() {
  local mode="$1"
  local needle="$2"
  local new_raw="${3:-}"
  local force_status="${4:-}"

  if [[ -z "$needle" ]]; then
    echo "match text is required" >&2
    exit 1
  fi

  if [[ "$mode" == "replace" ]]; then
    if [[ -z "$new_raw" ]]; then
      echo "new text is required for replace" >&2
      exit 1
    fi
  fi

  if ! section_exists; then
    echo "today section not found: $SECTION" >&2
    exit 1
  fi

  local tmp count_file changed_count
  tmp="$(mktemp)"
  count_file="$(mktemp)"

  awk -v section="$SECTION" -v needle="$needle" -v new_raw="$new_raw" -v mode="$mode" \
      -v force_status="$force_status" -v count_file="$count_file" '
    function line_body(line,   m) {
      if (match(line, /^(DONE|TODO|ONGOING)::[ \t]+(.*)$/, m))
        return m[2]
      if (substr(line, 1, 2) == "* ")
        return substr(line, 3)
      return ""
    }
    function line_status(line,   m) {
      if (match(line, /^(DONE|TODO|ONGOING)::/, m))
        return m[1]
      return "TODO"
    }
    function format_entry(st, body) {
      return st ":: " body
    }
    function normalize_new(st, raw,   m) {
      if (match(raw, /^(DONE|TODO|ONGOING)::[ \t]+(.*)$/, m))
        return raw
      sub(/^[ \t]+/, "", raw)
      sub(/^[ \t]*\*[ \t]+/, "", raw)
      sub(/^(DONE|TODO|ONGOING)::[ \t]+/, "", raw)
      return format_entry(st, raw)
    }
    function is_journal_line(line) {
      return line_body(line) != "" || substr(line, 1, 2) == "* "
    }
    BEGIN {
      lc_needle = tolower(needle)
      changed = 0
    }
    $0 == section {
      in_section = 1
      print
      next
    }
    in_section && /^== / {
      in_section = 0
    }
    in_section && is_journal_line($0) {
      body = line_body($0)
      if (index(tolower(body), lc_needle) > 0) {
        changed++
        if (mode == "remove") {
          next
        }
        if (mode == "replace") {
          st = (force_status != "" ? force_status : line_status($0))
          print normalize_new(st, new_raw)
          next
        }
      }
    }
    { print }
    END {
      print changed > count_file
      if (changed == 0) {
        exit 2
      }
    }
  ' "$JOURNAL" > "$tmp"

  local status=$?
  changed_count="$(cat "$count_file")"
  rm -f "$count_file"
  if [[ $status -eq 2 ]]; then
    rm -f "$tmp"
    echo "no matching line in $SECTION for: $needle" >&2
    exit 1
  fi
  if [[ $status -ne 0 ]]; then
    rm -f "$tmp"
    exit "$status"
  fi

  mv "$tmp" "$JOURNAL"
  printf '%s' "$changed_count"
}

require_journal

if [[ $# -lt 1 ]]; then
  usage
fi

command="$1"
shift

case "$command" in
  list)
    if ! section_exists; then
      echo "today section not found: $SECTION" >&2
      exit 1
    fi
    list_today
    ;;
  replace)
    force_status=""
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --done) force_status="DONE"; shift ;;
        --ongoing) force_status="ONGOING"; shift ;;
        --todo) force_status="TODO"; shift ;;
        -*) usage ;;
        *) break ;;
      esac
    done
    [[ $# -ge 2 ]] || usage
    needle="$1"
    shift
    new_raw="$*"
    changed="$(apply_change replace "$needle" "$new_raw" "$force_status")"
    if [[ -n "$force_status" ]]; then
      new_text="$(normalize_replace_line "$force_status" "$new_raw")"
    elif [[ "$new_raw" =~ ^(DONE|TODO|ONGOING):: ]]; then
      new_text="$new_raw"
    else
      new_text="$(normalize_replace_line "TODO" "$new_raw")"
    fi
    printf 'updated %s line(s) in %s under %s:\n%s\n' "$changed" "$JOURNAL" "$SECTION" "$new_text"
    ;;
  remove)
    [[ $# -ge 1 ]] || usage
    needle="$*"
    changed="$(apply_change remove "$needle" "" "")"
    printf 'removed %s line(s) from %s under %s matching: %s\n' "$changed" "$JOURNAL" "$SECTION" "$needle"
    ;;
  *)
    usage
    ;;
esac
