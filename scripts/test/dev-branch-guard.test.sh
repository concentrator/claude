#!/usr/bin/env bash
# Tests hooks/dev-branch-guard.sh - the PreToolUse trunk guard. Covers the
# true-positives (a Write and a `git commit` on main are denied), the three
# false-positives R-024/T-058 fixes (a gitignored-path Write on main, a
# compound `checkout -b && commit`, and a cross-repo `git -C <branch> commit`
# are all allowed), the foreign-path case R-034 fixes (a repo-less target is
# allowed), the target-owner judgment R-036 adds (tracked-on-trunk targets
# deny from any cwd; dot-dot / symlink / nested-init shapes; ignored and
# branch-repo targets allow), the cross-repo correctness case
# (`git -C <main>` from a branch cwd is denied), and fail-open on malformed
# input / outside a repo.
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

# --- false-positive 4 (R-034): a path outside the cwd repo is allowed ---
# A foreign path cannot land on this repo's trunk; check-ignore exits 128
# ("outside repository") there, which must not fall through to the deny.
F=$(mktemp -d)
j=$(jq -nc --arg p "$F/outside.md" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = allow ] && pass "Write to a path outside the repo on main allowed" || die "foreign-path Write denied"
rm -rf "$F"

# In-repo paths check-ignore reports as 128 must still deny: a write through
# a tracked-symlinked dir or a ../ re-entry lands on this trunk. A symlink
# pointing outside the repo does not, and stays allowed.
mkdir -p realdir; ln -s realdir linkdir
j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"linkdir/f.md",content:"x"}}')
[ "$(run "$j")" = deny ] && pass "Write via in-repo symlinked dir on main denied" || die "symlinked-dir Write allowed"

j=$(jq -nc --arg p "../$(basename "$M")/tracked.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = deny ] && pass "Write via ../ re-entry on main denied" || die "dot-dot re-entry Write allowed"

OUTD=$(mktemp -d)
ln -s "$OUTD" outlink
j=$(jq -nc '{tool_name:"Write",tool_input:{file_path:"outlink/f.md",content:"x"}}')
[ "$(run "$j")" = allow ] && pass "Write via symlink pointing outside allowed" || die "outward-symlink Write denied"
rm -rf "$OUTD"

# --- R-036: the target's owning repo is judged, not the session cwd ---
# From a cwd on a working branch, a tracked-side write into a second repo
# on main must deny; ignored-in-owner and owner-on-branch targets allow.
M2=$(new_main)
BC0=$(new_branch); cd "$BC0"
j=$(jq -nc --arg p "$M2/tracked.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = deny ] && pass "cross-repo write to tracked file on main denied" || die "cross-repo trunk write allowed"

j=$(jq -nc --arg p "$M2/.env" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = allow ] && pass "cross-repo write to ignored path allowed" || die "cross-repo ignored write denied"

B0=$(new_branch)
j=$(jq -nc --arg p "$B0/tracked.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = allow ] && pass "cross-repo write to branch repo allowed" || die "cross-repo branch write denied"

# Close-review pins: dot-dot through a missing segment, cwd-independence,
# .git internals, an unborn nested init, and a file symlink pointing out.
j=$(jq -nc --arg p "$M2/ghost/../tracked.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = deny ] && pass "dot-dot through missing segment denied" || die "ghost/.. write allowed"

j=$(jq -nc --arg p "$M2/tracked.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
v1=$(run "$j"); cd "$M"; v2=$(run "$j")
[ "$v1" = "$v2" ] && [ "$v1" = deny ] && pass "same verdict from any cwd" || die "verdict depends on cwd ($v1 vs $v2)"

j=$(jq -nc --arg p "$M2/.git/info/exclude" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = allow ] && pass "write inside .git allowed" || die ".git-internal write denied"

git -c init.defaultBranch=main -C "$M2" init -q vendor
j=$(jq -nc --arg p "$M2/vendor/newfile" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = deny ] && pass "unborn nested init still guarded by outer" || die "nested git init disabled the guard"

OUTF=$(mktemp -d); ln -s "$OUTF/note.md" "$M2/outfile"
j=$(jq -nc --arg p "$M2/outfile" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = allow ] && pass "file symlink pointing outside allowed" || die "outward file symlink denied"
rm -rf "$OUTF"
cd "$M"; rm -rf "$M2" "$BC0" "$B0"

# --- false-positive 2: compound branch-create then commit is allowed ---
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git checkout -b feat/x && echo hi > f && git commit -am wip"}}')
[ "$(run "$j")" = allow ] && pass "checkout -b then commit allowed" || die "compound checkout -b && commit denied"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git switch -c feat/y && git commit -m wip"}}')
[ "$(run "$j")" = allow ] && pass "switch -c then commit allowed" || die "compound switch -c && commit denied"

# Flags between checkout/switch and -b/-c must not defeat the branch-create.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git checkout -q -b feat/z && git commit -m wip"}}')
[ "$(run "$j")" = allow ] && pass "checkout -q -b then commit allowed" || die "flags before -b defeated the compound detection"

# Global options before checkout must not defeat the branch-create (R-037).
M3=$(new_main)
j=$(jq -nc --arg d "$M3" '{tool_name:"Bash",tool_input:{command:("git -C " + $d + " checkout -b feat/cc && git -C " + $d + " commit -m x")}}')
[ "$(run "$j")" = allow ] && pass "git -C checkout -b then -C commit allowed" || die "-C before checkout defeated the exemption"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git -c core.editor=vi checkout -b feat/cv && git commit -m x"}}')
[ "$(run "$j")" = allow ] && pass "git -c opt checkout -b then commit allowed" || die "-c before checkout defeated the exemption"

j=$(jq -nc --arg d "$M3" '{tool_name:"Bash",tool_input:{command:("git -C " + $d + " checkout -b master && git -C " + $d + " commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "-C checkout -b master then commit denied" || die "-C trunk-named branch exempted"
rm -rf "$M3"

# Newline-separated commands: a checkout -b on a later line is still a head.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"echo start\ngit checkout -b feat/nl\ngit commit -m wip"}}')
[ "$(run "$j")" = allow ] && pass "newline-separated checkout -b then commit allowed" || die "newline before checkout -b defeated the compound detection"

# ...but a checkout -b that is echo text (not a command head) still denies,
# even across a newline.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"echo git checkout -b fake\ngit commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "newline echo-text checkout -b still denies" || die "newline echo-text bypass"

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
