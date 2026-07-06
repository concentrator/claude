#!/usr/bin/env bash
# check-code-size.sh - Tier-1 code-size gate (R-022).
# Flags tracked code files over 300 lines, and shell functions over 50 lines.
# Per-path exemptions live in scripts/ci/code-size-allow.txt (one path per
# line; text after `#` is an ignored reason). Function-length is checked for
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
cd "$(git rev-parse --show-toplevel)"

FILE_MAX=300
FUNC_MAX=50
ALLOW="scripts/ci/code-size-allow.txt"

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

while IFS= read -r f; do
  is_allowed "$f" && continue
  n=$(awk 'END{print NR+0}' "$f")       # counts a final line with no newline
  (( n <= FILE_MAX )) || report "$f is $n lines > $FILE_MAX"
  case "$f" in
    *.sh | *.bash)
      overs=$(awk -v max="$FUNC_MAX" -v file="$f" '
        function emit(endnr,   len) {
          len = endnr - start + 1
          if (len > max) print file ": function " name " is " len " lines > " max
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
      ' "$f")
      [ -n "$overs" ] && while IFS= read -r line; do report "$line"; done <<< "$overs"
      ;;
  esac
done < <(git ls-files | grep -E '\.(sh|bash|js|mjs|cjs|jsx|ts|tsx|py|go|rb|rs)$')

(( fail == 0 )) && echo "check-code-size: OK"
exit $fail
