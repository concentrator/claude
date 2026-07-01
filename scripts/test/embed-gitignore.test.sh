#!/usr/bin/env bash
# Tests that vendor-toolchain.sh makes its output trackable when the
# adopter repo's .gitignore excludes .claude/ paths.
# Run: bash scripts/test/embed-gitignore.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

VENDOR="$PWD/scripts/vendor-toolchain.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

P=$(mktemp -d); trap 'rm -rf "$P"' EXIT
git -C "$P" init -q
# restrictive allowlist like the wallarm skills repo (only rules pre-allowed)
printf '.claude/*\n!.claude/rules/\n' > "$P/.gitignore"

bash "$VENDOR" "$P" >/dev/null 2>&1 || die "vendor failed"

# after vendoring, none of the vendored paths may be git-ignored
still=""
for p in .claude/skills .claude/scripts .claude/CLAUDE.md .claude/.dev-toolchain.json .claude/rules; do
  git -C "$P" check-ignore -q "$p" && still+="$p "
done
[ -z "$still" ] && pass "vendored paths not git-ignored" || die "still ignored: $still"

# and they actually get tracked by `git add`
git -C "$P" add -A 2>/dev/null
git -C "$P" ls-files .claude/skills | grep -q 'dev-' && pass "embedded skills tracked" || die "skills not tracked"
git -C "$P" ls-files .claude/scripts | grep -q 'run-all' && pass "embedded CI tracked" || die "ci not tracked"

(( fail == 0 )) && echo "embed-gitignore.test: OK"
exit $fail
