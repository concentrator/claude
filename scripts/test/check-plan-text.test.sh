#!/usr/bin/env bash
# Tests scripts/ci/check-plan-text.sh in throwaway git repos.
# Run: bash scripts/test/check-plan-text.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
CHECK="$(cd "$(dirname "${BASH_SOURCE[0]}")/../ci" && pwd)/check-plan-text.sh"
[ -f "$CHECK" ] || { echo "not ok - $CHECK not found"; exit 1; }
OWN=R100
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
commit_in() { git -C "$1" add -A; git -C "$1" -c user.email=t@t -c user.name=t commit -qm "$2"; }

mkrepo() { # main holds a roadmap and a legacy initiative; the branch adds $OWN-x
  local d; d=$(mktemp -d); git -C "$d" init -q -b "${1:-main}"
  mkdir -p "$d/dev/plans/R090-old"
  printf '# Roadmap\n\n- [ ] %s: Title - what it delivers.\n' "$OWN" > "$d/dev/plans/ROADMAP.md"
  printf 'See https://example.com on 2026-01-01, #12, R001.\n' > "$d/dev/plans/R090-old/requirements.md"
  commit_in "$d" init
  git -C "$d" checkout -q -b feat
  mkdir -p "$d/dev/plans/$OWN-x"
  printf '# %s: Title\n\n## Goal\n\nA goal.\n' "$OWN" > "$d/dev/plans/$OWN-x/requirements.md"
  printf '# %s tasks\n\n- [ ] **%s-T001 [mnt]**: do a thing.\n' "$OWN" "$OWN" > "$d/dev/plans/$OWN-x/tasks.md"
  printf '%s' "$d"
}
run_in() { ( cd "$1" && git add -A && bash "$CHECK" 2>&1 ); }

d=$(mkrepo)
out=$(run_in "$d") && pass "clean changes pass, unchanged legacy text skipped" || die "clean failed: $out"
rm -rf "$d"

expect() { # description, file under dev/plans, content, expected reason
  local d out; d=$(mkrepo)
  mkdir -p "$(dirname "$d/dev/plans/$2")"
  printf '%s\n' "$3" >> "$d/dev/plans/$2"
  out=$(run_in "$d")
  case "$out" in *"$4"*) pass "$1" ;; *) die "$1: $out" ;; esac
  rm -rf "$d"
}
expect "URL caught"            "$OWN-x/requirements.md" "Spec: https://example.com" "link"
expect "markdown link caught"  "$OWN-x/tasks.md"        "See [doc](docs/x.md)"      "link"
expect "date caught"           "$OWN-x/tasks.md"        "Probed 2026-09-17."        "date"
expect "PR ref caught"         "$OWN-x/requirements.md" "Shipped in #545."          "#NNN ref"
expect "commit hash caught"    "$OWN-x/tasks.md"        "Fixed by b0182f8."         "commit hash"
expect "foreign id caught"     "$OWN-x/tasks.md"        "Builds on R000-T002."      "id of another initiative: R000"
expect "long task entry caught" "$OWN-x/tasks.md" "$(printf -- '- [ ] **%s-T002 [mnt]**: a\n  b\n  c\n  d' "$OWN")" "entry over 3 lines"
expect "wrapped backlog paragraph caught" "$OWN-x/tasks.md" "$(printf '\nBacklog: a note\nwrapped onto a second line.')" "tasks.md:5: backlog line over 1 line"
expect "wrapped backlog bullet caught" "$OWN-x/tasks.md" "$(printf '\n- a backlog note\n  wrapped under its bullet.')" "tasks.md:5: backlog line over 1 line"
d=$(mkrepo)
printf '# %s tasks\n\nWhy: a reason that\nwraps.\n\n## Open\n\n- [ ] **%s-T001 [mnt]**: a\n  b.\n\n- one backlog note.\n- another one.\n\nBacklog: a line.\n' "$OWN" "$OWN" > "$d/dev/plans/$OWN-x/tasks.md"
out=$(run_in "$d") && pass "one-line backlog lines pass" || die "one-line backlog lines failed: $out"
rm -rf "$d"
expect "changed legacy initiative checked" "R090-old/requirements.md" "More." "PLAN-TEXT: dev/plans/R090-old/requirements.md:1: link"
expect "R-NNN dir checked"     "R-083-y/tasks.md"       "Builds on R000-T002."      "id of another initiative: R000"

d=$(mkrepo)
mkdir -p "$d/dev/plans/R-083-y"
printf -- '- [ ] **R-083-T001 [mnt]**: own id.\n' > "$d/dev/plans/R-083-y/tasks.md"
out=$(run_in "$d") && pass "R-NNN dir's own id passes" || die "R-NNN own id failed: $out"
rm -rf "$d"

d=$(mkrepo)
mkdir -p "$d/dev/plans/archive/R050-z"
printf 'See https://example.com.\n' > "$d/dev/plans/archive/R050-z/requirements.md"
printf -- '- [ ] **R050-T001**: https://example.com\n' > "$d/dev/plans/archive/ROADMAP.md"
out=$(run_in "$d") && pass "archive excluded" || die "archive checked: $out"
rm -rf "$d"

d=$(mkrepo)
printf 'Spec: https://example.com\n' >> "$d/dev/plans/$OWN-x/requirements.md"
commit_in "$d" branch-work
out=$(run_in "$d"); case "$out" in *"link"*) pass "committed branch change caught" ;; *) die "committed change: $out" ;; esac
rm -rf "$d"

d=$(mkrepo trunk)
printf 'Spec: https://example.com\n' >> "$d/dev/plans/$OWN-x/requirements.md"
out=$(run_in "$d"); rc=$?
[ $rc -eq 0 ] && grep -q 'check-plan-text: SKIP (no default branch)' <<<"$out" \
  && pass "no default branch skips by name" || die "no default branch (rc=$rc): $out"
rm -rf "$d"

expect "finding without evidence caught" "$OWN-x/$OWN-T001-x.report.md" "$(printf -- '- [ ] shape may differ\n  Evidence: hypothetical reading of code')" "finding without Evidence"
d=$(mkrepo)
printf -- '- [ ] 400 on empty body\n  Evidence: observed curl response in the probe\n' > "$d/dev/plans/$OWN-x/$OWN-T001-x.report.md"
out=$(run_in "$d") && pass "finding with evidence passes" || die "finding with evidence failed: $out"
rm -rf "$d"

expect "added findings file caught" "$OWN-x/$OWN-T001-x.findings.md" "- a note" "PLAN-TEXT: dev/plans/$OWN-x/$OWN-T001-x.findings.md: findings file: use the task report"
with_findings() { # repo: main gains a findings file the branch then merges
  git -C "$1" checkout -q main
  printf -- '- an old finding\n' > "$1/dev/plans/R090-old/R090-T001-old.findings.md"
  commit_in "$1" findings
  git -C "$1" checkout -q feat
  git -C "$1" -c user.email=t@t -c user.name=t merge -q --no-edit main
}
d=$(mkrepo); with_findings "$d"
printf -- '- another finding\n' >> "$d/dev/plans/R090-old/R090-T001-old.findings.md"
out=$(run_in "$d") && pass "existing findings file passes" || die "existing findings file failed: $out"
rm -rf "$d"
d=$(mkrepo); with_findings "$d"
git -C "$d" mv dev/plans/R090-old/R090-T001-old.findings.md dev/plans/R090-old/R090-T001-kept.findings.md
out=$(run_in "$d") && pass "renamed findings file passes" || die "renamed findings file failed: $out"
rm -rf "$d"

item() { printf -- '- [ ] an item\n'; for i in $(seq 2 "$1"); do printf '  line %s\n' "$i"; done; }
d=$(mkrepo)
item 6 > "$d/dev/plans/$OWN-x/$OWN-T001-x.md"
out=$(run_in "$d") && pass "6-line plan item passes" || die "6-line plan item failed: $out"
rm -rf "$d"
expect "7-line plan item caught" "$OWN-x/$OWN-T001-x.md" "$(item 7)" "PLAN-TEXT: dev/plans/$OWN-x/$OWN-T001-x.md:1: item over 6 lines"
d=$(mkrepo)
mkdir -p "$d/dev/plans/$OWN-x/batches"
item 7 > "$d/dev/plans/$OWN-x/batches/B001.md"
out=$(run_in "$d") && pass "batches excluded from the plan check" || die "batches checked: $out"
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
