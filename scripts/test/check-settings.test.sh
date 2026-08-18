#!/usr/bin/env bash
# Tests scripts/ci/check-settings.sh - the Tier-1 gate over the context
# budget. Each case runs the real check inside a throwaway git repo, so this
# repo's own settings.json is never the subject and a case cannot pass by
# accident of the live config.
# Run: bash scripts/test/check-settings.test.sh
set -uo pipefail
# Fixtures here are isolated by `git -C`, which does not override GIT_DIR.
# Scrubbed at file scope so every fixture in this file inherits it.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
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
# defect this pairing catches. One invocation, not two: status and output
# come from the same run.
fails_with() {
  local out rc
  out=$(run_in "$1"); rc=$?
  [ "$rc" -ne 0 ] || return 1
  grep -qF -- "$2" <<<"$out"
}

good='{ "autoCompactEnabled": true, "autoCompactWindow": 200000 }'

d=$(fixture "$good")
ok_in "$d" && pass "a budgeted config passes" || die "good config rejected: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true }')
fails_with "$d" "SETTINGS: autoCompactWindow is absent" && pass "absent window caught, named" \
  || die "absent window not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": 50000 }')
fails_with "$d" "SETTINGS: autoCompactWindow is 50000, outside the range" && pass "below-range window caught, range named" \
  || die "below-range window not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": 2000000 }')
fails_with "$d" "SETTINGS: autoCompactWindow is 2000000, outside the range" && pass "above-range window caught, range named" \
  || die "above-range window not caught: $(run_in "$d")"

# The window binds only while auto-compaction is on, so a flipped flag
# disables the budget as surely as deleting the key.
d=$(fixture '{ "autoCompactEnabled": false, "autoCompactWindow": 200000 }')
fails_with "$d" "SETTINGS: autoCompactEnabled is not true" && pass "disabled auto-compaction caught, named" \
  || die "disabled auto-compaction not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": }')
fails_with "$d" "SETTINGS: settings.json is not a JSON object" && pass "malformed JSON caught, named" \
  || die "malformed JSON not caught: $(run_in "$d")"

# A bare null parses as JSON but is not a settings file, and a string value
# is a plausible hand-edit; both previously slipped through to a message that
# named the wrong condition.
d=$(fixture 'null')
fails_with "$d" "SETTINGS: settings.json is not a JSON object" \
  && pass "a parsing non-object caught, named" \
  || die "bare null not caught: $(run_in "$d")"

d=$(fixture '{ "autoCompactEnabled": true, "autoCompactWindow": "200000" }')
fails_with "$d" "SETTINGS: autoCompactWindow is not a number" \
  && pass "string window caught, named as a type failure" \
  || die "string window not caught: $(run_in "$d")"

d=$(fixture NONE)
fails_with "$d" "is missing; the context budget has no home" && pass "missing settings.json caught, named" \
  || die "missing settings.json not caught: $(run_in "$d")"

# Without jq the gate can judge nothing, so it must say so and let the rest
# of the suite run rather than blaming a valid file. The shim PATH carries
# git alone: jq ships in /usr/bin on this platform, so dropping a directory
# from PATH is not enough to hide it.
shim=$(mktemp -d "$root/XXXXXX"); mkdir -p "$shim/bin"
ln -s "$(command -v git)" "$shim/bin/git"
d=$(fixture "$good")
out=$( cd "$d" && env PATH="$shim/bin" /bin/bash "$CHECK" 2>&1 )
( cd "$d" && env PATH="$shim/bin" /bin/bash "$CHECK" >/dev/null 2>&1 ) \
  && grep -qF -- "check-settings: SKIP" <<<"$out" \
  && pass "no jq skips loudly and does not fail the gate" \
  || die "no jq did not skip cleanly: $out"

(( fail == 0 )) && echo "check-settings.test: OK"
exit $fail
