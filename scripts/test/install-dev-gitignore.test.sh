#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# A project still declaring the retired Session: tree installs as before and
# gets no ignore line for it or a supervisor/ beside it.
DS=$(mktemp -d); git -C "$DS" init -q; git -C "$DS" checkout -qb work; mkdir -p "$DS/.claude"
printf '## Layout\n\n- Session: var/state/\n' > "$DS/.claude/CLAUDE.md"
bash "$INSTALL" --project "$DS" >/dev/null 2>&1 || die "install (.claude/ Session fixture) exits nonzero"
! grep -qE '^/?var/(state|supervisor)/$' "$DS/.gitignore" 2>/dev/null \
  && pass "the session tree .claude/CLAUDE.md declares gets no ignore line" || die ".claude/ Session ignore lines: $(tr '\n' ' ' < "$DS/.gitignore")"
rm -rf "$DS"

(( fail == 0 )) && echo "install-dev-gitignore.test: OK"
exit $fail
