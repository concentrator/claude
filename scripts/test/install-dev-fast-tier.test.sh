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

(( fail == 0 )) && echo "install-dev-fast-tier.test: OK"
exit $fail
