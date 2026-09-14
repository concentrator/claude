#!/usr/bin/env bash
# Tests hooks/dev-branch-guard.sh HEAD-move and discard rules (R080-T007):
# an entry into a dirty repo's default branch and a branch created under
# that name are denied; an irrecoverable `reset`/`stash` discard is denied
# while the recoverable spellings pass; a whole-tree `checkout`/`restore`
# pathspec is denied in every spelling while named paths pass. Companion of
# dev-branch-guard.test.sh, split out under the code-size cap; helpers and
# fixtures mirror it.
# Run: bash scripts/test/dev-head-guard.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Host git config must not leak into fixtures (the guard resolves
# init.defaultBranch; NOSYSTEM for Apple git's vendor config).
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
HOOK="$(git rev-parse --show-toplevel)/hooks/dev-branch-guard.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# Run the hook with JSON on stdin from the current cwd; echo deny/allow.
run() { printf '%s' "$1" | bash "$HOOK" 2>/dev/null | grep -q '"permissionDecision":"deny"' && echo deny || echo allow; }
# Build the tool call for a command string.
call() { jq -nc --arg c "$1" '{tool_name:"Bash",tool_input:{command:$c}}'; }

# A fixture repo on `main` with a subdirectory and a committed file.
M=$(mktemp -d); trap 'rm -rf "$M"' EXIT
git -c init.defaultBranch=main -C "$M" init -q
git -C "$M" config user.email t@e >/dev/null; git -C "$M" config user.name t >/dev/null
mkdir -p "$M/docs"; echo x > "$M/docs/x.md"
git -C "$M" add -A >/dev/null; git -C "$M" commit -q -m init
git -C "$M" switch -q -c feat/x
cd "$M"

# --- irrecoverable discards (no repo is resolved for these) ---
for c in "git reset --hard" "git reset --keep" "git reset --merge HEAD~1" \
         "git stash drop" "git stash clear"; do
  [ "$(run "$(call "$c")")" = deny ] && pass "$c denied" || die "$c allowed"
done

for c in "git reset" "git reset --soft HEAD~1" "git reset --mixed" "git stash" \
         "git stash push -m x" "git stash pop" "git stash apply" "git stash list"; do
  [ "$(run "$(call "$c")")" = allow ] && pass "$c allowed" || die "$c denied"
done

# `drop` is only a discard as the word after `stash`.
[ "$(run "$(call "git stash push -m drop")")" = allow ] \
  && pass "stash push -m drop allowed" || die "stash push -m drop denied"

# --- entering the default branch ---
# Clean tree: the entry loses nothing.
[ "$(run "$(call "git checkout main")")" = allow ] \
  && pass "entry from a clean tree allowed" || die "clean-tree entry denied"

echo dirt >> "$M/docs/x.md"
[ "$(run "$(call "git checkout main")")" = deny ] \
  && pass "entry with a dirty tree denied" || die "dirty-tree entry allowed"
[ "$(run "$(call "git switch main")")" = deny ] \
  && pass "switch entry with a dirty tree denied" || die "dirty-tree switch allowed"

# The repo is the one the segment targets, resolved by -C and by a leading cd.
cd "$(dirname "$M")"
[ "$(run "$(call "git -C $M checkout main")")" = deny ] \
  && pass "entry judged through -C denied" || die "-C entry allowed"
[ "$(run "$(call "cd $M && git checkout main")")" = deny ] \
  && pass "entry judged through a leading cd denied" || die "cd entry allowed"
cd "$M"

# An untracked-only tree is not dirty work the entry carries.
git -C "$M" checkout -q -- docs/x.md
echo new > "$M/untracked.txt"
[ "$(run "$(call "git checkout main")")" = allow ] \
  && pass "untracked-only tree allows the entry" || die "untracked-only entry denied"
rm -f "$M/untracked.txt"

# --- creating a branch named as the default branch ---
[ "$(run "$(call "git switch -c feat/y")")" = allow ] \
  && pass "switch -c feat/y allowed" || die "switch -c feat/y denied"
[ "$(run "$(call "git checkout -b main")")" = deny ] \
  && pass "checkout -b main denied" || die "checkout -b main allowed"
[ "$(run "$(call "git switch -C main")")" = deny ] \
  && pass "switch -C main denied" || die "switch -C main allowed"
# A create is judged by its new name alone, never by the tree.
echo dirt >> "$M/docs/x.md"
[ "$(run "$(call "git checkout -B main")")" = deny ] \
  && pass "dirty checkout -B main denied by the create rule" || die "checkout -B main allowed"
git -C "$M" checkout -q -- docs/x.md

# --- whole-tree restores ---
for c in "git checkout -- ." "git checkout ." "git restore ." "git restore -- :/" \
         "git restore :/." "git checkout HEAD -- ."; do
  [ "$(run "$(call "$c")")" = deny ] && pass "$c denied" || die "$c allowed"
done

for c in "git checkout -- docs/x.md" "git restore docs/x.md README" \
         "git restore --staged docs/x.md" "git checkout HEAD -- docs/x.md"; do
  [ "$(run "$(call "$c")")" = allow ] && pass "$c allowed" || die "$c denied"
done

# `.` is refused whatever directory the segment runs from - the literal
# stage resolves nothing.
[ "$(run "$(call "cd $M/docs && git checkout -- .")")" = deny ] \
  && pass "a subdirectory '.' denied" || die "subdirectory '.' allowed"

# The physical comparison's own pair: the repo top denies, a subdirectory
# does not. mktemp's path is a symlink on macOS, so this also pins the
# physical resolution on both sides.
[ "$(run "$(call "git restore -- $M")")" = deny ] \
  && pass "an absolute repo top denied" || die "absolute repo top allowed"
[ "$(run "$(call "git restore -- $M/docs")")" = allow ] \
  && pass "an absolute subdirectory allowed" || die "absolute subdirectory denied"

# --- the verbs the declared set keeps ---
# The halt revert's own command (run.md § Question resolution).
[ "$(run "$(call "git read-tree --reset -u HEAD")")" = allow ] \
  && pass "git read-tree allowed" || die "git read-tree denied"

# echo text is not a command.
[ "$(run "$(call "echo git checkout main")")" = allow ] \
  && pass "echo-text checkout does not trigger" || die "echo-text checkout denied"
[ "$(run "$(call "echo git reset --hard")")" = allow ] \
  && pass "echo-text reset --hard does not trigger" || die "echo-text reset denied"

# A repo-less cwd resolves no target: the entry and restore rules pass.
cd "$(dirname "$M")"
[ "$(run "$(call "git checkout main")")" = allow ] \
  && pass "no owning repo allows" || die "repo-less cwd denied"

(( fail == 0 )) && echo "dev-head-guard.test: OK"
exit $fail
