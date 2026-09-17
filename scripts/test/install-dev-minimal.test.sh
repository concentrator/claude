#!/usr/bin/env bash
# Tests scripts/install-dev.sh --minimal - the contributor set. The full set
# and the shared steps are covered by install-dev.test.sh.
# Run: bash scripts/test/install-dev-minimal.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# --- --minimal: delivery skill files only, no router or bundled skills; the
# rest of the set unchanged; over a full install it drops the other dev files ---
N=$(mktemp -d)
bash "$INSTALL" --project "$N" >/dev/null 2>&1 && bash "$INSTALL" --project "$N" --minimal >/dev/null 2>&1 || die "minimal install exits nonzero"
got=$(cd "$N/.claude/skills/dev" && find . -type f | sed 's|^\./||' | sort | tr '\n' ' ')
want="companions/declarations.md companions/secrets.md companions/toolchain.md companions/untracked-claude.md finish.md git-workflow.md handoff.md "
[ "$got" = "$want" ] && pass "minimal ships only the delivery skill files" || die "minimal skills/dev holds: $got"
M2=$(mktemp -d); bash "$INSTALL" --project "$M2" --minimal >/dev/null 2>&1 || die "fresh minimal install exits nonzero"
[ "$(ls "$M2/.claude/skills")" = "dev" ] && pass "minimal ships no bundled skills" || die "minimal skills/ holds: $(ls "$M2/.claude/skills" | tr '\n' ' ')"
miss=
for f in hooks/dev-branch-guard.sh hooks/dev-secrets-guard.sh hooks/dev-branch-state.sh hooks/dev-handoff-nudge.sh hooks/dev-session-brief.sh \
         scripts/ci/check-plan-text.sh scripts/preflight-permissions.sh writing.md rules/writing-artifacts.md MAINTENANCE.md; do
  [ -f "$M2/.claude/$f" ] || miss="$miss $f"
done
[ -z "$miss" ] && pass "minimal keeps hooks, checks, pre-flight, writing and maintenance" || die "minimal missing:$miss"
jq -e '[.hooks.PreToolUse[]?.hooks[]?.command] | any(test("dev-branch-guard"))' "$M2/.claude/settings.json" >/dev/null \
  && pass "minimal registers the hooks" || die "minimal registered no branch-guard"
rm -rf "$N" "$M2"

(( fail == 0 )) && echo "install-dev-minimal.test: OK"
exit $fail
