#!/usr/bin/env bash
# Tier-1 cap check: CLAUDE.md / DESIGN.md / SKILL.md size limits.
# Caps per rules/claude-md.md, rules/skills.md § Size, skills/dev/layout.md.
# SKILL body = file minus YAML frontmatter (skills.md caps are on body).
# Skill class lists below mirror skills.md § Size; new skills default to
# the general 300-word cap. Only git-tracked files are checked, so
# gitignored project skills (e.g. wallarm-*) are out of scope.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
ROOT="."

fail=0
report() { echo "CAP: $1"; fail=1; }

(( $(wc -l < "$ROOT/CLAUDE.md") <= 200 )) || report "CLAUDE.md $(wc -l < "$ROOT/CLAUDE.md") lines > 200"
(( $(wc -w < "$ROOT/CLAUDE.md") <= 400 )) || report "CLAUDE.md $(wc -w < "$ROOT/CLAUDE.md") words > 400"
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

# R-021: skills/dev/ companion mode files (read on demand by the dev router)
# - reference tier (1500w). SKILL.md handled above; companions/ are exempt.
while IFS= read -r f; do
  ww=$(wc -w < "$f")
  (( ww <= 1500 )) || report "$f $ww words > 1500"
done < <(git ls-files "$ROOT/skills/dev" | grep -E '(^|/)skills/dev/[^/]+\.md$' | grep -v '/SKILL\.md$')

(( fail == 0 )) && echo "check-caps: OK"
exit $fail
