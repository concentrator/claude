#!/usr/bin/env bash
# Tests hooks/dev-branch-guard.sh push rules (R-058): a force push in any
# spelling (-f, --force in any position, --force-with-lease, +refspec) and
# a push targeting the repo's default branch (refspec, :dest, HEAD, bare)
# are denied - in every push segment of a compound command, judged by the
# resolved -C/cd repo even when earlier text contains "push"; a task-branch
# push passes; echo text never triggers. Companion of
# dev-branch-guard.test.sh, split out under the code-size cap; helpers and
# fixtures mirror it.
# Run: bash scripts/test/dev-push-guard.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Host git config must not leak into fixtures (the guard resolves
# init.defaultBranch; NOSYSTEM for Apple git's vendor config).
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
HOOK="$(git rev-parse --show-toplevel)/hooks/dev-branch-guard.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Run the hook with JSON on stdin from the current cwd; echo deny/allow.
run() { printf '%s' "$1" | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow; }

# --- force pushes are denied in any spelling ---
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push -f origin feat/x"}}')
[ "$(run "$j")" = deny ] && pass "push -f denied" || die "push -f allowed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push origin feat/x --force"}}')
[ "$(run "$j")" = deny ] && pass "trailing --force denied" || die "trailing --force allowed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push --force-with-lease origin feat/x"}}')
[ "$(run "$j")" = deny ] && pass "--force-with-lease denied" || die "--force-with-lease allowed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push origin +feat/x"}}')
[ "$(run "$j")" = deny ] && pass "+refspec denied" || die "+refspec allowed"

# A force spelling in an earlier push of a compound command must not
# escape: every push segment is judged, not just the last.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push -f origin feat/x; git push origin feat/y"}}')
[ "$(run "$j")" = deny ] && pass "force in an earlier push denied" || die "force in an earlier push escaped"

# push as echo text is not a push.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"echo git push -f origin main"}}')
[ "$(run "$j")" = allow ] && pass "echo-text push does not trigger" || die "echo-text push denied"

# --- pushes targeting the default branch are denied ---
# A fresh repo on `main`; config is scrubbed above, so the literal
# fallback names its trunk.
M=$(mktemp -d); trap 'rm -rf "$M"' EXIT
git -c init.defaultBranch=main -C "$M" init -q
git -C "$M" config user.email t@e >/dev/null; git -C "$M" config user.name t >/dev/null
git -C "$M" commit -q --allow-empty -m init
cd "$M"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push origin main"}}')
[ "$(run "$j")" = deny ] && pass "refspec equal to the default denied" || die "push origin main allowed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push origin HEAD:main"}}')
[ "$(run "$j")" = deny ] && pass "refspec dest :main denied" || die "push HEAD:main allowed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push"}}')
[ "$(run "$j")" = deny ] && pass "bare push on the default branch denied" || die "bare push on main allowed"

# A HEAD destination resolves to the repo's checked-out branch.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push origin HEAD"}}')
[ "$(run "$j")" = deny ] && pass "HEAD dest on the default branch denied" || die "push origin HEAD allowed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git push -u origin feat/x"}}')
[ "$(run "$j")" = allow ] && pass "task-branch push allowed" || die "task-branch push denied"

# Earlier text containing "push" must not corrupt the -C resolution: the
# prefix is cut at this push's own command word. Judged from a repo-less
# cwd so a corrupted resolution would fall back to it and allow.
cd "$(dirname "$M")"
j=$(jq -nc --arg m "$M" '{tool_name:"Bash",tool_input:{command:("echo pushed && git -C " + $m + " push")}}')
[ "$(run "$j")" = deny ] && pass "earlier push text does not corrupt -C" || die "-C discarded after earlier push text"

(( fail == 0 )) && echo "dev-push-guard.test: OK"
exit $fail
