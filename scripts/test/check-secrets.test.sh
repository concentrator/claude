#!/usr/bin/env bash
# Tests scripts/ci/check-secrets.sh - the Tier-1 tracked-secrets scan. One
# seeded case per pattern class, a clean-tree pass, the allow-marker
# exemption, and the symlink and >1MB skips. Fixture secrets are assembled
# at runtime so no matchable literal lives in this tracked source.
# Run: bash scripts/test/check-secrets.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
CHECK="$(git rev-parse --show-toplevel)/scripts/ci/check-secrets.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Seed one tracked file in a fresh repo, run the check there. A deny must
# exit nonzero AND name the file; an allow must print the OK verdict.
run_case() {   # $1 = name, $2 = deny|allow, $3 = content
  local T out rc
  T=$(mktemp -d)
  git -C "$T" init -q
  printf '%s\n' "$3" > "$T/f.txt"
  git -C "$T" add f.txt
  out=$(cd "$T" && bash "$CHECK" 2>&1); rc=$?
  rm -rf "$T"
  if [ "$2" = deny ]; then
    [ "$rc" -ne 0 ] && [[ "$out" == *f.txt* ]] && pass "$1" || die "$1"
  else
    [ "$rc" -eq 0 ] && [[ "$out" == *"check-secrets: OK"* ]] && pass "$1" || die "$1"
  fi
}

# --- one seeded case per pattern class (assembled, never literal) ---
PK='-----BEGIN '; PK="${PK}PRIVATE KEY-----"
run_case "private key header caught" deny "$PK"

AWS="AKIA"; AWS="${AWS}IOSFODNN7EXAMPLE"
run_case "AWS key id caught" deny "aws=$AWS"

GH="ghp_"; GH="${GH}abcdefghijklmnopqrstuvwxyz0123456789"
run_case "GitHub token caught" deny "$GH"

PAT="github_pat_"; PAT="${PAT}11ABCDEFG0abcdefghijkl"
run_case "fine-grained PAT caught" deny "$PAT"

SL="xoxb-"; SL="${SL}0123456789ab"
run_case "Slack token caught" deny "$SL"

GK="AIza"; GK="${GK}abcdefghijklmnopqrstuvwxyz012345678"
run_case "Google API key caught" deny "$GK"

GEN="token"; GEN="${GEN}=Zx9abcdefghijklmnop"
run_case "generic name+value caught" deny "$GEN"

# --- allowed content ---
run_case "clean tree passes" allow "plain notes, nothing shaped like a credential"

run_case "allow-marker line exempt" allow "$GEN # secrets-guard: allow"

# A tracked symlink is skipped even when its target carries a secret.
T=$(mktemp -d)
git -C "$T" init -q
printf '%s\n' "$GEN" > "$T/s.txt"        # untracked target
ln -s s.txt "$T/link"
git -C "$T" add link
out=$(cd "$T" && bash "$CHECK" 2>&1); rc=$?
rm -rf "$T"
[ "$rc" -eq 0 ] && [[ "$out" == *"check-secrets: OK"* ]] \
  && pass "tracked symlink skipped" || die "tracked symlink scanned"

# A secret early in a large (sub-1MB) file is still caught: grep -q's
# early exit must not turn the match into a SIGPIPE loss under pipefail.
BIG_EARLY="aws=$AWS
$(head -c 500000 /dev/zero | tr '\0' 'a')"
run_case "early secret in large file caught" deny "$BIG_EARLY"

# The check fails closed when its predicate cannot load: a copy of the
# check in a layout without hooks/secret-patterns.sh must fail, not OK.
T=$(mktemp -d)
mkdir -p "$T/broken/scripts/ci" "$T/repo"
cp "$CHECK" "$T/broken/scripts/ci/check-secrets.sh"
git -C "$T/repo" init -q
printf 'plain\n' > "$T/repo/f.txt"
git -C "$T/repo" add f.txt
out=$(cd "$T/repo" && bash "$T/broken/scripts/ci/check-secrets.sh" 2>&1); rc=$?
rm -rf "$T"
[ "$rc" -ne 0 ] && [[ "$out" == *secret-patterns.sh* ]] \
  && pass "missing predicate fails closed" || die "missing predicate passed"

# A tracked file over 1MB is skipped.
T=$(mktemp -d)
git -C "$T" init -q
{ head -c 1100000 /dev/zero | tr '\0' 'a'; printf '\n%s\n' "$GEN"; } > "$T/big.txt"
git -C "$T" add big.txt
out=$(cd "$T" && bash "$CHECK" 2>&1); rc=$?
rm -rf "$T"
[ "$rc" -eq 0 ] && [[ "$out" == *"check-secrets: OK"* ]] \
  && pass ">1MB blob skipped" || die ">1MB blob scanned"

(( fail == 0 )) && echo "check-secrets.test: OK"
exit $fail
