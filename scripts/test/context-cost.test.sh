#!/usr/bin/env bash
# Tests scripts/context-cost.py - the context-cost reporter. Each case runs
# the real tool over a throwaway transcript fixture whose figures are
# computed by hand in the comments, so an arithmetic change that still
# produces plausible output fails here.
# Run: bash scripts/test/context-cost.test.sh
set -uo pipefail
# Overridable so a mutated copy can be run against these cases, confirming
# every reported figure has a case that fails when it breaks.
TOOL="${TOOL:-$(git rev-parse --show-toplevel)/scripts/context-cost.py}"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# One assistant record carrying usage: $1 input, $2 cache_creation,
# $3 cache_read, $4 output.
asst() {
  printf '{"type":"assistant","message":{"role":"assistant","usage":{"input_tokens":%s,"cache_creation_input_tokens":%s,"cache_read_input_tokens":%s,"output_tokens":%s}}}\n' \
    "$1" "$2" "$3" "$4"
}

d=$(mktemp -d)
trap 'rm -rf "$d"' EXIT

# Fixture: three billed calls at contexts 110, 125 and 135, outputs 50, 30
# and 20. A user record and a usage-less assistant record sit between them,
# so the totals below hold only if both are skipped.
#   billed  110 + 125 + 135 = 370
#   output   50 +  30 +  20 = 100
#   sorted contexts [110, 125, 135] -> median 125, p90 135, max 135
{
  asst 10 100 0 50
  printf '{"type":"user","message":{"role":"user","content":"go on"}}\n'
  asst 5 20 100 30
  printf '{"type":"assistant","message":{"role":"assistant"}}\n'
  asst 5 10 120 20
} > "$d/s1.jsonl"

out=$(python3 "$TOOL" "$d/s1.jsonl" 2>&1)
for want in "calls: 3" "billed_context: 370" "output_tokens: 100" \
            "ctx_median: 125" "ctx_p90: 135" "ctx_max: 135"; do
  grep -qF -- "$want" <<<"$out" && pass "reports $want" \
    || die "missing '$want' in: $out"
done

# A transcript with no usage records is a real state (a session that never
# reached the model), not an error.
printf '{"type":"user","message":{"role":"user","content":"hi"}}\n' > "$d/s2.jsonl"
out=$(python3 "$TOOL" "$d/s2.jsonl" 2>&1)
grep -qF -- "calls: 0" <<<"$out" && pass "usage-less session reports zero calls" \
  || die "usage-less session did not report zero calls: $out"
python3 "$TOOL" "$d/s2.jsonl" >/dev/null 2>&1 \
  && pass "usage-less session exits zero" || die "usage-less session exited nonzero"

# One assistant record carrying usage and issuing a tool:
# $1 input, $2 cache_creation, $3 cache_read, $4 output, $5 tool name.
asst_tool() {
  printf '{"type":"assistant","message":{"role":"assistant","content":[{"type":"tool_use","name":"%s","input":{}}],"usage":{"input_tokens":%s,"cache_creation_input_tokens":%s,"cache_read_input_tokens":%s,"output_tokens":%s}}}\n' \
    "$5" "$1" "$2" "$3" "$4"
}

# Fixture A, one segment, contexts 100 / 150 / 400, outputs 10 / 20 / 5.
# Calls 1 and 2 issue Bash and Read; call 3 ends the turn.
#   base 100 held across 3 calls          -> static_prefix turns 300
#   call 1: delta 50, output 10 retained  -> model_output 10 x 2 = 20
#           injected 40 to Bash           -> result:Bash   40 x 2 = 80
#   call 2: delta 250, output 20 retained -> model_output 20 x 1 = 20
#           injected 230 to Read          -> result:Read  230 x 1 = 230
#   attributed 300 + 40 + 80 + 230 = 650, billed 100 + 150 + 400 = 650
{
  asst_tool 100 0 0 10 Bash
  asst_tool 0 0 150 20 Read
  asst 0 0 400 5
} > "$d/a.jsonl"

out=$(python3 "$TOOL" "$d/a.jsonl" 2>&1)
for want in "src static_prefix: added=100 turns=300" \
            "src model_output: added=30 turns=40" \
            "src result:Bash: added=40 turns=80" \
            "src result:Read: added=230 turns=230" \
            "attributed: 650" "billed_context: 650"; do
  grep -qF -- "$want" <<<"$out" && pass "attributes $want" \
    || die "missing '$want' in: $out"
done

# Fixture B isolates the compaction marker. Contexts 100 / 150 / 145 / 160:
# the 145 carries isCompactSummary but is only a 3% drop, so the 10%
# fallback cannot fire and only the marker can start the second segment.
# Segment 1 base 100 x 2 = 200, model_output 10, result:Bash 40  -> 250
# Segment 2 base 145 x 2 = 290, model_output 5,  user_turn   10  -> 305
# attributed 555, billed 100 + 150 + 145 + 160 = 555
{
  asst_tool 100 0 0 10 Bash
  asst 0 0 150 20
  printf '{"type":"assistant","isCompactSummary":true,"message":{"role":"assistant","usage":{"input_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":145,"output_tokens":5}}}\n'
  asst 0 0 160 5
} > "$d/b.jsonl"

out=$(python3 "$TOOL" "$d/b.jsonl" 2>&1)
for want in "src static_prefix: added=245 turns=490" "attributed: 555" \
            "billed_context: 555"; do
  grep -qF -- "$want" <<<"$out" && pass "marker segments: $want" \
    || die "missing '$want' in: $out"
done

# Fixture C is fixture B without the marker, so the 3% drop stays inside one
# segment. Context that leaves mid-segment is not re-read by the calls that
# follow, so its contribution is negative; dropping it instead would inflate
# the total, which is how this case was found on real data.
#   base 100 x 4 = 400
#   call 1: delta 50,  keep 10 x 3 = 30, injected 40 x 3 = 120 to Bash
#   call 2: delta -5 held over 2 calls -> shrinkage -10
#   call 3: delta 15,  keep 5,  injected 10 to the user turn
#   attributed 400 + 30 + 120 - 10 + 5 + 10 = 555, billed 555
{
  asst_tool 100 0 0 10 Bash
  asst 0 0 150 20
  asst 0 0 145 5
  asst 0 0 160 5
} > "$d/c.jsonl"

out=$(python3 "$TOOL" "$d/c.jsonl" 2>&1)
for want in "src shrinkage: added=-5 turns=-10" \
            "src static_prefix: added=100 turns=400" \
            "attributed: 555" "billed_context: 555"; do
  grep -qF -- "$want" <<<"$out" && pass "sub-threshold drop: $want" \
    || die "missing '$want' in: $out"
done

# Subagents cost real tokens but spend them under their own context, so they
# roll up beside the session rather than into it. The harness writes them in
# a directory named for the session, beside the session's own transcript.
#   main      contexts 100 + 200 = 300
#   subagents contexts  50 +  70 = 120 across two files
mkdir -p "$d/s3/subagents"
{ asst 100 0 0 5; asst 0 0 200 5; } > "$d/s3.jsonl"
asst 50 0 0 1 > "$d/s3/subagents/a.jsonl"
asst 70 0 0 1 > "$d/s3/subagents/b.jsonl"

out=$(python3 "$TOOL" "$d/s3.jsonl" 2>&1)
grep -qF -- "subagents: count=2 calls=2 billed_context=120" <<<"$out" \
  && pass "rolls up both subagents" || die "no subagent rollup in: $out"
grep -qF -- "billed_context: 300" <<<"$out" \
  && pass "subagent tokens stay out of the main-loop total" \
  || die "main total absorbed subagent tokens: $out"

# A session with no subagent directory is the common case, not an error.
out=$(python3 "$TOOL" "$d/s1.jsonl" 2>&1)
grep -qF -- "subagents: count=0 calls=0 billed_context=0" <<<"$out" \
  && pass "session without subagents reports an empty rollup" \
  || die "missing empty rollup in: $out"

# --last N reports the N most recently written sessions across every
# project, newest first. CLAUDE_CONFIG_DIR points the tool at a throwaway
# projects tree so the case does not depend on the real one.
mkdir -p "$d/cfg/projects/p1" "$d/cfg/projects/p2"
asst 10 0 0 1 > "$d/cfg/projects/p1/old.jsonl"
asst 20 0 0 1 > "$d/cfg/projects/p2/mid.jsonl"
asst 30 0 0 1 > "$d/cfg/projects/p1/new.jsonl"
touch -t 202601010000 "$d/cfg/projects/p1/old.jsonl"
touch -t 202602010000 "$d/cfg/projects/p2/mid.jsonl"
touch -t 202603010000 "$d/cfg/projects/p1/new.jsonl"

out=$(CLAUDE_CONFIG_DIR="$d/cfg" python3 "$TOOL" --last 2 2>&1)
[ "$(grep -c '^== ' <<<"$out")" = 2 ] && pass "--last bounds the set to 2" \
  || die "--last did not report exactly 2 sessions: $out"
grep -qF -- "== new ==" <<<"$out" && grep -qF -- "== mid ==" <<<"$out" \
  && ! grep -qF -- "== old ==" <<<"$out" \
  && pass "--last takes the most recent, not the first found" \
  || die "--last picked the wrong sessions: $out"

# An unreadable path is the likeliest operator error, so it must name the
# path rather than surface a traceback.
python3 "$TOOL" --session "$d/nope.jsonl" >/dev/null 2>&1 \
  && die "unreadable path exited zero" || pass "unreadable path exits nonzero"
out=$(python3 "$TOOL" --session "$d/nope.jsonl" 2>&1)
grep -qF -- "$d/nope.jsonl" <<<"$out" && pass "unreadable path is named" \
  || die "error did not name the path: $out"

# A transcript being appended to can end mid-write, so a line that does not
# parse is skipped rather than aborting a run over thousands of sessions.
{ asst 100 0 0 5; printf 'not json at all\n'; asst 0 0 200 5; } > "$d/m.jsonl"
out=$(python3 "$TOOL" --session "$d/m.jsonl" 2>&1)
grep -qF -- "calls: 2" <<<"$out" && grep -qF -- "billed_context: 300" <<<"$out" \
  && pass "malformed line skipped, run completes" \
  || die "malformed line derailed the run: $out"

# The identity is the tool's own runtime check, so prove it fires. A mutant
# that drops the retained-output term must both report a mismatch and exit
# nonzero; a tool that reports without failing would pass every case above.
mutant="$d/mutant.py"
sed 's/^\( *\)turns\[MODEL\] += keep \* remaining$/\1pass/' "$TOOL" > "$mutant"
diff -q "$TOOL" "$mutant" >/dev/null \
  && die "mutation did not apply" || pass "mutant differs from the tool"
out=$(python3 "$mutant" "$d/a.jsonl" 2>&1)
python3 "$mutant" "$d/a.jsonl" >/dev/null 2>&1 \
  && die "mutant reported success on a broken identity" \
  || pass "mutant exits nonzero on a broken identity"
grep -qiF -- "identity" <<<"$out" && pass "mutant names the identity failure" \
  || die "mutant failed without naming the identity: $out"

exit $fail
