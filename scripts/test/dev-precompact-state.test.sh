#!/usr/bin/env bash
# Tests hooks/dev-precompact-state.sh - the PreCompact session-state hook
# (R040-T019). Covers the registration in settings.json, the file per
# session under <artifacts root>/session/, the header and tree block on a
# dirty branch with an open plan item, appending on a second compaction,
# the repository-keyed file without a session id, the DEV_STATE_DIR
# override, the root found from a subdirectory, and silence outside a
# git repo.
# Run: bash scripts/test/dev-precompact-state.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
unset CLAUDE_PROJECT_DIR DEV_STATE_DIR
ROOT="$(git rev-parse --show-toplevel)"
HOOK="$ROOT/hooks/dev-precompact-state.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

[ -x "$HOOK" ] && pass "hook file present and executable" || die "hook file missing"
jq -e '[.hooks.PreCompact[]?.hooks[]?.command // "" | select(test("dev-precompact-state"))] | length > 0' \
  "$ROOT/settings.json" >/dev/null 2>&1 \
  && pass "hook registered on PreCompact" || die "hook not registered in settings.json"

# A repo with a remote main, a work branch, one plan with an open item, one
# uncommitted change, and no root declaration (so the artifacts root is dev).
D=$(cd "$(mktemp -d)" && pwd -P); trap 'rm -rf "$D"' EXIT   # physical path: git resolves symlinks
git -c init.defaultBranch=main -C "$D" init -q --bare origin
git -c init.defaultBranch=main -C "$D" init -q repo
R="$D/repo"
git -C "$R" config user.email t@e; git -C "$R" config user.name t
mkdir -p "$R/dev/plans/R" "$R/src"
printf -- '- [x] done\n- [ ] open one\n' > "$R/dev/plans/R/T1.md"
printf 'clean\n' > "$R/tracked.sh"
printf '/dev/session/\n' > "$R/.gitignore"   # as install-dev.sh and the template leave a real repo
git -C "$R" add -A; git -C "$R" commit -qm init
git -C "$R" remote add origin "$D/origin"; git -C "$R" push -q origin main
git -C "$R" checkout -q -b work
printf -- '- [x] done\n- [x] open one\n- [ ] open two\n' > "$R/dev/plans/R/T1.md"
git -C "$R" commit -qam "tick one"
printf 'dirty\n' > "$R/tracked.sh"
cd "$R"

out=$(printf '{"session_id":"s1","compaction_trigger":"auto"}' | bash "$HOOK" 2>/dev/null)
f="$R/dev/session/s1.md"
[ -f "$f" ] && pass "state file per session under dev/session/" || die "no state file at $f"
case "$out" in session-state:*s1.md) pass "hook names the file" ;; *) die "unexpected stdout: $out" ;; esac
[ "$(head -1 "$f")" = "# session s1" ] && pass "header names the session" || die "header: $(head -1 "$f")"
grep -q '^## tree 20' "$f" && pass "tree block stamped" || die "tree block missing"
grep -q '^- trigger: auto$' "$f" && pass "compaction trigger recorded" || die "trigger missing"
grep -q '^- branch: work$' "$f" && pass "branch recorded" || die "branch missing"
grep -q '^- status: .*M tracked.sh' "$f" && pass "uncommitted path recorded" || die "status missing"
grep -q '^- plan: dev/plans/R/T1.md line 3: - \[ \] open two$' "$f" && pass "first open plan item and its line" || die "plan item missing: $(grep plan: "$f")"

printf '{"session_id":"s1","compaction_trigger":"manual"}' | bash "$HOOK" >/dev/null 2>&1
[ "$(grep -c '^## tree ' "$f")" -eq 2 ] && [ "$(grep -c '^# session' "$f")" -eq 1 ] \
  && pass "second compaction appends under one header" || die "append failed: $(grep -c '^## tree ' "$f") blocks"
grep -q '^- trigger: manual$' "$f" && pass "manual trigger recorded" || die "manual trigger missing"

out=$(printf '{}' | bash "$HOOK" 2>/dev/null)
ck=$(printf '%s' "$R" | cksum | cut -d' ' -f1)
[ -f "$R/dev/session/$ck.md" ] && pass "repository-keyed file without a session id" || die "no $ck.md in: $(ls "$R/dev/session")"

out=$(printf '{"session_id":"s4"}' | bash "$HOOK" --path 2>/dev/null)
[ "$out" = "$R/dev/session/s4.md" ] && [ ! -f "$R/dev/session/s4.md" ] && pass "--path names the file without writing it" || die "--path: $out"

cd "$R/src"
out=$(printf '{"session_id":"s2"}' | bash "$HOOK" 2>/dev/null)
[ -f "$R/dev/session/s2.md" ] && pass "root found from a subdirectory" || die "subdirectory run missed the root: $out"

cd "$R"
DEV_STATE_DIR="$D/override" bash -c 'printf "{\"session_id\":\"s3\"}" | bash "$0"' "$HOOK" >/dev/null 2>&1
[ -f "$D/override/s3.md" ] && pass "DEV_STATE_DIR overrides the directory" || die "override ignored"

# No plan touched on this branch: the file is still written and named.
git -C "$R" stash -q; git -C "$R" checkout -q main
out=$(printf '{"session_id":"s5"}' | bash "$HOOK" 2>/dev/null)
case "$out" in session-state:*s5.md) pass "file named when no plan changed" ;; *) die "no name without plan changes: '$out'" ;; esac
grep -q '^- status: clean$' "$R/dev/session/s5.md" && pass "clean tree recorded as clean" || die "clean form missing"

cd "$D"
out=$(printf '{}' | bash "$HOOK" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "silent outside a git repo" || die "not silent outside a repo (rc=$rc, out=$out)"

(( fail == 0 )) && echo "dev-precompact-state.test: OK"
exit $fail
