#!/usr/bin/env bash
# Tests scripts/ci/check-settings.sh - the Tier-1 gate over the context
# budget. Each case runs the real check inside a throwaway git repo, so this
# repo's own settings.json is never the subject and a case cannot pass by
# accident of the live config.
# Run: bash scripts/test/check-settings.test.sh
set -uo pipefail
# Overridable so a mutated copy can be run against these cases, confirming
# every assertion has a case that fails when it breaks.
CHECK="${CHECK:-$(git rev-parse --show-toplevel)/scripts/ci/check-settings.sh}"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

root=$(mktemp -d)
trap 'rm -rf "$root"' EXIT

# $1 = settings.json body, or the literal NONE to omit the file entirely.
# Fixtures get a fresh dir under one parent: the helper runs in a command
# substitution, so nothing it assigns survives to the caller - neither a
# path list for the trap nor a counter, and a reused dir would leave the
# missing-file case inheriting the previous fixture's settings.json.
fixture() {
  local d; d=$(mktemp -d "$root/XXXXXX")
  git -C "$d" init -q
  [ "$1" = NONE ] || printf '%s\n' "$1" > "$d/settings.json"
  echo "$d"
}
run_in() { ( cd "$1" && bash "$CHECK" 2>&1 ); }
ok_in()  { ( cd "$1" && bash "$CHECK" >/dev/null 2>&1 ); }

# $1 = fixture dir, $2 = expected substring. The gate must both name the
# failing condition and exit nonzero; naming it without failing is the
# defect this pairing catches.
fails_with() {
  local out; out=$(run_in "$1")
  ok_in "$1" && return 1
  grep -qi -- "$2" <<<"$out"
}

good='{ "autoCompactEnabled": true, "autoCompactWindow": 200000 }'

d=$(fixture "$good")
ok_in "$d" && pass "a budgeted config passes" || die "good config rejected: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true }')
fails_with "$d" "autoCompactWindow" && pass "absent window caught, named" \
  || die "absent window not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": 50000 }')
fails_with "$d" "range" && pass "below-range window caught, range named" \
  || die "below-range window not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": 2000000 }')
fails_with "$d" "range" && pass "above-range window caught, range named" \
  || die "above-range window not caught: $(run_in "$d")"

# The window binds only while auto-compaction is on, so a flipped flag
# disables the budget as surely as deleting the key.
d=$(fixture '{ "autoCompactEnabled": false, "autoCompactWindow": 200000 }')
fails_with "$d" "autoCompactEnabled" && pass "disabled auto-compaction caught, named" \
  || die "disabled auto-compaction not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": }')
fails_with "$d" "parse" && pass "malformed JSON caught, named as a parse failure" \
  || die "malformed JSON not caught: $(run_in "$d")"

d=$(fixture NONE)
fails_with "$d" "settings.json" && pass "missing settings.json caught, named" \
  || die "missing settings.json not caught: $(run_in "$d")"

exit $fail
