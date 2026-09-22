#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

F=$(mktemp -d); git -C "$F" init -q; git -C "$F" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n- Test (full): `make test`\n' > "$F/CLAUDE.md"
bash "$INSTALL" --project "$F" >/dev/null 2>&1 || die "install (fast-tier fixture) exits nonzero"
grep -qxF -- '- Test (fast): `make lint`, then `bash .claude/scripts/ci/check-plan-text.sh`' "$F/CLAUDE.md" \
  && pass "gate appended to the Test (fast) line" || die "Test (fast) line: $(grep -F 'Test (fast)' "$F/CLAUDE.md")"
grep -qxF -- '- Test (full): `make test`' "$F/CLAUDE.md" && pass "Test (full) line untouched" || die "Test (full) line rewritten"
rm -rf "$F"

T=$(mktemp -d); git -C "$T" init -q; git -C "$T" checkout -qb work
printf '## Agent toolchain\n\n- Test: `npm test`\n' > "$T/CLAUDE.md"
bash "$INSTALL" --project "$T" --minimal >/dev/null 2>&1 || die "install (Test fixture, minimal) exits nonzero"
grep -qxF -- '- Test: `npm test`, then `bash .claude/scripts/ci/check-plan-text.sh`' "$T/CLAUDE.md" \
  && pass "minimal install appends the gate to the Test line" || die "Test line: $(grep -F 'Test:' "$T/CLAUDE.md")"
rm -rf "$T"

RI=$(mktemp -d); git -C "$RI" init -q; git -C "$RI" checkout -qb work
printf '## Agent toolchain\n\n- Test (fast): `make lint`\n' > "$RI/CLAUDE.md"
bash "$INSTALL" --project "$RI" --force >/dev/null 2>&1 || die "first install (re-install fixture) exits nonzero"
bash "$INSTALL" --project "$RI" --force >/dev/null 2>&1 || die "re-install exits nonzero"
grep -qxF -- '- Test (fast): `make lint`, then `bash .claude/scripts/ci/check-plan-text.sh`' "$RI/CLAUDE.md" \
  && pass "re-install leaves a line naming the gate as it is" || die "re-install line: $(grep -F 'Test (fast)' "$RI/CLAUDE.md")"
rm -rf "$RI"

NL=$(mktemp -d); git -C "$NL" init -q; git -C "$NL" checkout -qb work
printf '## Agent toolchain\n\n- Test (full): `make test`\n' > "$NL/CLAUDE.md"
out=$(bash "$INSTALL" --project "$NL" 2>&1) || die "install (no fast-tier line) exits nonzero"
printf '## Agent toolchain\n\n- Test (full): `make test`\n' | cmp -s - "$NL/CLAUDE.md" \
  && pass "no fast-tier line: CLAUDE.md untouched" || die "no fast-tier line: CLAUDE.md rewritten"
[ "$(grep -cF 'check-plan-text.sh`' <<<"$out")" = 1 ] && grep -F 'Test (fast):' <<<"$out" | grep -qF 'bash .claude/scripts/ci/check-plan-text.sh' \
  && pass "no fast-tier line: one notice names the line to add" || die "no fast-tier line notice: $out"
rm -rf "$NL"

NC=$(mktemp -d); git -C "$NC" init -q; git -C "$NC" checkout -qb work
out=$(bash "$INSTALL" --project "$NC" 2>&1) || die "install (no CLAUDE.md) exits nonzero"
[ ! -e "$NC/CLAUDE.md" ] && pass "no CLAUDE.md: none written" || die "no CLAUDE.md: one was written"
[ "$(grep -cF 'check-plan-text.sh`' <<<"$out")" = 1 ] && grep -F 'Test (fast):' <<<"$out" | grep -qF 'bash .claude/scripts/ci/check-plan-text.sh' \
  && pass "no CLAUDE.md: one notice names the line to add" || die "no CLAUDE.md notice: $out"
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
grep -qxF -- '- Test (fast): `make lint`' "$GH/.claude/CLAUDE.md" && ! grep -qF check-plan-text "$GH/.claude/CLAUDE.md" \
  && pass "global install leaves the fast-tier line alone" || die "global install rewrote the fast-tier line"
rm -rf "$GH"

(( fail == 0 )) && echo "install-dev-fast-tier.test: OK"
exit $fail
