#!/usr/bin/env bash
# Tests hooks/dev-context-fill.sh - the context-fill helper (R074-T001).
# The fixture pins the three usage fields the helper sums (input_tokens +
# cache_creation_input_tokens + cache_read_input_tokens, the fields
# scripts/context-cost.py bills): schema drift in what the helper reads
# changes the computed percent and fails loudly here.
# Run: bash scripts/test/dev-context-fill.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
ROOT="$(git rev-parse --show-toplevel)"
HELPER="$ROOT/hooks/dev-context-fill.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

[ -x "$HELPER" ] && pass "helper present and executable" || die "helper missing"

D=$(cd "$(mktemp -d)" && pwd -P); trap 'rm -rf "$D"' EXIT
# Window 100000 so token sums read directly as percents; the global tier
# is a separate empty settings file so the real one never leaks in.
mkdir -p "$D/proj/.claude" "$D/global"
printf '{"autoCompactWindow":100000}\n' > "$D/proj/.claude/settings.json"
printf '{}\n' > "$D/global/settings.json"

# run <transcript> [VAR=...]: hook input JSON on stdin, fixture tiers.
run() {
  local t=$1; shift
  printf '{"transcript_path":"%s"}' "$t" \
    | env CLAUDE_PROJECT_DIR="$D/proj" CLAUDE_CONFIG_DIR="$D/global" "$@" \
      bash "$HELPER" 2>/dev/null
}

usage_line() {  # <input_tokens> <cache_creation_input_tokens> <cache_read_input_tokens>
  printf '{"type":"assistant","message":{"usage":{"input_tokens":%s,"cache_creation_input_tokens":%s,"cache_read_input_tokens":%s,"output_tokens":1}}}\n' "$1" "$2" "$3"
}

# Above the default threshold: the last record decides (33 then 85), and
# the percent is the sum of exactly the three pinned fields.
T="$D/above.jsonl"
{ printf '{"type":"user","message":{"role":"user"}}\n'
  usage_line 3000 10000 20000
  usage_line 5000 10000 70000; } > "$T"
out=$(run "$T"); rc=$?
[ "$rc" -eq 0 ] && [ "$out" = "85" ] \
  && pass "last record, pinned fields: prints 85" \
  || die "expected 85 rc=0, got rc=$rc out='$out'"

# Below the threshold: silent, exit 0.
T="$D/below.jsonl"; usage_line 5000 10000 35000 > "$T"
out=$(run "$T"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] \
  && pass "below threshold: silent" || die "expected silence, got rc=$rc out='$out'"

# The override lowers the threshold for the same transcript.
out=$(run "$T" DEV_FILL_WARN_PCT=40); rc=$?
[ "$rc" -eq 0 ] && [ "$out" = "50" ] \
  && pass "DEV_FILL_WARN_PCT=40 warns at 50" || die "override ignored: rc=$rc out='$out'"

# Window falls back to the user-global tier when the project has none.
T="$D/above.jsonl"
mkdir -p "$D/noproj" "$D/global2"
printf '{"autoCompactWindow":100000}\n' > "$D/global2/settings.json"
out=$(printf '{"transcript_path":"%s"}' "$T" \
  | env CLAUDE_PROJECT_DIR="$D/noproj" CLAUDE_CONFIG_DIR="$D/global2" bash "$HELPER" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] && [ "$out" = "85" ] \
  && pass "global-tier window used when project has none" \
  || die "global fallback failed: rc=$rc out='$out'"

# Fail-open paths: silent, exit 0 on every read or lookup failure.
out=$(run "$D/missing.jsonl"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] \
  && pass "absent transcript: silent" || die "absent transcript: rc=$rc out='$out'"

T="$D/broken.jsonl"; printf 'not json\n{"broken\n' > "$T"
out=$(run "$T"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] \
  && pass "malformed transcript: silent" || die "malformed: rc=$rc out='$out'"

T="$D/above.jsonl"
out=$(printf '{"transcript_path":"%s"}' "$T" \
  | env CLAUDE_PROJECT_DIR="$D/noproj" CLAUDE_CONFIG_DIR="$D/global" bash "$HELPER" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] \
  && pass "no window anywhere: silent" || die "windowless: rc=$rc out='$out'"

out=$(printf '' | env CLAUDE_PROJECT_DIR="$D/proj" CLAUDE_CONFIG_DIR="$D/global" bash "$HELPER" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ] \
  && pass "empty stdin: silent" || die "empty stdin: rc=$rc out='$out'"

(( fail == 0 )) && echo "dev-context-fill.test: OK"
exit $fail
