#!/usr/bin/env bash
# Self-test for verifier isolation (R-051): a test must operate on its own
# fixture, never on whatever repository an inherited git environment names.
# `git -C` sets the working directory and does not override GIT_DIR, so
# isolation by -C alone holds only while nothing exports it - git does export
# it, absolute, to a hook running in a linked worktree.
#
# Subject overridable, so a mutated copy can be run against these cases:
#   RUNNER=/path/to/run-all.sh bash scripts/test/isolation.test.sh
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

root=$(cd "$(dirname "$0")/../.." && pwd)
RUNNER=${RUNNER:-$root/scripts/test/run-all.sh}

fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

tmproot=$(mktemp -d); trap 'rm -rf "$tmproot"' EXIT

# Stands in for the developer's own repository: what a leak would damage.
mkhost() {
  local h; h=$(mktemp -d "$tmproot/host.XXXXXX")
  git -C "$h" init -q -b main
  git -C "$h" -c user.email=t@t -c user.name=t commit -q --allow-empty -m base
  printf '%s' "$h"
}

# Everything a leak would alter: refs, local config, and where HEAD points.
snap() {
  git -C "$1" show-ref -d 2>/dev/null
  git -C "$1" config --local --list 2>/dev/null | sort
  git -C "$1" symbolic-ref -q HEAD 2>/dev/null
}

# A minimal repo carrying a copy of the runner plus one fixture-creating test.
# scripts/test/ holds only the probe, so the runner cannot recurse into this
# file.
mkwork() {
  local w; w=$(mktemp -d "$tmproot/work.XXXXXX")
  git -C "$w" init -q -b main
  mkdir -p "$w/scripts/test"
  cp "$1" "$w/scripts/test/run-all.sh"
  cat > "$w/scripts/test/probe.test.sh" <<'PROBE'
set -uo pipefail
: > "$ISO_MARKER"
d=$(mktemp -d)
git -C "$d" init -q
# Lands in the probe's own fixture when isolated; in GIT_DIR's repo when not.
# Fails harmlessly on the fixture, whose HEAD is unborn.
git -C "$d" branch leaked-by-probe 2>/dev/null || true
rm -rf "$d"
echo "probe ran"
PROBE
  printf '%s' "$w"
}

# Runs one runner against a fresh host + work pair. Echoes "<marker>|<host>".
run_case() {
  local runner=$1 h w marker before after m=absent c=same
  h=$(mkhost); w=$(mkwork "$runner"); marker=$w/probe-ran
  before=$(snap "$h")
  ( cd "$w" && ISO_MARKER=$marker GIT_DIR="$h/.git" bash scripts/test/run-all.sh ) \
    >/dev/null 2>&1
  after=$(snap "$h")
  [ -f "$marker" ] && m=present
  [ "$before" = "$after" ] || c=changed
  printf '%s|%s' "$m" "$c"
}

r=$(run_case "$RUNNER")
if [ "${r%%|*}" = present ]; then
  pass "runner invokes its tests from its own repo under an absolute GIT_DIR"
else
  die "runner never ran the probe - GIT_DIR redirected the toplevel ($r)"
fi
if [ "${r##*|}" = same ]; then
  pass "host repo untouched through the runner"
else
  die "host repo mutated through the runner ($r)"
fi

# The case must fail with the scrub removed, or it proves nothing.
mut=$tmproot/run-all.mutant.sh
grep -v '^unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE$' "$RUNNER" > "$mut"
if bash -n "$mut" 2>/dev/null; then
  m=$(run_case "$mut")
  if [ "$m" != "present|same" ]; then
    pass "unscrubbed runner fails the case ($m)"
  else
    die "unscrubbed runner passed - the case does not bite"
  fi
else
  die "mutant runner does not parse"
fi

# --- Direct path -----------------------------------------------------------
# A test invoked without the runner carries its own scrub. Written as a pair so
# the bare variant proves the scrubbed one is doing the work.
direct_case() {
  local h p before after
  h=$(mkhost); p=$tmproot/direct.$1.test.sh
  {
    [ "$1" = scrubbed ] && printf 'unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE\n'
    cat <<'DIRECT'
set -uo pipefail
d=$(mktemp -d)
git -C "$d" init -q
git -C "$d" branch leaked-direct 2>/dev/null || true
rm -rf "$d"
DIRECT
  } > "$p"
  before=$(snap "$h")
  GIT_DIR="$h/.git" bash "$p" >/dev/null 2>&1
  after=$(snap "$h")
  [ "$before" = "$after" ] && printf same || printf changed
}

d=$(direct_case scrubbed)
if [ "$d" = same ]; then
  pass "a scrubbed test invoked directly leaves the host repo alone"
else
  die "a scrubbed test invoked directly mutated the host repo ($d)"
fi

d=$(direct_case bare)
if [ "$d" = changed ]; then
  pass "an unscrubbed test invoked directly leaks to the host ($d)"
else
  die "an unscrubbed test did not leak - the case proves nothing ($d)"
fi

# --- Coverage --------------------------------------------------------------
# Keyed on what a test does, not on a list of names, so a new fixture-creating
# test must scrub or this goes red.
missing=
for f in "$root"/scripts/test/*.test.sh; do
  grep -q 'mktemp -d' "$f" || continue
  grep -qE '(^|[^[:alnum:]-])git[[:space:]]' "$f" || continue
  grep -q '^unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE$' "$f" \
    || missing="$missing $(basename "$f")"
done
if [ -z "$missing" ]; then
  pass "every fixture-creating test scrubs the git environment"
else
  die "fixture-creating tests without a scrub:$missing"
fi

exit $fail
