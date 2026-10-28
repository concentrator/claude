#!/usr/bin/env bash
# Tests hooks/dev-branch-state.sh - the UserPromptSubmit ambient-state hook
# (R-052). Covers the hook file (the run that fails when the mechanism is
# removed), the one-line output on a branch with changes,
# the clean form, the same line in a DEV repo with a session file and a
# full context, and silence outside a git repo.
# Run: bash scripts/test/dev-branch-state.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
unset CLAUDE_PROJECT_DIR
ROOT="$(git rev-parse --show-toplevel)"
HOOK="$ROOT/hooks/dev-branch-state.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# The mechanism exists: removing the hook file fails here. Its
# UserPromptSubmit entry is the installer's, pinned by install-dev.test.sh.
[ -x "$HOOK" ] && pass "hook file present and executable" || die "hook file missing"

# Run the hook from the current cwd with the empty prompt JSON on stdin.
run() { printf '{}' | bash "$HOOK" 2>/dev/null; }

# A branch repo with one changed tracked file and one untracked file.
D=$(cd "$(mktemp -d)" && pwd -P); trap 'rm -rf "$D"' EXIT   # physical path: git resolves symlinks
export HOME="$D/empty-home"; mkdir "$HOME"
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

# The default branch carries no first-edit hint: the branch guard's deny
# gives it on the first edit.
git -C "$D" checkout -q main
out=$(run)
[ "$out" = "branch-state: main | clean" ] && pass "default branch: no first-edit hint" || die "default-branch line changed: $out"
git -C "$D" checkout -q work

# A DEV repo - plans tree, `- Session:` declaration, a session file, and a
# transcript filling the context past any warning point - prints the same
# line: no session-state or context-fill segment.
mkdir -p "$D/dev/plans" "$D/dev/session" "$D/.claude"
printf '## Layout\n\n- Plans: dev/plans/\n- Session: dev/session/\n' > "$D/.claude/CLAUDE.md"
printf '# session s9\n' > "$D/dev/session/s9.md"
printf '{"autoCompactWindow":100000}\n' > "$D/.claude/settings.json"
T="$D/t.jsonl"
printf '{"type":"assistant","message":{"usage":{"input_tokens":5000,"cache_creation_input_tokens":10000,"cache_read_input_tokens":85000}}}\n' > "$T"
printf '.claude/\ndev/\nt.jsonl\n' >> "$D/.git/info/exclude"   # fixtures stay out of the counts
out=$(printf '{"session_id":"s9","transcript_path":"%s"}' "$T" | bash "$HOOK" 2>/dev/null)
[ "$out" = "branch-state: work | clean" ] && pass "DEV repo: no session-state or context-fill segment" || die "DEV line carries session segments: $out"

H="$D/home"; P="$D/proj/.claude/hooks"; mkdir -p "$H/.claude" "$P"
cp "$HOOK" "$ROOT/hooks/dev-hook-once.sh" "$P/"
jq -n '{hooks:{UserPromptSubmit:[{hooks:[{type:"command",command:"~/.claude/hooks/dev-branch-state.sh"}]}]}}' > "$H/.claude/settings.json"
out=$(printf '{}' | HOME="$H" bash "$P/dev-branch-state.sh" 2>/dev/null)
[ -z "$out" ] && pass "project copy silent when the global settings run it" || die "project copy printed beside the global hook: $out"
printf '{}\n' > "$H/.claude/settings.json"
out=$(printf '{}' | HOME="$H" bash "$P/dev-branch-state.sh" 2>/dev/null)
case "$out" in "branch-state: work"*) pass "project copy prints when the global settings do not run it" ;; *) die "project copy silent with no global hook: $out" ;; esac

# Outside any git repo: silent, exit 0.
N=$(mktemp -d); cd "$N"
out=$(run); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "silent outside a repo" || die "not silent outside a repo (rc=$rc, out=$out)"
cd /; rm -rf "$N"

(( fail == 0 )) && echo "dev-branch-state.test: OK"
exit $fail
