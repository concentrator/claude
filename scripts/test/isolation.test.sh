#!/usr/bin/env bash
# Self-test for verifier isolation (R-051). Single home for why every test in
# this directory scrubs the git environment:
#
#   `git -C` sets the working directory and does not override GIT_DIR, so a
#   fixture isolated by -C alone is isolated only while nothing exports that
#   variable. Git does export it, absolute, to a hook running in a linked
#   worktree - which is how one suite run rewrote a branch, planted refs and
#   set core.bare on the developer's own repository while reporting ALL OK.
#
#   The damage is not only mutation. A test that resolves its own subject
#   through git (`git rev-parse --show-toplevel`) measures another
#   repository's script when GIT_DIR and GIT_WORK_TREE both leak, reporting
#   on code it was never pointed at.
#
# The scrub is `unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE` at file scope, so
# every fixture in a file inherits it. This file proves the mechanism on both
# invocation paths, and § Coverage requires it of any test that uses git.
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
RUNNER=$root/scripts/test/run-all.sh
SCRUB='unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE'

fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

tmproot=$(mktemp -d); trap 'rm -rf "$tmproot"' EXIT

# Stands in for the developer's own repository: what a leak would damage.
mkhost() {
  local h; h=$(mktemp -d "$tmproot/host.XXXXXX")
  git -C "$h" init -q -b main
  printf 'committed\n' > "$h/hostfile"
  git -C "$h" add -A
  git -C "$h" -c user.email=t@t -c user.name=t commit -q -m base
  printf '%s' "$h"
}

# Every component a leak could alter.
snap() {
  git -C "$1" show-ref -d 2>/dev/null
  git -C "$1" config --local --list 2>/dev/null | sort
  git -C "$1" symbolic-ref -q HEAD 2>/dev/null
  git -C "$1" ls-files -s 2>/dev/null
  ( cd "$1/.git" 2>/dev/null && find . -type f | sort )
}

# Runs a command under the three variables a caller could leak. GIT_INDEX_FILE
# points off the default path, so a leaked write lands where snap() sees it.
with_host_env() {
  local h=$1; shift
  env GIT_DIR="$h/.git" GIT_WORK_TREE="$h" GIT_INDEX_FILE="$h/.git/leaked-index" \
    "$@"
}

# What a fixture-creating test does: build a repo, stage in it, branch in it.
# Each lands in the fixture when isolated, and in the leaked repo when not.
probe_body() {
  cat <<'PROBE'
set -uo pipefail
d=$(mktemp -d)
git -C "$d" init -q
printf 'fixture\n' > "$d/f"
git -C "$d" add -A 2>/dev/null || true
git -C "$d" branch leaked-by-probe 2>/dev/null || true
rm -rf "$d"
PROBE
}

# --- Runner path -----------------------------------------------------------

# A minimal repo carrying a copy of the runner plus one probe. scripts/test/
# holds only the probe, so the runner cannot recurse into this file.
mkwork() {
  local w; w=$(mktemp -d "$tmproot/work.XXXXXX")
  git -C "$w" init -q -b main
  mkdir -p "$w/scripts/test"
  cp "$RUNNER" "$w/scripts/test/run-all.sh"
  { printf ': > "$ISO_MARKER"\n'; probe_body; } > "$w/scripts/test/probe.test.sh"
  printf '%s' "$w"
}

h=$(mkhost); w=$(mkwork); marker=$w/probe-ran
before=$(snap "$h")
( cd "$w" && ISO_MARKER="$marker" \
    with_host_env "$h" bash scripts/test/run-all.sh ) >/dev/null 2>&1
after=$(snap "$h")
m=absent; c=same
[ -f "$marker" ] && m=present
[ "$before" = "$after" ] || c=changed
if [ "$m|$c" = "present|same" ]; then
  pass "runner reaches its tests under a leaked git environment, host intact"
else
  die "runner path failed ($m|$c; wanted present|same)"
fi

# --- Direct path -----------------------------------------------------------

# A test invoked without the runner carries its own scrub. Paired so the bare
# variant proves the scrubbed one is doing the work.
direct_case() {
  local h p before after
  h=$(mkhost); p=$tmproot/direct.$1.test.sh
  { [ "$1" = scrubbed ] && printf '%s\n' "$SCRUB"; probe_body; } > "$p"
  before=$(snap "$h")
  with_host_env "$h" bash "$p" >/dev/null 2>&1
  after=$(snap "$h")
  [ "$before" = "$after" ] && printf same || printf changed
}

d=$(direct_case scrubbed)
[ "$d" = same ] && pass "a scrubbed test invoked directly leaves the host alone" \
  || die "a scrubbed test invoked directly mutated the host ($d)"

d=$(direct_case bare)
[ "$d" = changed ] && pass "an unscrubbed test invoked directly leaks to the host" \
  || die "an unscrubbed test did not leak - the pair proves nothing ($d)"

# --- Coverage --------------------------------------------------------------

# Any test that mentions git must scrub, whatever idiom builds its fixture. The
# match is whole-line: this file quotes the scrub in its own header, and a
# decorative mention must not satisfy the gate.
# The match is deliberately loose - it catches a prose mention too - because
# over-inclusion costs a redundant unset while under-inclusion costs a leak.
# Echoes the offenders, so one function serves the suite and its negative case.
scan() {
  local f missing=
  for f in "$1"/*.test.sh; do
    [ -e "$f" ] || continue
    grep -qE '(^|[^[:alnum:]-])git[[:space:]]' "$f" || continue
    grep -qxF -- "$SCRUB" "$f" || missing="$missing $(basename "$f")"
  done
  printf '%s' "$missing"
}

m=$(scan "$root/scripts/test")
[ -z "$m" ] && pass "every test that uses git scrubs the environment" \
  || die "tests using git without a scrub:$m"

# The scan must name an offender, or it is a green light that checks nothing.
neg=$tmproot/neg; mkdir -p "$neg"
{ printf 'set -uo pipefail\n'; probe_body; } > "$neg/unscrubbed.test.sh"
m=$(scan "$neg")
[ "$m" = " unscrubbed.test.sh" ] \
  && pass "the scan names an unscrubbed test" \
  || die "the scan reported '$m'; wanted ' unscrubbed.test.sh'"

exit $fail
