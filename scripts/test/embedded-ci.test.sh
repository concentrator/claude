#!/usr/bin/env bash
# Tests the embedded CI subset shipped by vendor-toolchain.sh.
# Run: bash scripts/test/embedded-ci.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

VENDOR="$PWD/scripts/vendor-toolchain.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

P=$(mktemp -d); trap 'rm -rf "$P"' EXIT
git -C "$P" init -q
git -C "$P" config user.email t@t; git -C "$P" config user.name t
bash "$VENDOR" "$P" >/dev/null 2>&1 || die "vendor failed"

# the vendored CI subset: 3 portable checks + run-all, no ledger/stray/todos
CID="$P/.claude/scripts/ci"
[ -f "$CID/check-caps.sh" ] && [ -f "$CID/check-plan-integrity.sh" ] && [ -f "$CID/check-references.sh" ] \
  && pass "3 portable checks vendored" || die "missing portable checks"
[ -f "$CID/run-all.sh" ] && pass "embedded run-all vendored" || die "no embedded run-all"
for x in ledger stray todos; do
  [ ! -e "$CID/check-$x.sh" ] || die "non-portable check-$x vendored"
done
pass "ledger/stray/todos excluded"

# minimal adopter artifacts the checks need, then run the embedded gate
printf '# Design\n' > "$P/.claude/DESIGN.md"
mkdir -p "$P/.claude/plans"; printf '# Roadmap\n' > "$P/.claude/plans/ROADMAP.md"
git -C "$P" add -A
out=$( cd "$P" && bash .claude/scripts/ci/run-all.sh 2>&1 ); rc=$?
{ [ $rc -eq 0 ] && echo "$out" | grep -q 'ALL OK'; } && pass "embedded gate green" || die "gate: $out"

(( fail == 0 )) && echo "embedded-ci.test: OK"
exit $fail
