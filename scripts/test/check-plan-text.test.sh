#!/usr/bin/env bash
# Tests scripts/ci/check-plan-text.sh in throwaway git repos.
# Run: bash scripts/test/check-plan-text.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-plan-text.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
OWN=$(sed -n "s/^FROM='\\(R[0-9]*\\)'.*/\\1/p" "$CHECK")
[ -n "$OWN" ] || { echo "not ok - no FROM line in $CHECK"; exit 1; }
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

mkrepo() {
  local d; d=$(mktemp -d); git -C "$d" init -q
  mkdir -p "$d/dev/plans/$OWN-x" "$d/dev/plans/R000-old"
  printf '# Roadmap\n\n- [ ] %s: Title - what it delivers.\n' "$OWN" > "$d/dev/plans/ROADMAP.md"
  printf '# %s: Title\n\n## Goal\n\nA goal.\n' "$OWN" > "$d/dev/plans/$OWN-x/requirements.md"
  printf '# %s tasks\n\n- [ ] **%s-T001 [mnt]**: do a thing.\n' "$OWN" "$OWN" > "$d/dev/plans/$OWN-x/tasks.md"
  printf 'See https://example.com on 2026-01-01, #12, R000.\n' > "$d/dev/plans/R000-old/requirements.md"
  printf '%s' "$d"
}
run_in() { ( cd "$1" && git add -A && bash "$CHECK" 2>&1 ); }

d=$(mkrepo)
out=$(run_in "$d") && pass "clean artifacts pass, legacy initiative skipped" || die "clean failed: $out"
rm -rf "$d"

expect() { # description, file under $OWN-x, content, expected reason
  local d out; d=$(mkrepo)
  printf '%s\n' "$3" >> "$d/dev/plans/$OWN-x/$2"
  out=$(run_in "$d")
  case "$out" in *"$4"*) pass "$1" ;; *) die "$1: $out" ;; esac
  rm -rf "$d"
}
expect "URL caught"            requirements.md "Spec: https://example.com" "link"
expect "markdown link caught"  tasks.md        "See [doc](docs/x.md)"      "link"
expect "date caught"           tasks.md        "Probed 2026-09-17."        "date"
expect "PR ref caught"         requirements.md "Shipped in #545."          "#NNN ref"
expect "commit hash caught"    tasks.md        "Fixed by b0182f8."         "commit hash"
expect "foreign id caught"     tasks.md        "Builds on R000-T002."       "id of another initiative: R000"
expect "long task entry caught" tasks.md "$(printf -- '- [ ] **%s-T002 [mnt]**: a\n  b\n  c\n  d' "$OWN")" "entry over 3 lines"

expect "finding without evidence caught" "$OWN-T001-x.report.md" "$(printf -- '- [ ] shape may differ\n  Evidence: hypothetical reading of code')" "finding without Evidence"
d=$(mkrepo)
printf -- '- [ ] 400 on empty body\n  Evidence: observed curl response in the probe\n' > "$d/dev/plans/$OWN-x/$OWN-T001-x.report.md"
out=$(run_in "$d") && pass "finding with evidence passes" || die "finding with evidence failed: $out"
rm -rf "$d"

d=$(mkrepo)
for i in $(seq 1 40); do echo "line $i"; done >> "$d/dev/plans/$OWN-x/requirements.md"
out=$(run_in "$d"); case "$out" in *"over 40 lines"*) pass "long requirements caught" ;; *) die "long requirements: $out" ;; esac
rm -rf "$d"

d=$(mkrepo)
printf '      one\n      two\n      three\n' >> "$d/dev/plans/ROADMAP.md"
out=$(run_in "$d"); case "$out" in *"entry over 3 lines"*) pass "long roadmap entry caught" ;; *) die "long roadmap entry: $out" ;; esac
rm -rf "$d"

[ "$fail" -eq 0 ] && echo "check-plan-text.test: OK"
exit "$fail"
