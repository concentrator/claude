#!/usr/bin/env bash
# check-secrets.sh - Tier-1 gate (R-058): no tracked file carries a secret
# pattern. Shares its predicate with the dev-secrets-guard hook
# (hooks/secret-patterns.sh - one home), so the gate and the hook judge
# content identically: a line marked with the guard's allow marker is
# exempt here too. Skips symlinks and files over ~1MB, like the hook's
# untracked scan.
set -uo pipefail

# A gate scanning nothing must not report OK: unlike the guard, fail closed.
. "$(dirname "${BASH_SOURCE[0]}")/../../hooks/secret-patterns.sh" \
  || { echo "check-secrets: cannot load hooks/secret-patterns.sh"; exit 1; }
cd "$(git rev-parse --show-toplevel)"

fail=0
while IFS= read -r f; do
  [ -f "$f" ] && [ ! -L "$f" ] || continue
  [ "$(wc -c < "$f" 2>/dev/null || echo 0)" -le 1000000 ] || continue
  if has_secret < "$f"; then
    [ "$fail" -eq 0 ] && echo "SECRETS: tracked content matches a secret pattern; move it to a gitignored file, or mark the line 'secrets-guard: allow' if it is provably not a live credential:"
    echo "  $f"
    fail=1
  fi
done < <(git ls-files)

[ "$fail" -eq 0 ] && echo "check-secrets: OK"
exit $fail
