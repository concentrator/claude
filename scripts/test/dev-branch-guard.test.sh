#!/usr/bin/env bash
# Tests hooks/dev-branch-guard.sh - the PreToolUse trunk guard. Covers the
# true-positives (a Write and a `git commit` on main are denied), the three
# false-positives R-024/T-058 fixes (a gitignored-path Write on main, a
# compound `checkout -b && commit`, and a cross-repo `git -C <branch> commit`
# are all allowed), the cross-repo correctness case (`git -C <main>` from a
# branch cwd is denied), and fail-open on malformed input / outside a repo.
# Run: bash scripts/test/dev-branch-guard.test.sh
set -uo pipefail
HOOK="$(git rev-parse --show-toplevel)/hooks/dev-branch-guard.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Run the hook with JSON on stdin from the current cwd; echo deny/allow.
run() { printf '%s' "$1" | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow; }

# A fresh git repo on `main`, with .env gitignored and one committed file.
new_main() {
  local d; d=$(mktemp -d)
  git -c init.defaultBranch=main -C "$d" init -q
  git -C "$d" config user.email t@e >/dev/null; git -C "$d" config user.name t >/dev/null
  printf '.env\nscratch/\n' > "$d/.gitignore"
  printf 'clean\n' > "$d/tracked.sh"
  git -C "$d" add .gitignore tracked.sh; git -C "$d" commit -qm init >/dev/null
  printf '%s' "$d"
}
# Same, then switched onto a working branch.
new_branch() {
  local d; d=$(new_main); git -C "$d" checkout -q -b work; printf '%s' "$d"
}

M=$(new_main); trap 'rm -rf "$M"' EXIT; cd "$M"

# --- true-positives: real direct-trunk mutations are denied ---
j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"tracked.sh",content:"x"}}')
[ "$(run "$j")" = deny ] && pass "Write to tracked path on main denied" || die "Write on main not denied"

j=$(jq -nc '{tool_name:"Edit",tool_input:{file_path:"tracked.sh",new_string:"x"}}')
[ "$(run "$j")" = deny ] && pass "Edit on main denied" || die "Edit on main not denied"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "git commit on main denied" || die "git commit on main not denied"

# --- false-positive 1: gitignored-path Write on main is allowed ---
j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:".env",content:"SECRET=1"}}')
[ "$(run "$j")" = allow ] && pass "Write to gitignored .env on main allowed" || die "gitignored .env Write denied"

j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"scratch/note.md",content:"tmp"}}')
[ "$(run "$j")" = allow ] && pass "Write under gitignored dir on main allowed" || die "gitignored dir Write denied"

# --- false-positive 2: compound branch-create then commit is allowed ---
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git checkout -b feat/x && echo hi > f && git commit -am wip"}}')
[ "$(run "$j")" = allow ] && pass "checkout -b then commit allowed" || die "compound checkout -b && commit denied"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git switch -c feat/y && git commit -m wip"}}')
[ "$(run "$j")" = allow ] && pass "switch -c then commit allowed" || die "compound switch -c && commit denied"

# --- false-positive 3: cross-repo git -C targeting a branch is allowed ---
B=$(new_branch)
j=$(jq -nc --arg d "$B" '{tool_name:"Bash",tool_input:{command:("git -C " + $d + " commit -m x")}}')
[ "$(run "$j")" = allow ] && pass "git -C <branch-repo> commit allowed from main cwd" || die "cross-repo commit to branch denied"
rm -rf "$B"

# --- cross-repo correctness: git -C targeting main is denied from a branch cwd ---
BC=$(new_branch); cd "$BC"
j=$(jq -nc --arg d "$M" '{tool_name:"Bash",tool_input:{command:("git -C " + $d + " commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "git -C <main-repo> commit denied from branch cwd" || die "cross-repo commit to main not denied"
# and a plain commit from the branch cwd is allowed
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git commit -m x"}}')
[ "$(run "$j")" = allow ] && pass "plain commit on a branch allowed" || die "commit on branch denied"
cd "$M"; rm -rf "$BC"

# --- adversarial: commit-detection and compound bypasses (close review) ---
# git -c <config> commit on main must be denied (global option before commit).
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git -c user.email=x commit -m y"}}')
[ "$(run "$j")" = deny ] && pass "git -c <config> commit on main denied" || die "git -c ... commit bypassed"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git -c core.hooksPath=/dev/null commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "git -c hooksPath commit on main denied" || die "hooksPath bypass"

# checkout -b as text inside an echo must not exempt a real trunk commit.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"echo git checkout -b fake; git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "echo-text checkout -b does not exempt commit" || die "echo-text compound bypass"

# Creating a trunk-named branch is not a valid off-trunk escape.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git checkout -b master && git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "checkout -b master then commit denied" || die "trunk-named branch exempted"

# Multiple git -C: the commit's own target repo (main) is judged, not the first -C.
B2=$(new_branch)
j=$(jq -nc --arg b "$B2" --arg m "$M" '{tool_name:"Bash",tool_input:{command:("git -C " + $b + " add . && git -C " + $m + " commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "multi -C judges the commit target repo" || die "multi -C judged wrong repo"
rm -rf "$B2"

# --- fail open ---
[ "$(printf 'not json{' | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow)" = allow ] \
  && pass "malformed input fails open" || die "malformed input did not fail open"

# outside any git repo -> allow
OUT=$(mktemp -d); ( cd "$OUT"
  j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"a",content:"x"}}')
  printf '%s' "$j" | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow
) | grep -q allow && pass "outside a repo fails open" || die "outside a repo did not fail open"
rm -rf "$OUT"

(( fail == 0 )) && echo "dev-branch-guard.test: OK"
exit $fail
