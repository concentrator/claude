#!/usr/bin/env bash
# Tests hooks/dev-secrets-guard.sh - the PreToolUse secrets guard. Covers the
# Write/Edit/NotebookEdit paths, the gitignore-allow and inline-override
# escapes, the git add / commit scan paths (including the -am and compound
# add+commit cases), the pattern set, and fail-open on malformed input and a
# missing jq. Fixture secrets are assembled at runtime so no matchable literal
# lives in this tracked source. Run: bash scripts/test/secrets-guard.test.sh
set -uo pipefail
HOOK="$(git rev-parse --show-toplevel)/hooks/dev-secrets-guard.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

AKIA_PREFIX="AKIA"
FAKE_AWS="${AKIA_PREFIX}IOSFODNN7EXAMPLE"                 # AKIA + 16 -> literal match
PAT_PREFIX="github_pat_"
FAKE_PAT="${PAT_PREFIX}11ABCDEFG0abcdefghijkl"            # github_pat_ + 22 -> literal match
GENERIC_VAL="Xk9mP2qL7vRt4wZn8bYc"                        # 20 chars, no known prefix

# Run the hook with JSON on stdin in the current repo; echo deny/allow.
run() { printf '%s' "$1" | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow; }

# A fresh git repo with .env gitignored and one committed tracked file.
new_repo() {
  local d; d=$(mktemp -d)
  git -C "$d" init -q
  git -C "$d" config user.email t@e >/dev/null; git -C "$d" config user.name t >/dev/null
  printf '.env\n' > "$d/.gitignore"
  printf 'clean\n' > "$d/tracked.sh"
  git -C "$d" add .gitignore tracked.sh; git -C "$d" commit -qm init >/dev/null
  printf '%s' "$d"
}

R=$(new_repo); trap 'rm -rf "$R"' EXIT; cd "$R"

# --- Write / Edit / NotebookEdit ---
j=$(jq -nc --arg c "aws_key=$FAKE_AWS" '{tool_name:"Write",tool_input:{file_path:"config.sh",content:$c}}')
[ "$(run "$j")" = deny ] && pass "write secret to tracked path denied" || die "write secret not denied"

j=$(jq -nc --arg c "aws_key=$FAKE_AWS" '{tool_name:"Write",tool_input:{file_path:".env",content:$c}}')
[ "$(run "$j")" = allow ] && pass "write to gitignored .env allowed" || die "gitignored .env denied"

j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"a.sh",content:"echo hello world"}}')
[ "$(run "$j")" = allow ] && pass "clean write allowed" || die "clean write denied"

j=$(jq -nc --arg c "token=$FAKE_AWS" '{tool_name:"Edit",tool_input:{file_path:"x.sh",new_string:$c}}')
[ "$(run "$j")" = deny ] && pass "edit secret denied" || die "edit secret not denied"

j=$(jq -nc --arg c "aws_key=$FAKE_AWS # secrets-guard: allow" '{tool_name:"Write",tool_input:{file_path:"y.sh",content:$c}}')
[ "$(run "$j")" = allow ] && pass "inline override honored" || die "override not honored"

# NotebookEdit uses new_source + notebook_path (L3)
j=$(jq -nc --arg c "api_key=$FAKE_AWS" '{tool_name:"NotebookEdit",tool_input:{notebook_path:"nb.ipynb",new_source:$c}}')
[ "$(run "$j")" = deny ] && pass "notebook secret denied" || die "notebook secret not denied"

# --- pattern coverage ---
# Fine-grained github_pat_ under a name the generic rule ignores (H1)
j=$(jq -nc --arg c "gh=$FAKE_PAT" '{tool_name:"Write",tool_input:{file_path:"z.sh",content:$c}}')
[ "$(run "$j")" = deny ] && pass "github_pat_ token denied" || die "H1: github_pat_ missed"

# Column-aligned assignment: wide separator, value with no known prefix (M2)
j=$(jq -nc --arg c "password        $GENERIC_VAL" '{tool_name:"Write",tool_input:{file_path:"w.sh",content:$c}}')
[ "$(run "$j")" = deny ] && pass "spaced assignment denied" || die "M2: spaced assignment missed"

# A low-entropy word-slug next to a trigger word is NOT a secret (no digit),
# e.g. a doc/table cell. Markdown is still scanned; only the value heuristic
# is tightened. Assembled from a var so this source carries no matchable literal.
slug="wallarm-api-token"
j=$(jq -nc --arg c "| Token | $slug |" '{tool_name:"Write",tool_input:{file_path:"docs/taxonomy.md",content:$c}}')
[ "$(run "$j")" = allow ] && pass "kebab slug next to trigger word allowed" || die "kebab slug false-positive"

# A real high-entropy value next to a trigger word is still denied in .md.
j=$(jq -nc --arg c "token: $GENERIC_VAL" '{tool_name:"Write",tool_input:{file_path:"notes.md",content:$c}}')
[ "$(run "$j")" = deny ] && pass "entropy value in .md still denied" || die "real token in .md missed"

# --- git add / commit ---
# staged secret, plain commit
gd=$(new_repo); cd "$gd"
printf 'aws_key=%s\n' "$FAKE_AWS" > leak.sh; git add leak.sh
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "commit of staged secret denied" || die "commit staged secret not denied"
cd "$R"; rm -rf "$gd"

# commit -am with an unstaged secret in a tracked file (C1)
gd=$(new_repo); cd "$gd"
printf 'aws_key=%s\n' "$FAKE_AWS" >> tracked.sh
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git commit -am wip"}}')
[ "$(run "$j")" = deny ] && pass "commit -am unstaged tracked secret denied" || die "C1: commit -am missed"
cd "$R"; rm -rf "$gd"

# compound: git add <untracked secret file> && git commit (C2)
gd=$(new_repo); cd "$gd"
printf 'aws_key=%s\n' "$FAKE_AWS" > new.sh
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git add new.sh && git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "compound add+commit secret denied" || die "C2: compound add+commit missed"
cd "$R"; rm -rf "$gd"

# secret pasted into the commit message (L4)
gd=$(new_repo); cd "$gd"
j=$(jq -nc --arg p "$FAKE_PAT" '{tool_name:"Bash",tool_input:{command:("git commit -m " + $p)}}')
[ "$(run "$j")" = deny ] && pass "secret in commit message denied" || die "L4: commit message secret missed"
cd "$R"; rm -rf "$gd"

# a benign git commit is allowed
gd=$(new_repo); cd "$gd"
printf 'echo hi\n' > ok.sh; git add ok.sh
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git commit -m normal"}}')
[ "$(run "$j")" = allow ] && pass "clean commit allowed" || die "clean commit denied"
cd "$R"; rm -rf "$gd"

# --- fail open ---
[ "$(printf 'not json{' | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow)" = allow ] \
  && pass "malformed input fails open" || die "malformed input did not fail open"

# missing jq -> fail open (run with a PATH that has only cat, no jq)
BINDIR=$(mktemp -d); ln -s "$(command -v cat)" "$BINDIR/cat"
j=$(jq -nc --arg c "aws_key=$FAKE_AWS" '{tool_name:"Write",tool_input:{file_path:"config.sh",content:$c}}')
out=$(printf '%s' "$j" | PATH="$BINDIR" "$(command -v bash)" "$HOOK" 2>/dev/null)
printf '%s' "$out" | grep -q '"permissionDecision":"deny"' && r=deny || r=allow
[ "$r" = allow ] && pass "missing jq fails open" || die "missing jq did not fail open"
rm -rf "$BINDIR"

(( fail == 0 )) && echo "secrets-guard.test: OK"
exit $fail
