#!/usr/bin/env bash
# Tier-1 cap check: CLAUDE.md / DESIGN.md / SKILL.md / dev mode-file size
# limits. Caps per rules/skills.md § Size and skills/dev/layout.md; this
# repo's CLAUDE.md is held to 100 lines, inside rules/claude-md.md's general
# 200. SKILL body = file minus YAML frontmatter (skills.md caps are on
# body). Mode files are measured in lines and line length, never words:
# a word count does not measure a document (R040-T025).
# Skill class lists below mirror skills.md § Size; new skills default to
# the general 300-word cap. Only git-tracked files are checked, so
# gitignored project skills (e.g. wallarm-*) are out of scope.
set -euo pipefail
export LC_ALL=C.UTF-8   # ${#line} counts characters, not bytes
cd "$(git rev-parse --show-toplevel)"
ROOT="."

fail=0
report() { echo "CAP: $1"; fail=1; }

(( $(wc -l < "$ROOT/CLAUDE.md") <= 100 )) || report "CLAUDE.md $(wc -l < "$ROOT/CLAUDE.md") lines > 100"
(( $(wc -w < "$ROOT/DESIGN.md") <= 1000 )) || report "DESIGN.md $(wc -w < "$ROOT/DESIGN.md") words > 1000"

orchestrators=" dev "
reference=" writing-skills verification-before-completion receiving-code-review dispatching-parallel-agents test-driven-development systematic-debugging "

body_words() { awk 'NR==1&&/^---/{f=1;next} f&&/^---/{f=0;next} !f' "$1" | wc -w; }

while IFS= read -r f; do
  name=$(basename "$(dirname "$f")")
  key="$name"
  cap=300
  case "$orchestrators" in *" $key "*) cap=400 ;; esac
  case "$reference"     in *" $key "*) cap=1500 ;; esac
  bw=$(body_words "$f")
  (( bw <= cap )) || report "$f body $bw words > $cap"
  dw=$(sed -n 's/^description: //p' "$f" | wc -w)
  (( dw <= 12 )) || report "$f description $dw words > 12"
done < <(git ls-files "$ROOT/skills" | grep '/SKILL\.md$')

# R-021: skills/dev/ mode files (read on demand by the dev router) - 300
# lines, 80 characters a line; a table row cannot wrap, so it is exempt from
# the length ceiling. SKILL.md handled above; companions/ are exempt.
while IFS= read -r f; do
  ln=$(( $(wc -l < "$f") ))
  (( ln <= 300 )) || report "$f $ln lines > 300"
  n=0
  while IFS= read -r line || [ -n "$line" ]; do
    n=$((n + 1))
    t="${line#"${line%%[![:space:]]*}"}"
    [ "${t:0:1}" = '|' ] && continue
    (( ${#line} <= 80 )) || { report "$f line $n: ${#line} characters > 80"; break; }
  done < "$f"
done < <(git ls-files "$ROOT/skills/dev" | grep -E '(^|/)skills/dev/[^/]+\.md$' | grep -v '/SKILL\.md$')

(( fail == 0 )) && echo "check-caps: OK"
exit $fail
