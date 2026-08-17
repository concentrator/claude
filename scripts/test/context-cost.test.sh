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

exit $fail
