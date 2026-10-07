#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
PT='`bash .claude/scripts/ci/check-plan-text.sh`'
CS='`bash .claude/scripts/ci/check-code-size.sh`'
GATES=", then $PT, then $CS"

F=$(mktemp -d); git -C "$F" init -q; git -C "$F" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n- Test (full): `make test`\n' > "$F/CLAUDE.md"; chmod 644 "$F/CLAUDE.md"
out=$(bash "$INSTALL" --project "$F" 2>&1) || die "install (fast-tier fixture) exits nonzero"
[ "$(ls -l "$F/CLAUDE.md" | cut -c1-10)" = "-rw-r--r--" ] && pass "gate append keeps the CLAUDE.md mode" || die "CLAUDE.md mode: $(ls -l "$F/CLAUDE.md" | cut -c1-10)"
grep -qxF -- '- Test (fast): `make lint`'"$GATES" "$F/CLAUDE.md" \
  && pass "gates appended to the Test (fast) line, plan-text first" || die "Test (fast) line: $(grep -F 'Test (fast)' "$F/CLAUDE.md")"
grep -qxF -- '- Test (full): `make test`' "$F/CLAUDE.md" && pass "Test (full) line untouched" || die "Test (full) line rewritten"
[ "$(grep -c 'CI must run the fast tier' <<<"$out")" = 1 ] && pass "project install prints the CI notice" || die "CI notice: $out"
rm -rf "$F"

T=$(mktemp -d); git -C "$T" init -q; git -C "$T" checkout -qb work
printf '## Agent toolchain\n\n- Test: `npm test`\n' > "$T/CLAUDE.md"
out=$(bash "$INSTALL" --project "$T" --minimal 2>&1) || die "install (Test fixture, minimal) exits nonzero"
grep -qxF -- '- Test: `npm test`'"$GATES" "$T/CLAUDE.md" \
  && pass "minimal install appends the gates to the Test line" || die "Test line: $(grep -F 'Test:' "$T/CLAUDE.md")"
[ "$(grep -c 'CI must run the fast tier' <<<"$out")" = 1 ] && pass "minimal install prints the CI notice" || die "minimal CI notice: $out"
rm -rf "$T"

DC=$(mktemp -d); git -C "$DC" init -q; git -C "$DC" checkout -qb work; mkdir -p "$DC/.claude"
printf '# Project\n' > "$DC/CLAUDE.md"
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n' > "$DC/.claude/CLAUDE.md"
out=$(bash "$INSTALL" --project "$DC" 2>&1) || die "install (.claude/ fast-tier fixture) exits nonzero"
grep -qxF -- '- Test (fast): `make lint`'"$GATES" "$DC/.claude/CLAUDE.md" && printf '# Project\n' | cmp -s - "$DC/CLAUDE.md" \
  && pass "gates appended to the Test (fast) line of .claude/CLAUDE.md" || die ".claude/ Test (fast) line: $(grep -F 'Test (fast)' "$DC/.claude/CLAUDE.md")"
grep -F 'CI must run the fast tier' <<<"$out" | grep -qF '/.claude/CLAUDE.md)' && pass "CI notice names the file holding the line" || die ".claude/ CI notice: $out"
rm -rf "$DC"

RI=$(mktemp -d); git -C "$RI" init -q; git -C "$RI" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n' > "$RI/CLAUDE.md"
bash "$INSTALL" --project "$RI" --force >/dev/null 2>&1 || die "first install (re-install fixture) exits nonzero"
bash "$INSTALL" --project "$RI" --force >/dev/null 2>&1 || die "re-install exits nonzero"
grep -qxF -- '- Test (fast): `make lint`'"$GATES" "$RI/CLAUDE.md" \
  && pass "re-install leaves a line naming both gates as it is" || die "re-install line: $(grep -F 'Test (fast)' "$RI/CLAUDE.md")"
rm -rf "$RI"

RM=$(mktemp -d); git -C "$RM" init -q; git -C "$RM" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint`, then %s\n' "$PT" > "$RM/CLAUDE.md"
bash "$INSTALL" --project "$RM" --force >/dev/null 2>&1 || die "re-install (plan-text only fixture) exits nonzero"
grep -qxF -- '- Test (fast): `make lint`'"$GATES" "$RM/CLAUDE.md" \
  && pass "re-install adds the missing code-size gate only" || die "plan-text only line: $(grep -F 'Test (fast)' "$RM/CLAUDE.md")"
rm -rf "$RM"

RC=$(mktemp -d); git -C "$RC" init -q; git -C "$RC" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint`, then %s\n' "$CS" > "$RC/CLAUDE.md"
bash "$INSTALL" --project "$RC" --force >/dev/null 2>&1 || die "re-install (code-size only fixture) exits nonzero"
grep -qxF -- '- Test (fast): `make lint`'", then $CS, then $PT" "$RC/CLAUDE.md" \
  && pass "a line naming the code-size gate gets only the plan-text gate" || die "code-size only line: $(grep -F 'Test (fast)' "$RC/CLAUDE.md")"
rm -rf "$RC"

W=$(mktemp -d); git -C "$W" init -q; git -C "$W" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint` - the glob is\n  required.\n- Test (full): `make test`\n' > "$W/CLAUDE.md"
bash "$INSTALL" --project "$W" --force >/dev/null 2>&1 || die "install (wrapped-line fixture) exits nonzero"
bash "$INSTALL" --project "$W" --force >/dev/null 2>&1 || die "re-install (wrapped-line fixture) exits nonzero"
printf '## Agent toolchain\n\n- Test (fast): `make lint` - the glob is\n  required%s\n- Test (full): `make test`\n' "$GATES" | cmp -s - "$W/CLAUDE.md" \
  && pass "gates appended once to a wrapped line's last line" || die "wrapped line: $(sed -n 3,5p "$W/CLAUDE.md")"
rm -rf "$W"

NL=$(mktemp -d); git -C "$NL" init -q; git -C "$NL" checkout -qb work
printf '## Agent toolchain\n\n- Test (full): `make test`\n' > "$NL/CLAUDE.md"
out=$(bash "$INSTALL" --project "$NL" 2>&1) || die "install (no fast-tier line) exits nonzero"
printf '## Agent toolchain\n\n- Test (full): `make test`\n' | cmp -s - "$NL/CLAUDE.md" \
  && pass "no fast-tier line: CLAUDE.md untouched" || die "no fast-tier line: CLAUDE.md rewritten"
[ "$(grep -cF 'check-plan-text.sh`' <<<"$out")" = 1 ] && grep -F 'Test (fast):' <<<"$out" | grep -qF "<fast tier>$GATES" \
  && pass "no fast-tier line: one notice names the line to add, with both gates" || die "no fast-tier line notice: $out"
rm -rf "$NL"

NC=$(mktemp -d); git -C "$NC" init -q; git -C "$NC" checkout -qb work
out=$(bash "$INSTALL" --project "$NC" 2>&1) || die "install (no CLAUDE.md) exits nonzero"
[ ! -e "$NC/CLAUDE.md" ] && pass "no CLAUDE.md: none written" || die "no CLAUDE.md: one was written"
[ "$(grep -cF 'check-plan-text.sh`' <<<"$out")" = 1 ] && grep -F 'Test (fast):' <<<"$out" | grep -qF "<fast tier>$GATES" \
  && pass "no CLAUDE.md: one notice names the line to add, with both gates" || die "no CLAUDE.md notice: $out"
grep -F 'Test (fast): <fast tier>' <<<"$out" | grep -qE '/CLAUDE\.md or .*/\.claude/CLAUDE\.md - ' \
  && pass "no CLAUDE.md: the notice names both instruction files" || die "no CLAUDE.md notice files: $out"
rm -rf "$NC"

NG=$(mktemp -d)
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n' > "$NG/CLAUDE.md"
bash "$INSTALL" --project "$NG" >/dev/null 2>&1 || die "non-git install exits nonzero"
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n' | cmp -s - "$NG/CLAUDE.md" \
  && pass "non-git install leaves CLAUDE.md alone" || die "non-git install rewrote CLAUDE.md"
rm -rf "$NG"

GH=$(mktemp -d); mkdir -p "$GH/.claude"
printf -- '- Test (fast): `make lint`\n' > "$GH/.claude/CLAUDE.md"
HOME="$GH" bash "$INSTALL" >/dev/null 2>&1 || die "global install exits nonzero"
grep -qxF -- '- Test (fast): `make lint`' "$GH/.claude/CLAUDE.md" && ! grep -qE 'check-(plan-text|code-size)' "$GH/.claude/CLAUDE.md" \
  && pass "global install leaves the fast-tier line alone" || die "global install rewrote the fast-tier line"
rm -rf "$GH"

TR=$(mktemp -d); git -C "$TR" init -q; git -C "$TR" checkout -qb work
printf -- '- Test (fast): `make lint`, then %s; runs per commit.\n- Test (full): `make test`.\n' "$PT" > "$TR/CLAUDE.md"
bash "$INSTALL" --project "$TR" >/dev/null 2>&1 || die "install (trailing-text fixture) exits nonzero"
grep -qxF -- "- Test (fast): \`make lint\`, then $PT, then $CS; runs per commit." "$TR/CLAUDE.md" \
  && pass "gate inserted after the last command, before trailing text" || die "trailing-text line: $(grep -F 'Test (fast)' "$TR/CLAUDE.md")"
printf -- '- Test (fast): `make lint`.\n' > "$TR/CLAUDE.md"
bash "$INSTALL" --project "$TR" --force >/dev/null 2>&1 || die "re-install (period fixture) exits nonzero"
grep -qxF -- "- Test (fast): \`make lint\`$GATES." "$TR/CLAUDE.md" \
  && pass "gates inserted before a closing period" || die "period line: $(grep -F 'Test (fast)' "$TR/CLAUDE.md")"
rm -rf "$TR"

(( fail == 0 )) && echo "install-dev-fast-tier.test: OK"
exit $fail
