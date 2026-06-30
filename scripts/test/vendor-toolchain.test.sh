#!/usr/bin/env bash
# Tests for scripts/vendor-toolchain.sh — vendors the portable DEV core
# into a target project's .claude/. Run: bash scripts/test/vendor-toolchain.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

VENDOR="scripts/vendor-toolchain.sh"
fail=0
pass() { echo "ok - $1"; }
die() { echo "not ok - $1"; fail=1; }

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# --- run the vendor once into a fresh target ---
D="$tmp/proj/.claude"
if bash "$VENDOR" "$tmp/proj" >/dev/null 2>&1; then
  [ -d "$D" ] && pass "creates <target>/.claude" || die "no .claude created"
else
  die "vendor exits nonzero"
fi

# --- copy + prune (manifest-driven) ---
[ -f "$D/rules/planning.md" ]   && pass "portable rule copied"      || die "missing rules/planning.md"
[ -f "$D/skills/dev/SKILL.md" ] && pass "portable skill copied"     || die "missing skills/dev"
[ ! -e "$D/rules/js.md" ]       && pass "excludes js.md"            || die "js.md leaked"
[ ! -e "$D/skills/wallarm-triggers" ] && pass "excludes wallarm-*"  || die "wallarm-* leaked"

# --- path rewrite: ~/.claude/ -> .claude/ (example file protected) ---
# post-namespacing location (writing-skills -> dev-writing-skills)
EXAMPLE='skills/dev-writing-skills/examples/CLAUDE_MD_TESTING.md'
resid=$(grep -rl '~/\.claude/' "$D" --exclude='CLAUDE_MD_TESTING.md' 2>/dev/null || true)
[ -z "$resid" ] && pass "no residual ~/.claude refs" \
  || die "residual ~/.claude in: $(echo "$resid" | tr '\n' ' ')"
grep -q '~/\.claude/' "$D/$EXAMPLE" && pass "example protected from rewrite" \
  || die "example refs were rewritten"

# --- dev-* namespacing (orchestrator `dev` unchanged; `release` guard in rules) ---
[ -d "$D/skills/dev-finishing-a-branch" ] && pass "skill dir prefixed"        || die "skill not renamed"
[ ! -e "$D/skills/finishing-a-branch" ]   && pass "old skill name gone"        || die "old skill name remains"
[ -d "$D/skills/dev" ]                     && pass "orchestrator dev unchanged" || die "dev renamed"
grep -q 'dev-adding-a-feature' "$D/skills/dev/SKILL.md" && pass "dispatch ref prefixed" || die "dispatch not prefixed"
grep -q '`dev-release`' "$D/skills/dev/SKILL.md"        && pass "release skill-ref prefixed" || die "release skill-ref not prefixed"
if grep -q '`release`' "$D/rules/git-workflow.md" && ! grep -q 'dev-release' "$D/rules/git-workflow.md"; then
  pass "branch-prefix release preserved in rules"
else die "branch-prefix release corrupted in rules"; fi
! grep -rq '\.claude/skills/finishing-a-branch' "$D" && pass "no stale skill path refs" || die "stale skill path ref"

# --- generic CLAUDE.md backbone ---
[ -f "$D/CLAUDE.md" ]            && pass "CLAUDE.md backbone emitted" || die "no CLAUDE.md"
grep -q '@rules/' "$D/CLAUDE.md" && pass "backbone @-imports rules"   || die "no @-imports"
grep -qi 'dev' "$D/CLAUDE.md"    && pass "backbone names DEV workflow"|| die "no DEV mention"

# --- genericize verification-policy Models table (in the copy) ---
VP="$D/skills/dev-delegating-to-agents/verification-policy.md"
! grep -qE 'Opus 4\.8|Sonnet 4\.6|Fable 5' "$VP" && pass "model IDs genericized" || die "repo model IDs remain"
grep -q 'Adopter slot' "$VP"  && pass "adopter model slot present" || die "no model slot"
! grep -q 'B-003' "$VP"        && pass "repo batch evidence removed" || die "B-003 remains"

# --- version stamp / embed marker ---
STAMP="$D/.dev-toolchain.json"
[ -f "$STAMP" ]              && pass "version stamp written"        || die "no stamp"
grep -q '"source"' "$STAMP"  && pass "stamp records source version" || die "stamp missing source"

# --- structural completeness (manifest's portable set) ---
nrules=$(ls "$D"/rules/*.md 2>/dev/null | wc -l | tr -d ' ')
[ "$nrules" = "8" ]  && pass "8 portable rules present"  || die "expected 8 rules, got $nrules"
nskills=$(ls -d "$D"/skills/*/ 2>/dev/null | wc -l | tr -d ' ')
[ "$nskills" = "18" ] && pass "18 portable skills present" || die "expected 18 skills, got $nskills"

# --- re-run guard (idempotent update-in-place is deferred to T-033) ---
if bash "$VENDOR" "$tmp/proj" >/dev/null 2>&1; then
  die "re-run into embedded target not refused"
else
  pass "re-run into embedded target refused"
fi
[ ! -e "$D/skills/dev-dev-adding-a-feature" ] && pass "no double-prefix" || die "double-prefixed on re-run"

(( fail == 0 )) && echo "vendor-toolchain.test: OK"
exit $fail
