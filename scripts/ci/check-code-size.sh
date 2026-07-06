#!/usr/bin/env bash
# check-code-size.sh - Tier-1 code-size gate (R-022).
# Flags tracked code files over 300 lines, and shell functions over 50 lines.
# Per-path exemptions live in scripts/ci/code-size-allow.txt (one path per
# line; text after `#` is an ignored reason). Function-length is checked for
# shell only, where `name() {` reliably marks a function and control flow uses
# then/do/fi rather than braces; js and other languages get the file-size
# check only (a line-based function scan there collides with control flow).
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

FILE_MAX=300
FUNC_MAX=50
ALLOW="scripts/ci/code-size-allow.txt"

is_allowed() {
  [ -f "$ALLOW" ] || return 1
  local p
  while IFS= read -r p; do
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
  n=$(wc -l < "$f")
  (( n <= FILE_MAX )) || report "$f is $n lines > $FILE_MAX"
  case "$f" in
    *.sh | *.bash)
      overs=$(awk -v max="$FUNC_MAX" -v file="$f" '
        /^[A-Za-z_][A-Za-z0-9_]*\(\)[ \t]*\{[ \t]*$/ { inf=1; start=NR; name=$0; next }
        inf && /^\}[ \t]*$/ {
          if (NR-start+1 > max) print file ": function " name " is " (NR-start+1) " lines > " max
          inf=0
        }
      ' "$f")
      [ -n "$overs" ] && while IFS= read -r line; do report "$line"; done <<< "$overs"
      ;;
  esac
done < <(git ls-files | grep -E '\.(sh|bash|js|mjs|cjs|jsx|ts|tsx|py|go|rb|rs)$')

(( fail == 0 )) && echo "check-code-size: OK"
exit $fail
