#!/usr/bin/env bash
# Tests scripts/install-dev.sh - installs the DEV toolset into a target
# .claude. Run: bash scripts/test/install-dev.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
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
[ -d "$P/.claude/skills/dev/companions" ] && [ -z "$(find "$P/.claude/skills/dev/companions" -mindepth 1 -type d)" ] && pass "companions ship as files only" || die "companions missing or ship a subdirectory"
[ -d "$P/.claude/skills/test-driven-development" ] && pass "bundled skill copied" || die "no bundled skill"
[ -x "$P/.claude/hooks/dev-branch-guard.sh" ]      && pass "hook copied + exec"   || die "no/again hook"
[ -x "$P/.claude/hooks/dev-secrets-guard.sh" ]     && pass "secrets hook copied + exec" || die "no secrets hook"
[ -f "$P/.claude/hooks/secret-patterns.sh" ]       && pass "secret patterns copied" || die "no secret patterns"
[ -x "$P/.claude/hooks/dev-branch-state.sh" ]      && pass "state hook copied + exec" || die "no state hook"
[ -x "$P/.claude/hooks/dev-precompact-state.sh" ]  && pass "session-state writer copied + exec" || die "no session-state writer"
[ -x "$P/.claude/scripts/ci/check-code-size.sh" ]  && pass "code-size check copied + exec" || die "no code-size check"
[ -x "$P/.claude/scripts/ci/check-no-em-dash.sh" ] && pass "no-em-dash check copied + exec" || die "no no-em-dash check"
[ -f "$P/.claude/scripts/ci/code-size-allow.txt" ] && pass "code-size allowlist template" || die "no code-size allowlist"
[ -x "$P/.claude/scripts/ci/check-accretion.sh" ]  && pass "accretion check copied + exec" || die "no accretion check"
[ -x "$P/.claude/scripts/ci/check-batch-tags.sh" ] && pass "batch-tags check copied + exec" || die "no batch-tags check"
[ -f "$P/.claude/scripts/test/check-accretion.test.sh" ]  && pass "accretion self-test copied" || die "no accretion self-test"
[ -f "$P/.claude/scripts/test/check-batch-tags.test.sh" ] && pass "batch-tags self-test copied" || die "no batch-tags self-test"
grep -q 'BASH_SOURCE' "$P/.claude/scripts/test/check-accretion.test.sh" \
  && grep -q 'BASH_SOURCE' "$P/.claude/scripts/test/check-batch-tags.test.sh" \
  && pass "copied self-tests resolve their check relatively" \
  || die "copied self-test pinned to the repo root"

# --- copied gates bite from the install location ---
R=$(mktemp -d); git -C "$R" init -q -b main
mkdir -p "$R/dev/plans"
printf -- 'Superseded: 2026-07-07 by the new flow.\n' > "$R/dev/plans/ROADMAP.md"
git -C "$R" add -A
out=$( cd "$R" && env -u CI bash "$P/.claude/scripts/ci/check-accretion.sh" 2>&1 ); rc=$?
[ $rc -ne 0 ] && grep -q 'ACCRETION:' <<<"$out" \
  && pass "copied accretion gate bites from install location" \
  || die "copied accretion gate did not bite: $out"
git -C "$R" -c user.email=t@t -c user.name=t commit -qm init
mkdir -p "$R/dev/plans/R-042-x/batches"; printf 'r\n' > "$R/dev/plans/R-042-x/batches/B-001.report.md"
git -C "$R" add -A; git -C "$R" -c user.email=t@t -c user.name=t commit -qm report
git -C "$R" tag pre-R042-B-001
out=$( cd "$R" && env -u CI bash "$P/.claude/scripts/ci/check-batch-tags.sh" 2>&1 ); rc=$?
[ $rc -ne 0 ] && grep -q 'BATCH-TAGS:' <<<"$out" \
  && pass "copied batch-tags gate bites from install location" \
  || die "copied batch-tags gate did not bite: $out"
rm -rf "$R"

# --- the vendored self-tests carry T001's scrub, and it holds from the install
# location: a leaked git environment must not reach the adopter's own repo ---
SCRUB='unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE'
miss=
for t in check-accretion check-batch-tags; do
  grep -qxF -- "$SCRUB" "$P/.claude/scripts/test/$t.test.sh" || miss="$miss $t"
done
[ -z "$miss" ] && pass "vendored self-tests carry the isolation scrub" \
  || die "vendored self-tests missing the scrub:$miss"

# A stand-in adopter repo, left with an unstaged edit so a leaked `add` shows
# in its index as well as its refs.
VH=$(mktemp -d); git -C "$VH" init -q -b main
printf 'committed\n' > "$VH/hostfile"; git -C "$VH" add -A
git -C "$VH" -c user.email=t@t -c user.name=t commit -q -m base
printf 'unstaged\n' > "$VH/hostfile"
# The five components a leak can move; mirrors scripts/test/isolation.test.sh.
hsnap() {
  git -C "$VH" show-ref -d 2>/dev/null
  git -C "$VH" config --local --list 2>/dev/null | sort
  git -C "$VH" symbolic-ref -q HEAD 2>/dev/null
  git -C "$VH" ls-files -s 2>/dev/null
  ( cd "$VH/.git" 2>/dev/null && find . -type f | sort )
}
for t in check-accretion check-batch-tags; do
  before=$(hsnap)
  # From a throwaway cwd: a leaking copy captures git's "nothing to commit" on
  # stdout as a fixture path and mkdir's it relative to where it was invoked.
  W=$(mktemp -d)
  out=$( cd "$W" && env GIT_DIR="$VH/.git" GIT_WORK_TREE="$VH" \
           GIT_INDEX_FILE="$VH/.git/index" \
           bash "$P/.claude/scripts/test/$t.test.sh" 2>&1 ); rc=$?
  rm -rf "$W"
  # A mutated host is proof of a leak whatever the exit status - a leaking copy
  # usually fails too. Only a clean host has to prove the run happened at all.
  if [ "$before" != "$(hsnap)" ]; then
    die "vendored $t mutated the leaked host repo"
  elif [ $rc -ne 0 ] || ! grep -q "$t.test: OK" <<<"$out"; then
    die "vendored $t did not run under a leaked environment (rc=$rc)"
  else
    pass "vendored $t leaves a leaked host repo alone"
  fi
done
rm -rf "$VH"

# --- a tuned MARKERS list survives re-install ---
T=$(mktemp); sed "s/^MARKERS=.*/MARKERS='justonemarker'/" \
  "$P/.claude/scripts/ci/check-accretion.sh" > "$T" \
  && mv "$T" "$P/.claude/scripts/ci/check-accretion.sh"
bash "$INSTALL" --project "$P" >/dev/null 2>&1
grep -q "^MARKERS='justonemarker'" "$P/.claude/scripts/ci/check-accretion.sh" \
  && pass "tuned MARKERS survives re-install" || die "re-install clobbered MARKERS"
[ -f "$P/.claude/writing.md" ]                     && pass "writing.md copied" || die "no writing.md"
[ -f "$P/.claude/rules/writing-artifacts.md" ] && pass "writing-artifacts rule copied" || die "no writing-artifacts rule"
grep -qxF '@writing.md' "$P/.claude/CLAUDE.md" 2>/dev/null && pass "writing.md imported in CLAUDE.md" || die "writing.md not imported"

# --- NOT shipped: personal convention rules ---
[ "$(ls "$P/.claude/rules")" = "writing-artifacts.md" ] && pass "personal rules not shipped" || die "rules/ holds: $(ls "$P/.claude/rules" | tr "\n" " ")"

# --- settings.json: branch-guard registered; pre-existing survives ---
jq -e '[.hooks.PreToolUse[]?.hooks[]?.command] | any(test("dev-branch-guard"))' "$P/.claude/settings.json" >/dev/null \
  && pass "branch-guard registered" || die "branch-guard not registered"
jq -e '[.hooks.PreToolUse[]?.hooks[]?.command] | any(test("dev-secrets-guard"))' "$P/.claude/settings.json" >/dev/null \
  && pass "secrets-guard registered" || die "secrets-guard not registered"
jq -e '[.hooks.UserPromptSubmit[]?.hooks[]?.command] | any(test("dev-branch-state"))' "$P/.claude/settings.json" >/dev/null \
  && pass "branch-state registered on UserPromptSubmit" || die "branch-state not registered"
jq -e '.model == "x"' "$P/.claude/settings.json" >/dev/null && pass "pre-existing setting survives" || die "clobbered model"
jq -e '.hooks.PostToolUse[0].matcher == "Skill"' "$P/.claude/settings.json" >/dev/null && pass "pre-existing PostToolUse survives" || die "clobbered PostToolUse"

# --- project-tier hooks register by $CLAUDE_PROJECT_DIR: a hook command runs
# in the session's cwd, so only this form resolves after a cd ---
PFX='"$CLAUDE_PROJECT_DIR"/.claude/hooks'
for h in dev-branch-guard dev-secrets-guard; do
  n=$(jq --arg c "$PFX/$h.sh" '[.hooks.PreToolUse[]?.hooks[]?.command | select(. == $c)] | length' "$P/.claude/settings.json")
  [ "$n" = "2" ] && pass "$h registered by \$CLAUDE_PROJECT_DIR (2 matchers)" || die "$h: $n \$CLAUDE_PROJECT_DIR entries"
done
n=$(jq --arg c "$PFX/dev-branch-state.sh" '[.hooks.UserPromptSubmit[]?.hooks[]?.command | select(. == $c)] | length' "$P/.claude/settings.json")
[ "$n" = "1" ] && pass "dev-branch-state registered by \$CLAUDE_PROJECT_DIR" || die "dev-branch-state: $n \$CLAUDE_PROJECT_DIR entries"

# --- a settings file holding the relative form ends with one entry per hook
# and matcher in the new form, and none in the old ---
O=$(mktemp -d); mkdir -p "$O/.claude"
jq -n '{hooks:{PreToolUse:[
  {matcher:"Write|Edit|NotebookEdit",hooks:[{type:"command",command:".claude/hooks/dev-branch-guard.sh"}]},
  {matcher:"Bash",hooks:[{type:"command",command:".claude/hooks/dev-branch-guard.sh"}]},
  {matcher:"Write|Edit|NotebookEdit",hooks:[{type:"command",command:".claude/hooks/dev-secrets-guard.sh"}]},
  {matcher:"Bash",hooks:[{type:"command",command:".claude/hooks/dev-secrets-guard.sh"}]}],
  UserPromptSubmit:[{hooks:[{type:"command",command:".claude/hooks/dev-branch-state.sh"}]}]}}' > "$O/.claude/settings.json"
bash "$INSTALL" --project "$O" >/dev/null 2>&1 || die "install over the relative form exits nonzero"
old=$(jq '[.. | strings | select(startswith(".claude/hooks/"))] | length' "$O/.claude/settings.json")
[ "$old" = "0" ] && pass "relative hook entries removed on re-install" || die "$old relative hook entries remain"
n=$(jq '[.hooks.PreToolUse[]?.hooks[]?.command] | length' "$O/.claude/settings.json")
[ "$n" = "4" ] && pass "one PreToolUse entry per hook and matcher after re-install" || die "PreToolUse holds $n entries after re-install"
n=$(jq '[.hooks.UserPromptSubmit[]?.hooks[]?.command] | length' "$O/.claude/settings.json")
[ "$n" = "1" ] && pass "one UserPromptSubmit entry after re-install" || die "UserPromptSubmit holds $n entries after re-install"
rm -rf "$O"

# --- the registered command fires from a subdirectory: a trunk write is
# still denied after the session has cd'd away from the project root ---
S=$(mktemp -d); git -C "$S" init -q -b main
printf 'x\n' > "$S/f.sh"; git -C "$S" add -A; git -C "$S" -c user.email=t@t -c user.name=t commit -qm init
bash "$INSTALL" --project "$S" >/dev/null 2>&1 || die "install (subdirectory fixture) exits nonzero"
mkdir -p "$S/sub"
cmd=$(jq -r '[.hooks.PreToolUse[]?.hooks[]?.command | select(test("dev-branch-guard"))][0]' "$S/.claude/settings.json")
j=$(jq -nc --arg p "$S/f.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"y"}}')
out=$(cd "$S/sub" && printf '%s' "$j" | CLAUDE_PROJECT_DIR="$S" bash -c "$cmd" 2>/dev/null)
grep -q '"permissionDecision":"deny"' <<<"$out" && pass "registered guard denies a trunk write from a subdirectory" \
  || die "registered guard did not fire from a subdirectory: $cmd"
rm -rf "$S"

# --- idempotent: re-run adds no duplicate branch-guard blocks ---
bash "$INSTALL" --project "$P" >/dev/null 2>&1
n=$(jq '[.hooks.PreToolUse[]? | select(any(.hooks[]?.command; test("dev-branch-guard")))] | length' "$P/.claude/settings.json")
[ "$n" = "2" ] && pass "idempotent (2 matcher blocks, no dupes)" || die "not idempotent: $n branch-guard blocks"
n=$(jq '[.hooks.UserPromptSubmit[]? | select(any(.hooks[]?.command; test("dev-branch-state")))] | length' "$P/.claude/settings.json")
[ "$n" = "1" ] && pass "branch-state idempotent (1 block)" || die "not idempotent: $n branch-state blocks"
[ "$(grep -c '^@writing.md$' "$P/.claude/CLAUDE.md")" = "1" ] && pass "writing import idempotent" || die "writing import duplicated"

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

# --- committability: restrictive .claude/* gitignore → installed paths trackable ---
G=$(mktemp -d); git -C "$G" init -q
printf '.claude/*\n' > "$G/.gitignore"
bash "$INSTALL" --project "$G" >/dev/null 2>&1 || die "install (gitignore fixture) exits nonzero"
still=""
for p in .claude/skills .claude/hooks/dev-branch-guard.sh .claude/scripts/ci/check-code-size.sh .claude/writing.md .claude/rules/writing-artifacts.md .claude/settings.json; do
  git -C "$G" check-ignore -q "$p" && still="$still $p"
done
[ -z "$still" ] && pass "installed paths trackable under .claude/* gitignore" || die "still ignored:$still"
bash "$INSTALL" --project "$G" >/dev/null 2>&1
[ "$(grep -c '^!.claude/hooks/$' "$G/.gitignore")" = "1" ] && pass "gitignore allowlist idempotent" || die "duplicate allowlist entries"
[ "$(grep -c '^/dev/session/$' "$G/.gitignore")" = "1" ] && pass "session dir ignored once" || die "session ignore line: $(grep -c '^/dev/session/$' "$G/.gitignore")"
git -C "$G" check-ignore -q "skills/x/session/f" && die "unanchored session ignore" || pass "session ignore is anchored to the root"
rm -rf "$G"

(( fail == 0 )) && echo "install-dev.test: OK"
exit $fail
