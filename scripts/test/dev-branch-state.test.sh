#!/usr/bin/env bash
# Tests hooks/dev-branch-state.sh - the UserPromptSubmit ambient-state hook
# (R-052). Covers the registration in settings.json (the run that fails when
# the mechanism is removed), the one-line output on a branch with changes,
# the clean form, and silence outside a git repo.
# Run: bash scripts/test/dev-branch-state.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
ROOT="$(git rev-parse --show-toplevel)"
HOOK="$ROOT/hooks/dev-branch-state.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# The mechanism exists and is registered: removing the hook file or its
# UserPromptSubmit entry in settings.json fails here.
[ -x "$HOOK" ] && pass "hook file present and executable" || die "hook file missing"
jq -e '[.hooks.UserPromptSubmit[]?.hooks[]?.command // "" | select(test("dev-branch-state"))] | length > 0' \
  "$ROOT/settings.json" >/dev/null 2>&1 \
  && pass "hook registered on UserPromptSubmit" || die "hook not registered in settings.json"

# Run the hook from the current cwd with the empty prompt JSON on stdin.
run() { printf '{}' | bash "$HOOK" 2>/dev/null; }

# A branch repo with one changed tracked file and one untracked file.
D=$(cd "$(mktemp -d)" && pwd -P); trap 'rm -rf "$D"' EXIT   # physical path: git resolves symlinks
git -c init.defaultBranch=main -C "$D" init -q
git -C "$D" config user.email t@e; git -C "$D" config user.name t
printf 'clean\n' > "$D/tracked.sh"
git -C "$D" add tracked.sh; git -C "$D" commit -qm init
git -C "$D" checkout -q -b work
printf 'dirty\n' > "$D/tracked.sh"
printf 'new\n' > "$D/extra.md"
cd "$D"
out=$(run)
[ "$(printf '%s\n' "$out" | wc -l | tr -d ' ')" -eq 1 ] && pass "output is one line" || die "output exceeds one line"
case "$out" in *work*"1 changed"*"1 untracked"*) pass "branch and counts reported" ;; *) die "expected branch+counts, got: $out" ;; esac

# Clean tree: the line says so instead of zero counts.
git -C "$D" checkout -q -- tracked.sh; rm "$D/extra.md"
out=$(run)
case "$out" in *work*clean*) pass "clean tree reported" ;; *) die "expected clean form, got: $out" ;; esac

# The session file is named whether or not it exists yet (R040-T019).
out=$(printf '{"session_id":"s9"}' | bash "$HOOK" 2>/dev/null)
case "$out" in *"| session-state: $D/dev/session/s9.md") pass "session file named before it exists" ;; *) die "no pointer in: $out" ;; esac
mkdir -p "$D/dev/session"; printf '# session s9\n' > "$D/dev/session/s9.md"
out=$(printf '{"session_id":"s9"}' | bash "$HOOK" 2>/dev/null)
case "$out" in *"| session-state: $D/dev/session/s9.md") pass "session file named once it exists" ;; *) die "no pointer in: $out" ;; esac
[ "$(printf '%s\n' "$out" | wc -l | tr -d ' ')" -eq 1 ] && pass "pointer keeps the line to one" || die "pointer broke the one-line form"

# Outside any git repo: silent, exit 0.
N=$(mktemp -d); cd "$N"
out=$(run); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "silent outside a repo" || die "not silent outside a repo (rc=$rc, out=$out)"
cd /; rm -rf "$N"

(( fail == 0 )) && echo "dev-branch-state.test: OK"
exit $fail
