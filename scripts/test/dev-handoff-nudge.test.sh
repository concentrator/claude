#!/usr/bin/env bash
# Tests hooks/dev-handoff-nudge.sh - the Stop-hook hand-off nudge (R074-T002).
# The four-cell matrix (fill above/below threshold x hand-off stale/fresh)
# plus the fail-open paths: only above-and-stale blocks the stop.
# Run: bash scripts/test/dev-handoff-nudge.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
unset CLAUDE_PROJECT_DIR DEV_STATE_DIR
ROOT="$(git rev-parse --show-toplevel)"
HOOK="$ROOT/hooks/dev-handoff-nudge.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

[ -x "$HOOK" ] && pass "hook file present and executable" || die "hook file missing"
jq -e '[.hooks.Stop[]?.hooks[]?.command // "" | select(test("dev-handoff-nudge"))] | length > 0' \
  "$ROOT/settings.json" >/dev/null 2>&1 \
  && pass "hook registered on Stop" || die "hook not registered in settings.json"
D=$(cd "$(mktemp -d)" && pwd -P); trap 'rm -rf "$D"' EXIT
# A git repo project (dev-precompact-state.sh --path requires one), a
# window of 100000 so sums read as percents, an empty global tier, and
# DEV_STATE_DIR pointing the session file at the fixture.
mkdir -p "$D/proj/.claude" "$D/global" "$D/state"
git -c init.defaultBranch=main -C "$D/proj" init -q
printf '{"autoCompactWindow":100000}\n' > "$D/proj/.claude/settings.json"
printf '{}\n' > "$D/global/settings.json"
ABOVE="$D/above.jsonl"; BELOW="$D/below.jsonl"
printf '{"type":"assistant","message":{"usage":{"input_tokens":5000,"cache_creation_input_tokens":10000,"cache_read_input_tokens":70000}}}\n' > "$ABOVE"
printf '{"type":"assistant","message":{"usage":{"input_tokens":5000,"cache_creation_input_tokens":10000,"cache_read_input_tokens":35000}}}\n' > "$BELOW"

run() {  # run <transcript> -> hook output; $? = exit code
  printf '{"session_id":"s1","transcript_path":"%s"}' "$1" \
    | env CLAUDE_PROJECT_DIR="$D/proj" CLAUDE_CONFIG_DIR="$D/global" DEV_STATE_DIR="$D/state" \
      bash "$HOOK" 2>/dev/null
}

# Above + no session file: fresh, silent.
out=$(run "$ABOVE"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "no session file: silent" || die "no file: rc=$rc out='$out'"

# Above + file without a tree block: fresh, silent.
printf '# session s1\n' > "$D/state/s1.md"
out=$(run "$ABOVE"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "no tree block: silent" || die "no tree: rc=$rc out='$out'"

# Above + tree and no hand-off at all: stale, the stop is blocked.
printf '\n## tree 2026-09-07T00:00:00Z\n- branch: work\n' >> "$D/state/s1.md"
out=$(run "$ABOVE"); rc=$?
echo "$out" | jq -e '.ok == false' >/dev/null 2>&1 \
  && pass "above + no hand-off: blocked" || die "expected ok:false, got rc=$rc out='$out'"
case "$out" in *"$D/state/s1.md"*) pass "reason names the session file" ;; *) die "no session path in reason: $out" ;; esac
case "$out" in *"Writing the note"*) pass "reason cites handoff.md § Writing the note" ;; *) die "no handoff.md citation: $out" ;; esac

# Below + stale: silent.
out=$(run "$BELOW"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "below + stale: silent" || die "below+stale: rc=$rc out='$out'"

# An appended hand-off clears the nudge (above + fresh: silent).
printf '\n## hand-off 2026-09-07T00:05:00Z\n- done: none\n' >> "$D/state/s1.md"
out=$(run "$ABOVE"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "appended hand-off clears the nudge" || die "above+fresh: rc=$rc out='$out'"

# A later tree makes it stale again.
printf '\n## tree 2026-09-07T00:10:00Z\n- branch: work\n' >> "$D/state/s1.md"
out=$(run "$ABOVE")
echo "$out" | jq -e '.ok == false' >/dev/null 2>&1 \
  && pass "tree after hand-off: stale again" || die "expected re-block, got '$out'"

# Fail-open: absent transcript, absent window, outside a git repository.
out=$(run "$D/missing.jsonl"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "absent transcript: silent" || die "absent transcript: rc=$rc out='$out'"
out=$(printf '{"session_id":"s1","transcript_path":"%s"}' "$ABOVE" \
  | env CLAUDE_PROJECT_DIR="$D/noproj" CLAUDE_CONFIG_DIR="$D/global" DEV_STATE_DIR="$D/state" bash "$HOOK" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "absent window: silent" || die "absent window: rc=$rc out='$out'"
N=$(mktemp -d); cd "$N"
out=$(printf '{"session_id":"s1","transcript_path":"%s"}' "$ABOVE" \
  | env CLAUDE_CONFIG_DIR="$D/proj/.claude" DEV_STATE_DIR="$D/state" bash "$HOOK" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] && pass "outside a git repo: silent" || die "outside repo: rc=$rc out='$out'"
cd /; rm -rf "$N"

(( fail == 0 )) && echo "dev-handoff-nudge.test: OK"
exit $fail
