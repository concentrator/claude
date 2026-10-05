#!/usr/bin/env bash
# check-code-size.sh - Tier-1 code-size gate (R-022).
# Flags code files over 300 lines, and shell functions over 50 lines.
# Per-path exemptions live in code-size-allow.txt beside this script (one
# path per line, relative to the repo root; text after `#` is an ignored
# reason), so an installed copy under .claude/scripts/ci/ reads its own. Function-length is checked for
# shell only, where control flow uses then/do/fi rather than braces; js and
# other languages get the file-size check only (a line-based function scan
# there collides with control-flow braces).
#
# The shell function scan is a heuristic. It recognises `name() {`,
# `function name {`, and `function name() {` (with optional trailing content),
# and measures to the closing `}` at the opener's own indent; an opener left
# unclosed at end-of-file is measured to EOF so an oversize is never silently
# passed. Residual limit: a `}` at the opener's indent inside a heredoc or
# string closes the scan early and can under-count - allowlist such a file.
set -uo pipefail
h="$(dirname "${BASH_SOURCE[0]}")/branch-diff.sh"
{ [ -r "$h" ] && . "$h"; } \
  || { echo "check-code-size: cannot load branch-diff.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

FILE_MAX=300
FUNC_MAX=50
ALLOW="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/code-size-allow.txt"

is_allowed() {
  [ -f "$ALLOW" ] || return 1
  local p
  while IFS= read -r p || [ -n "$p" ]; do
    p="${p%%#*}"                       # drop reason
    p="${p#"${p%%[![:space:]]*}"}"     # ltrim
    p="${p%"${p##*[![:space:]]}"}"     # rtrim
    [ -n "$p" ] && [ "$p" = "$1" ] && return 0
  done < "$ALLOW"
  return 1
}

fail=0
report() { echo "CODE-SIZE: $1"; fail=1; }

base=$(branch_base) || base=
old=$(mktemp); trap 'rm -f "$old"' EXIT

func_overs() {
  awk -v max="$FUNC_MAX" '
        function emit(endnr,   len, key) {
          len = endnr - start + 1
          if (len > max) { key = name; sub(/[ \t]*\(\)$/, "", key); print key "\t" name "\t" len }
          inf = 0
        }
        !inf && ( $0 ~ /^[ \t]*[A-Za-z_][A-Za-z0-9_]*[ \t]*\(\)[ \t]*\{/ ||
                  $0 ~ /^[ \t]*function[ \t]+[A-Za-z_][A-Za-z0-9_]*([ \t]*\(\))?[ \t]*\{/ ) {
          if ($0 ~ /\{.*\}/) next             # one-liner function (open + close on the line)
          inf = 1; start = NR
          indent = $0; sub(/[^ \t].*/, "", indent)
          name = $0; sub(/[ \t]*\{.*/, "", name); sub(/^[ \t]+/, "", name); sub(/^function[ \t]+/, "", name)
          next
        }
        inf && NR > start && $0 ~ ("^" indent "\\}([ \t].*)?$") { emit(NR) }
        END { if (inf) emit(NR) }
      ' "$1"
}

while IFS=$'\t' read -r _ f from; do
  is_allowed "$f" && continue
  : > "$old"
  [ -z "$from" ] || git show "$base:$from" > "$old" 2>/dev/null || : > "$old"
  n=$(awk 'END{print NR+0}' "$f")       # counts a final line with no newline
  was=$(awk 'END{print NR+0}' "$old")
  (( n <= FILE_MAX || was > FILE_MAX )) || report "$f is $n lines > $FILE_MAX"
  case "$f" in
    *.sh | *.bash)
      had=$(func_overs "$old" | cut -f1)
      while IFS=$'\t' read -r key name len; do
        grep -qxF -- "$key" <<< "$had" || report "$f: function $name is $len lines > $FUNC_MAX"
      done < <(func_overs "$f")
      ;;
  esac
done < <(branch_changed "$base" | awk -F '\t' '$2 ~ /\.(sh|bash|js|mjs|cjs|jsx|ts|tsx|py|go|rb|rs)$/')

(( fail == 0 )) && echo "check-code-size: OK"
exit $fail
