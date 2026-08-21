#!/usr/bin/env bash
# Tests hooks/dev-branch-guard.sh - the PreToolUse trunk guard. Covers the
# true-positives (a Write and a `git commit` on main are denied), the three
# false-positives R-024/T-058 fixes (a gitignored-path Write on main, a
# compound `checkout -b && commit`, and a cross-repo `git -C <branch> commit`
# are all allowed), the foreign-path case R-034 fixes (a repo-less target is
# allowed), the target-owner judgment R-036 adds (tracked-on-trunk targets
# deny from any cwd; dot-dot / symlink / nested-init shapes; ignored and
# branch-repo targets allow), the cross-repo correctness case
# (`git -C <main>` from a branch cwd is denied), the commit-target cases
# R-052 adds (an in-command `cd` moves the judged repo; a same-command
# `git init` marks non-project work; unresolvable cd targets fail open),
# the trunk-resolution cases R-058 adds (a develop trunk resolved via
# origin/HEAD denies; unresolvable repos fall back to the literals),
# and fail-open on malformed input / outside a repo.
# Run: bash scripts/test/dev-branch-guard.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# The guard resolves init.defaultBranch, so host git config must not leak
# into fixtures: unconfigured repos here exercise the literal fallback.
# NOSYSTEM, not GIT_CONFIG_SYSTEM=/dev/null - Apple git reads its vendor
# gitconfig (init.defaultBranch=main) even with the latter set.
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
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
# A repo whose trunk is `develop`, resolvable via origin/HEAD (R-058).
new_develop() {
  local d; d=$(mktemp -d)
  git -c init.defaultBranch=develop -C "$d" init -q
  git -C "$d" config user.email t@e >/dev/null; git -C "$d" config user.name t >/dev/null
  printf 'clean\n' > "$d/tracked.sh"
  git -C "$d" add tracked.sh; git -C "$d" commit -qm init >/dev/null
  git -C "$d" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/develop
  printf '%s' "$d"
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

# Close-review pins: the exemption is tied to the commit's repo, and a
# quoted option value cannot fake a branch-create.
M5=$(new_main)
j=$(jq -nc --arg a "$M3" --arg b "$M5" '{tool_name:"Bash",tool_input:{command:("git -C " + $a + " checkout -b feat/x && git -C " + $b + " commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "cross-repo checkout does not exempt commit" || die "cross-repo exemption leak"

j=$(jq -nc --arg b "$M5" '{tool_name:"Bash",tool_input:{command:("git checkout -b feat/y && git -C " + $b + " commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "cwd checkout does not exempt cross-repo commit" || die "cwd exemption covered a foreign commit"

j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"git -c foo.bar=\"git checkout -b evil\" status; git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "quoted option text does not exempt" || die "quoted checkout -b faked the exemption"
rm -rf "$M3" "$M5"

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

# --- R-052: the commit is judged where an in-command cd lands it, and a
# repo created by the same command is not project work ---
# Same-command `git init` allows: the fixture's runtime path is invisible
# to the hook, so the created-here signal is the only readable one.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"t=$(mktemp -d) && cd \"$t\" && git init -q . && git commit -q --allow-empty -m init"}}')
[ "$(run "$j")" = allow ] && pass "same-command git init then commit allowed" || die "created-here fixture commit denied"

# echo text naming git init is not a created-here signal.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"echo git init; git commit -m x"}}')
[ "$(run "$j")" = deny ] && pass "echo-text git init does not exempt" || die "echo-text init bypass"

# cd into a branch repo: the commit is judged there, not at the cwd.
B4=$(new_branch); M6=$(new_main)
j=$(jq -nc --arg d "$B4" '{tool_name:"Bash",tool_input:{command:("cd " + $d + " && git commit -m x")}}')
[ "$(run "$j")" = allow ] && pass "cd <branch-repo> then commit allowed from main cwd" || die "cd-target branch commit denied"

# cd into a main repo from a branch cwd: trunk is denied from any cwd.
BC2=$(new_branch); cd "$BC2"
j=$(jq -nc --arg d "$M6" '{tool_name:"Bash",tool_input:{command:("cd " + $d + " && git commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "cd <main-repo> then commit denied from branch cwd" || die "cd-target trunk commit allowed"
cd "$M"; rm -rf "$BC2"

# The last cd outranks an earlier git -C.
j=$(jq -nc --arg b "$B4" --arg m "$M6" '{tool_name:"Bash",tool_input:{command:("git -C " + $b + " add . ; cd " + $m + " ; git commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "last cd outranks an earlier -C" || die "stale -C judged instead of the cd target"

# cd then checkout -b then commit: the branch-create covers the commit.
j=$(jq -nc --arg m "$M6" '{tool_name:"Bash",tool_input:{command:("cd " + $m + "\ngit checkout -b plan/x 2>&1 | tail -1\ngit commit -q -m y")}}')
[ "$(run "$j")" = allow ] && pass "cd then checkout -b then commit allowed" || die "cd compound branch-create denied"

# A cd target the call text cannot resolve fails open.
j=$(jq -nc '{tool_name:"Bash",tool_input:{command:"cd \"$t\" && git commit -m x"}}')
[ "$(run "$j")" = allow ] && pass "unresolvable cd target fails open" || die "variable cd target denied"

# echo text naming cd does not move the target.
j=$(jq -nc --arg d "$B4" '{tool_name:"Bash",tool_input:{command:("echo cd " + $d + "; git commit -m x")}}')
[ "$(run "$j")" = deny ] && pass "echo-text cd does not move the target" || die "echo-text cd bypass"
rm -rf "$B4" "$M6"

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

# --- R-058: the trunk is the repo's resolved default branch ---
D=$(new_develop)
j=$(jq -nc --arg p "$D/tracked.sh" '{tool_name:"Write",tool_input:{file_path:$p,content:"x"}}')
[ "$(run "$j")" = deny ] && pass "write on a develop trunk denied via origin/HEAD" || die "develop trunk write allowed"

# With the default resolved to develop, `main` is an ordinary branch there.
git -C "$D" checkout -q -b main
[ "$(run "$j")" = allow ] && pass "main is a working branch when the default is develop" || die "literal main denied despite a resolved develop default"
git -C "$D" checkout -q develop

# Resolution removed: the literal fallback no longer matches develop.
git -C "$D" symbolic-ref --delete refs/remotes/origin/HEAD
[ "$(run "$j")" = allow ] && pass "unresolvable default falls back to the literals" || die "literal fallback still denied a develop trunk"
rm -rf "$D"

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
