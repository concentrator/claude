#!/usr/bin/env bash
# Tests hooks/dev-branch-state.sh - the UserPromptSubmit ambient-state hook
# (R-052). Covers the registration in settings.json (the run that fails when
# the mechanism is removed), the one-line output on a branch with changes,
# the clean form, the session and fill segments only in a DEV repo, and
# silence outside a git repo.
# Run: bash scripts/test/dev-branch-state.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
unset CLAUDE_PROJECT_DIR DEV_STATE_DIR
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

# Context-fill fixture: the global settings tier is pointed at an empty
# fixture so only the repo's own window is read; the transcript puts the
# fill at 50%.
mkdir -p "$D/.claude" "$D/global"
printf '{"autoCompactWindow":100000}\n' > "$D/.claude/settings.json"
printf '{}\n' > "$D/global/settings.json"
T="$D/t.jsonl"
printf '{"type":"assistant","message":{"usage":{"input_tokens":5000,"cache_creation_input_tokens":10000,"cache_read_input_tokens":35000}}}\n' > "$T"
printf '.claude/\nglobal/\nt.jsonl\n' >> "$D/.git/info/exclude"   # fixtures stay out of the counts
fill() { printf '{"session_id":"s9","transcript_path":"%s"}' "$T" \
  | env CLAUDE_CONFIG_DIR="$D/global" ${1:+DEV_FILL_WARN_PCT=$1} bash "$HOOK" 2>/dev/null; }

# A repo that does not use DEV: neither the session file nor the fill
# warning, even above the threshold.
out=$(fill 40)
[ "$out" = "branch-state: work | clean" ] && pass "non-DEV repo: no session-state or fill segment" || die "non-DEV line carries DEV segments: $out"

# The default branch carries no first-edit hint: the branch guard's deny
# gives it on the first edit.
git -C "$D" checkout -q main
out=$(run)
[ "$out" = "branch-state: main | clean" ] && pass "default branch: no first-edit hint" || die "default-branch line changed: $out"
git -C "$D" checkout -q work

# Each DEV signal turns the session file on.
mkdir -p "$D/dev/plans"
out=$(run)
case "$out" in *"| session-state: $D/dev/session/"*) pass "dev/plans/ marks a DEV repo" ;; *) die "dev/plans/ not read as DEV: $out" ;; esac
rmdir "$D/dev/plans"
printf '## Layout\n\n- Plans: plans/\n' > "$D/CLAUDE.md"
out=$(run)
case "$out" in *"| session-state: $D/dev/session/"*) pass "a '- Plans:' declaration marks a DEV repo" ;; *) die "'- Plans:' not read as DEV: $out" ;; esac
rm "$D/CLAUDE.md"
printf '## Layout\n\n- Session: dev/session/\n' > "$D/.claude/CLAUDE.md"
out=$(run)
case "$out" in *"| session-state: $D/dev/session/"*) pass "a '- Session:' declaration in .claude/CLAUDE.md marks a DEV repo" ;; *) die "'- Session:' not read as DEV: $out" ;; esac

# The session file is named whether or not it exists yet.
out=$(printf '{"session_id":"s9"}' | bash "$HOOK" 2>/dev/null)
case "$out" in *"| session-state: $D/dev/session/s9.md") pass "session file named before it exists" ;; *) die "no pointer in: $out" ;; esac
mkdir -p "$D/dev/session"; printf '# session s9\n' > "$D/dev/session/s9.md"
out=$(printf '{"session_id":"s9"}' | bash "$HOOK" 2>/dev/null)
case "$out" in *"| session-state: $D/dev/session/s9.md") pass "session file named once it exists" ;; *) die "no pointer in: $out" ;; esac
[ "$(printf '%s\n' "$out" | wc -l | tr -d ' ')" -eq 1 ] && pass "pointer keeps the line to one" || die "pointer broke the one-line form"

# Context-fill warning: above the (overridden) threshold the line gains
# the warning segment naming the session file; below it the line is
# unchanged. One-line contract holds in both forms.
out=$(fill 40)
case "$out" in *"| context 50% - append the hand-off block to $D/dev/session/s9.md") pass "fill warning above threshold" ;; *) die "no fill warning in: $out" ;; esac
[ "$(printf '%s\n' "$out" | wc -l | tr -d ' ')" -eq 1 ] && pass "warning keeps the line to one" || die "warning broke the one-line form"
out=$(fill)
case "$out" in *context*) die "warning printed below threshold: $out" ;; *"| session-state: $D/dev/session/s9.md") pass "below threshold: line unchanged" ;; *) die "unexpected line: $out" ;; esac

H="$D/home"; P="$D/proj/.claude/hooks"; mkdir -p "$H/.claude" "$P"
cp "$HOOK" "$ROOT/hooks/dev-hook-once.sh" "$ROOT/hooks/dev-precompact-state.sh" "$ROOT/hooks/dev-context-fill.sh" "$P/"
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
