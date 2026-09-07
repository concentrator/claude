#!/usr/bin/env bash
# Tests hooks/dev-session-brief.sh - the SessionStart re-brief hook (R078).
# Covers the settings.json registration, the injected last hand-off block,
# and every silent fail-open path.
# Run: bash scripts/test/dev-session-brief.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
unset CLAUDE_PROJECT_DIR DEV_STATE_DIR
ROOT="$(git rev-parse --show-toplevel)"
HOOK="$ROOT/hooks/dev-session-brief.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# The mechanism exists and is registered on SessionStart for compact/resume.
[ -x "$HOOK" ] && pass "hook file present and executable" || die "hook file missing"
jq -e '[.hooks.SessionStart[]? | select(.matcher == "compact|resume")
        | .hooks[]?.command // "" | select(test("dev-session-brief"))] | length > 0' \
  "$ROOT/settings.json" >/dev/null 2>&1 \
  && pass "hook registered on SessionStart (compact|resume)" || die "hook not registered in settings.json"

# A repo with a session file holding two hand-off blocks: the LAST one injects.
D=$(cd "$(mktemp -d)" && pwd -P); trap 'rm -rf "$D"' EXIT
git -c init.defaultBranch=main -C "$D" init -q
mkdir -p "$D/dev/session"
cat > "$D/dev/session/s9.md" <<'SES'
# session s9

## hand-off 2026-09-07T10:00:00Z
- done: the stale unit
- next: none

## tree 2026-09-07T11:00:00Z
- trigger: auto
- branch: work

## hand-off 2026-09-07T12:00:00Z
- done: the fresh unit
- next: /dev code R078-T001
- rulings: keep the list
SES
cd "$D"
out=$(printf '{"session_id":"s9"}' | bash "$HOOK" 2>/dev/null); rc=$?
[ "$rc" -eq 0 ] || die "hook exited $rc on the happy path"
ctx=$(printf '%s' "$out" | jq -r '.hookSpecificOutput.additionalContext // empty' 2>/dev/null)
[ "$(printf '%s' "$out" | jq -r '.hookSpecificOutput.hookEventName // empty' 2>/dev/null)" = "SessionStart" ] \
  && pass "output carries the SessionStart envelope" || die "envelope wrong: $out"
case "$ctx" in *"the fresh unit"*) pass "last hand-off block injected" ;; *) die "block missing from: $ctx" ;; esac
case "$ctx" in *"the stale unit"*) die "earlier hand-off leaked into the brief" ;; *) pass "earlier blocks stay out" ;; esac
case "$ctx" in *"- rulings: keep the list"*) pass "block injected to its last line" ;; *) die "block truncated: $ctx" ;; esac
case "$ctx" in *"trigger: auto"*) die "tree block leaked into the brief" ;; *) pass "tree block stays out" ;; esac
case "$ctx" in *"$D/dev/session/s9.md"*) pass "brief names its source file" ;; *) die "source file not named" ;; esac

# Silent paths: each exits 0 with no output.
silent() { # $1 = label, $2 = stdin payload
  local o r; o=$(printf '%s' "$2" | bash "$HOOK" 2>/dev/null); r=$?
  [ "$r" -eq 0 ] && [ -z "$o" ] && pass "$1" || die "$1 (rc=$r, out=$o)"
}
silent "subagent start: silent" '{"session_id":"s9","agent_id":"a1","agent_type":"code-reviewer"}'
silent "file without a hand-off: silent" '{"session_id":"treeonly"}'
printf '# session treeonly\n\n## tree 2026-09-07T11:00:00Z\n- trigger: auto\n' > "$D/dev/session/treeonly.md"
silent "hand-off-less session file: silent" '{"session_id":"treeonly"}'
silent "missing session file: silent" '{"session_id":"nosuch"}'
silent "malformed input: silent" 'not json{'
N=$(mktemp -d); cd "$N"
silent "outside a git repo: silent" '{"session_id":"s9"}'
cd /; rm -rf "$N"

(( fail == 0 )) && echo "dev-session-brief.test: OK"
exit $fail
