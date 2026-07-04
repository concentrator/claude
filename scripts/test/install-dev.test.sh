#!/usr/bin/env bash
# Tests scripts/install-dev.sh — installs the DEV toolset into a target
# .claude. Run: bash scripts/test/install-dev.test.sh
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

P=$(mktemp -d); trap 'rm -rf "$P"' EXIT

# Pre-existing settings: an unrelated key + a PostToolUse hook (must survive).
mkdir -p "$P/.claude"
printf '{"model":"x","hooks":{"PostToolUse":[{"matcher":"Skill","hooks":[{"type":"command","command":"echo hi"}]}]}}\n' > "$P/.claude/settings.json"

bash "$INSTALL" --project "$P" >/dev/null 2>&1 || die "install exits nonzero"

# --- copied: router + companion + a bundled skill + the hook ---
[ -f "$P/.claude/skills/dev/SKILL.md" ]  && pass "dev router copied"            || die "no dev router"
[ -f "$P/.claude/skills/dev/plan.md" ]   && pass "dev companion copied"         || die "no dev companion"
[ -d "$P/.claude/skills/test-driven-development" ] && pass "bundled skill copied" || die "no bundled skill"
[ -x "$P/.claude/hooks/dev-branch-guard.sh" ]      && pass "hook copied + exec"   || die "no/again hook"

# --- NOT shipped: personal convention rules ---
[ ! -e "$P/.claude/rules/git-workflow.md" ] && pass "personal rules not shipped" || die "personal rule shipped"

# --- settings.json: branch-guard registered; pre-existing survives ---
jq -e '[.hooks.PreToolUse[]?.hooks[]?.command] | any(test("dev-branch-guard"))' "$P/.claude/settings.json" >/dev/null \
  && pass "branch-guard registered" || die "branch-guard not registered"
jq -e '.model == "x"' "$P/.claude/settings.json" >/dev/null && pass "pre-existing setting survives" || die "clobbered model"
jq -e '.hooks.PostToolUse[0].matcher == "Skill"' "$P/.claude/settings.json" >/dev/null && pass "pre-existing PostToolUse survives" || die "clobbered PostToolUse"

# --- idempotent: re-run adds no duplicate branch-guard blocks ---
bash "$INSTALL" --project "$P" >/dev/null 2>&1
n=$(jq '[.hooks.PreToolUse[]? | select(any(.hooks[]?.command; test("dev-branch-guard")))] | length' "$P/.claude/settings.json")
[ "$n" = "2" ] && pass "idempotent (2 matcher blocks, no dupes)" || die "not idempotent: $n branch-guard blocks"

# --- malformed settings.json → install fails loudly, file untouched ---
Q=$(mktemp -d)
mkdir -p "$Q/.claude"; printf 'not json{' > "$Q/.claude/settings.json"
bash "$INSTALL" --project "$Q" >/dev/null 2>&1 && die "install succeeded on malformed settings" || pass "install fails on malformed settings"
[ "$(cat "$Q/.claude/settings.json")" = 'not json{' ] && pass "malformed settings left intact" || die "malformed settings mutated"
rm -rf "$Q"

# --- global path (no --project): installs into HOME/.claude with a ~/... hook ---
H=$(mktemp -d)
HOME="$H" bash "$INSTALL" >/dev/null 2>&1 || die "global install exits nonzero"
[ -f "$H/.claude/skills/dev/SKILL.md" ] && pass "global install copies toolset" || die "global install missing toolset"
jq -e '[.hooks.PreToolUse[]?.hooks[]?.command] | any(. == "~/.claude/hooks/dev-branch-guard.sh")' "$H/.claude/settings.json" >/dev/null \
  && pass "global hook path is ~/.claude/..." || die "global hook path wrong"
rm -rf "$H"

(( fail == 0 )) && echo "install-dev.test: OK"
exit $fail
