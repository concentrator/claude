#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# --- committability: restrictive .claude/* gitignore → installed paths trackable ---
G=$(mktemp -d); git -C "$G" init -q
git -C "$G" checkout -qb work   # keep the fixture off a default branch in case it gains commits
printf '.claude/*\n' > "$G/.gitignore"
bash "$INSTALL" --project "$G" >/dev/null 2>&1 || die "install (gitignore fixture) exits nonzero"
still=""
for p in .claude/skills .claude/agents/dev-implementer.md .claude/hooks/dev-branch-guard.sh .claude/scripts/ci/check-code-size.sh .claude/writing.md .claude/dev-instructions.md .claude/rules/writing-artifacts.md .claude/settings.json .claude/MAINTENANCE.md .claude/dev-install-manifest.txt; do
  git -C "$G" check-ignore -q "$p" && still="$still $p"
done
[ -z "$still" ] && pass "installed paths trackable under .claude/* gitignore" || die "still ignored:$still"
bash "$INSTALL" --project "$G" >/dev/null 2>&1
[ "$(grep -c '^!.claude/hooks/$' "$G/.gitignore")" = "1" ] && pass "gitignore allowlist idempotent" || die "duplicate allowlist entries"
! grep -qE '(session|supervisor)/$' "$G/.gitignore" && pass "no session or supervisor ignore line written" || die "ignore lines: $(tr '\n' ' ' < "$G/.gitignore")"
rm -rf "$G"

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
