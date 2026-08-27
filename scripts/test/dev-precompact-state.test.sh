#!/usr/bin/env bash
# Tests hooks/dev-precompact-state.sh - the PreCompact state hook - and the
# pointer hooks/dev-branch-state.sh prints when a state file exists. Covers
# the registration in settings.json, the file's content on a dirty branch
# with an open plan item, the pointer on the next prompt, and silence
# outside a git repo.
# Run: bash scripts/test/dev-precompact-state.test.sh
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
ROOT="$(git rev-parse --show-toplevel)"
HOOK="$ROOT/hooks/dev-precompact-state.sh"
STATE="$ROOT/hooks/dev-branch-state.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

[ -x "$HOOK" ] && pass "hook file present and executable" || die "hook file missing"
jq -e '[.hooks.PreCompact[]?.hooks[]?.command // "" | select(test("dev-precompact-state"))] | length > 0' \
  "$ROOT/settings.json" >/dev/null 2>&1 \
  && pass "hook registered on PreCompact" || die "hook not registered in settings.json"

D=$(mktemp -d); trap 'rm -rf "$D"' EXIT
export DEV_STATE_DIR="$D/state"
# A repo with a remote main, a work branch, one plan with an open item, and
# one uncommitted change.
git -c init.defaultBranch=main -C "$D/origin" init -q --bare 2>/dev/null || { mkdir -p "$D/origin"; git -c init.defaultBranch=main -C "$D/origin" init -q --bare; }
git -c init.defaultBranch=main -C "$D" init -q repo
R="$D/repo"
git -C "$R" config user.email t@e; git -C "$R" config user.name t
mkdir -p "$R/plans/R"
printf -- '- [x] done\n- [ ] open one\n' > "$R/plans/R/T1.md"
printf 'clean\n' > "$R/tracked.sh"
git -C "$R" add -A; git -C "$R" commit -qm init
git -C "$R" remote add origin "$D/origin"; git -C "$R" push -q origin main
git -C "$R" checkout -q -b work
printf -- '- [x] done\n- [x] open one\n- [ ] open two\n' > "$R/plans/R/T1.md"
git -C "$R" commit -qam "tick one"
printf 'dirty\n' > "$R/tracked.sh"
cd "$R"

out=$(printf '{"session_id":"s1","trigger":"auto"}' | bash "$HOOK" 2>/dev/null)
f="$DEV_STATE_DIR/s1.md"
[ -f "$f" ] && pass "state file written per session" || die "no state file at $f"
case "$out" in precompact-state:*s1.md) pass "hook names the file" ;; *) die "unexpected stdout: $out" ;; esac
grep -q '^- branch: work$' "$f" && pass "branch recorded" || die "branch missing"
grep -q '^- trigger: auto$' "$f" && pass "trigger recorded" || die "trigger missing"
grep -q '^ M tracked.sh$' "$f" && pass "uncommitted change recorded" || die "status missing"
grep -q 'plans/R/T1.md: first open item at line 3' "$f" && pass "open plan item located" || die "plan item missing: $(grep plans "$f")"

line=$(printf '{"session_id":"s1"}' | bash "$STATE" 2>/dev/null)
case "$line" in *"precompact-state: $f"*) pass "next prompt points at the file" ;; *) die "no pointer in: $line" ;; esac
rm -f "$f"
line=$(printf '{"session_id":"s1"}' | bash "$STATE" 2>/dev/null)
case "$line" in *precompact-state*) die "pointer survives deletion: $line" ;; *) pass "pointer gone once the file is deleted" ;; esac

# No session id: keyed by repository instead.
out=$(printf '{}' | bash "$HOOK" 2>/dev/null)
[ "$(ls "$DEV_STATE_DIR" | wc -l | tr -d ' ')" -eq 1 ] && pass "repository-keyed file without a session id" || die "expected one file, got: $(ls "$DEV_STATE_DIR")"

cd "$D"
out=$(printf '{}' | bash "$HOOK" 2>/dev/null)
[ -z "$out" ] && pass "silent outside a git repo" || die "output outside a repo: $out"

[ "$fail" -eq 0 ] && echo "dev-precompact-state: ALL OK" || { echo "dev-precompact-state: FAIL"; exit 1; }
