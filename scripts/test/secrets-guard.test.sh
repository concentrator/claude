#!/usr/bin/env bash
# Tests hooks/dev-secrets-guard.sh - the PreToolUse secrets guard. Denies
# secret-shaped content on Write/Edit to a tracked path and on git commit of
# staged content; allows a gitignored .env, clean content, and an inline
# override; fails open on malformed input. Run: bash scripts/test/secrets-guard.test.sh
set -uo pipefail
HOOK="$(git rev-parse --show-toplevel)/hooks/dev-secrets-guard.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Fixture secret assembled at runtime so no matchable literal lives in this
# tracked source (which the guard would otherwise flag once registered).
AKIA_PREFIX="AKIA"
FAKE_AWS="${AKIA_PREFIX}IOSFODNN7EXAMPLE"   # AKIA + 16 chars -> matches

# Run the hook with JSON on stdin; echo "deny" if it denies, else "allow".
run() { printf '%s' "$1" | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow; }

R=$(mktemp -d); trap 'rm -rf "$R"' EXIT
git -C "$R" init -q
printf '.env\n' > "$R/.gitignore"
cd "$R"

# 1. Write secret to a tracked path -> deny
j=$(jq -nc --arg c "aws_key=$FAKE_AWS" '{tool_name:"Write",tool_input:{file_path:"config.sh",content:$c}}')
[ "$(run "$j")" = deny ] && pass "write secret to tracked path denied" || die "write secret not denied"

# 2. Write the same secret to a gitignored .env -> allow
j=$(jq -nc --arg c "aws_key=$FAKE_AWS" '{tool_name:"Write",tool_input:{file_path:".env",content:$c}}')
[ "$(run "$j")" = allow ] && pass "write to gitignored .env allowed" || die "gitignored .env denied"

# 3. Write clean content -> allow
j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"a.sh",content:"echo hello world"}}')
[ "$(run "$j")" = allow ] && pass "clean write allowed" || die "clean write denied"

# 4. Edit introducing a secret -> deny
j=$(jq -nc --arg c "token=$FAKE_AWS" '{tool_name:"Edit",tool_input:{file_path:"x.sh",new_string:$c}}')
[ "$(run "$j")" = deny ] && pass "edit secret denied" || die "edit secret not denied"

# 5. Inline override marker -> allow
j=$(jq -nc --arg c "aws_key=$FAKE_AWS # secrets-guard: allow" '{tool_name:"Write",tool_input:{file_path:"y.sh",content:$c}}')
[ "$(run "$j")" = allow ] && pass "inline override honored" || die "override not honored"

# 6. git commit with a staged secret -> deny
printf 'aws_key=%s\n' "$FAKE_AWS" > "$R/leak.sh"; git -C "$R" add leak.sh
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "commit of staged secret denied" || die "commit secret not denied"

# 7. Malformed input -> fail open (allow)
[ "$(printf 'not json{' | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow)" = allow ] \
  && pass "malformed input fails open" || die "malformed input did not fail open"

(( fail == 0 )) && echo "secrets-guard.test: OK"
exit $fail
