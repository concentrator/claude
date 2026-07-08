#!/usr/bin/env bash
# Tests scripts/ci/check-ledger.sh - the Tier-1 ledger gate over the
# per-commit stamp store (maintenance.d/<sha>.json). Covers: a stamp
# certifying HEAD's content tip passes; a missing stamp fails; a stamp whose
# <sha>..HEAD touches a non-ledger file fails; two independent stamp files
# coexist on separate paths (the conflict-free property) and still certify.
# Runs the script inside throwaway repos (it cd's to the git toplevel).
# Run: bash scripts/test/check-ledger.test.sh
set -uo pipefail
SCRIPT="$(git rev-parse --show-toplevel)/scripts/ci/check-ledger.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Run the gate with cwd inside repo $1; echo pass/fail by exit code.
run() { ( cd "$1" && bash "$SCRIPT" >/dev/null 2>&1 && echo pass || echo fail ); }

new_repo() {
  local d; d=$(mktemp -d)
  git -c init.defaultBranch=main -C "$d" init -q
  git -C "$d" config user.email t@e >/dev/null; git -C "$d" config user.name t >/dev/null
  printf 'seed\n' > "$d/file.txt"
  git -C "$d" add file.txt; git -C "$d" commit -qm seed >/dev/null
  printf '%s' "$d"
}
# Append a content commit touching file.txt; echo its full sha.
content_commit() { git -C "$1" commit -q --allow-empty -m "$2" >/dev/null 2>&1 || true;
  printf '%s' "change $2" >> "$1/file.txt"; git -C "$1" add file.txt;
  git -C "$1" commit -qm "$2" >/dev/null; git -C "$1" rev-parse HEAD; }
# Write a stamp file certifying $2 (a sha) and commit it alone.
stamp() { mkdir -p "$1/maintenance.d";
  printf '{"sha":"%s","reviewed":"2026-07-08","concerns_clear":true}\n' "$2" > "$1/maintenance.d/$2.json";
  git -C "$1" add "maintenance.d/$2.json"; git -C "$1" commit -qm "stamp $2" >/dev/null; }

# 1. A stamp certifying the content tip passes.
R=$(new_repo); tip=$(content_commit "$R" work); stamp "$R" "$tip"
[ "$(run "$R")" = pass ] && pass "stamp certifying HEAD content tip passes" || die "valid stamp did not pass"
rm -rf "$R"

# 2. No stamp at all fails (no maintenance.d/).
R=$(new_repo); content_commit "$R" work >/dev/null
[ "$(run "$R")" = fail ] && pass "missing stamp fails" || die "missing stamp did not fail"
rm -rf "$R"

# 3. A stamp whose <sha>..HEAD touches a non-ledger file fails.
R=$(new_repo); tip=$(content_commit "$R" work); stamp "$R" "$tip"
content_commit "$R" later >/dev/null   # content moves past the stamped tip
[ "$(run "$R")" = fail ] && pass "stale stamp (content beyond it) fails" || die "stale stamp did not fail"
rm -rf "$R"

# 4. Two independent stamp files coexist on separate paths and still certify.
R=$(new_repo); s1=$(content_commit "$R" a); stamp "$R" "$s1"
tip=$(content_commit "$R" b); stamp "$R" "$tip"
n=$(ls "$R"/maintenance.d/*.json | wc -l | tr -d ' ')
[ "$n" = 2 ] && pass "two stamps live on separate files" || die "expected 2 stamp files, got $n"
[ "$(run "$R")" = pass ] && pass "newest stamp certifies HEAD among many" || die "multi-stamp did not pass"
rm -rf "$R"

# 5. A non-stamp file parked under maintenance.d/ after a valid stamp fails -
# only well-formed <sha>.json stamps count as ledger, not arbitrary content.
R=$(new_repo); tip=$(content_commit "$R" work); stamp "$R" "$tip"
printf 'payload\n' > "$R/maintenance.d/evil.sh"
git -C "$R" add "maintenance.d/evil.sh"; git -C "$R" commit -qm "sneak" >/dev/null
[ "$(run "$R")" = fail ] && pass "unreviewed non-stamp under maintenance.d/ fails" || die "non-stamp content passed the gate"
rm -rf "$R"

(( fail == 0 )) && echo "check-ledger.test: OK"
exit $fail
