#!/usr/bin/env bash
# Tier-1 stray-file check: every tracked top-level entry must be a
# first-level node in the layout file `CLAUDE.md § Layout` declares.
# Catches unindexed files/dirs. Only git-tracked paths are considered,
# so gitignored scratch is exempt. The `^(├|└)── ` anchor matches
# first-level tree nodes only (nested entries are indented), avoiding
# prose substring false-negatives. Alternation (not a `[├└]` class)
# keeps the multibyte match byte-robust across locales - a `[...]`
# class of multibyte chars misbehaves under a C/POSIX locale.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

L=$(sed -n 's/^- Layout: *//p' CLAUDE.md 2>/dev/null | head -1 || true)
L=${L:-.claude/LAYOUT.md}

fail=0
while IFS= read -r top; do
  grep -qE "^(├|└)── ${top}([ /]|$)" "$L" \
    || { echo "STRAY: '$top' not a top-level node in $L"; fail=1; }
done < <(git ls-files | cut -d/ -f1 | sort -u)

(( fail == 0 )) && echo "check-stray: OK"
exit $fail
