#!/usr/bin/env bash
# Tests how scripts/preflight-permissions.sh reads CLAUDE.md § Agent toolchain:
# the section is read from the root CLAUDE.md and .claude/CLAUDE.md, ends with
# its file, and each declared command - the CI wait among them - becomes a Bash
# prefix rule resolved against the tiers.
# Run: bash scripts/test/preflight-permissions-toolchain.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)
SCRIPT="$ROOT/scripts/preflight-permissions.sh"
TPL="$ROOT/skills/dev/companions/auto-permissions.template.json"
[ -f "$SCRIPT" ] || { echo "not ok - $SCRIPT not found"; exit 1; }
[ -f "$TPL" ] || { echo "not ok - $TPL not found"; exit 1; }
PAIR='["Bash(git push origin main:*)","Bash(git push --force:*)"]'
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
# Physical path: the script canonicalizes --project, and $TMPDIR is a symlink
# on macOS, so an unresolved fixture path would miss every trust lookup.
W=$(cd "$(mktemp -d)" && pwd -P)
trap 'rm -rf "$W"' EXIT
n=0

# A fresh fixture: a git-initialised project with a toolchain section, a
# trusted workspace and an empty user tier. Sets FIX, PROJ, PT.
newfix() {
  n=$((n + 1)); FIX="$W/$n"; PROJ="$FIX/proj"; PT="$PROJ/.claude/settings.json"
  mkdir -p "$PROJ/.claude"
  git -c init.defaultBranch=main -C "$PROJ" init -q
  git -C "$PROJ" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
  printf '## Agent toolchain\n\n- Test (fast): `bash t.sh`\n' > "$PROJ/CLAUDE.md"
  printf -- '\n## Next\n\n- not read: `never run me`\n' >> "$PROJ/CLAUDE.md"
  printf '{"projects":{"%s":{"hasTrustDialogAccepted":true}}}\n' "$PROJ" > "$FIX/claude.json"
  printf '{}\n' > "$FIX/user.json"
}

# A tier satisfying the template's rules, the fixture's toolchain prefix and
# pattern 1's checkpoint-push block, with $2 as the deny set.
sat() {
  jq --arg p "${PROJ#/}" --arg h "${FIX#/}" --argjson d "$2" \
    '{permissions: {allow: ([.permissions.allow[]
       | gsub("__PROJECT_DIR__"; $p) | gsub("__HOME__"; $h)]
       + ["Bash(bash t.sh:*)"]
       + (["batch", "doc", "feat", "fix", "refactor", "mnt", "test", "plan"]
          | map("Bash(git push -u origin " + . + "/*)"))), deny: $d}}' "$TPL" > "$1"
}

runp() {
  OUT=$(HOME="$FIX" PREFLIGHT_USER_SETTINGS="$FIX/user.json" \
        PREFLIGHT_CLAUDE_JSON="$FIX/claude.json" \
        bash "$SCRIPT" --project "$PROJ" "$@" 2>&1); RC=$?
}
# Report lines are column-padded; assertions read them space-collapsed.
has()  { printf '%s\n' "$OUT" | tr -s ' ' | grep -qF -- "$1"; }
want() { has "$1" && pass "$2" || die "$2 - no '$1' in: $OUT"; }
nowant() { has "$1" && die "$2 - unexpected '$1'" || pass "$2"; }
rc0()  { [ "$RC" -eq 0 ] && pass "$1" || die "$1 - rc $RC: $OUT"; }

newfix; mv "$PROJ/CLAUDE.md" "$PROJ/.claude/CLAUDE.md"; printf '# x\n' > "$PROJ/CLAUDE.md"
sat "$PT" "$PAIR"
runp --supervisor human --runner-mode default
rc0 "a toolchain declared in .claude/ exits zero"
want "present (project) Bash(bash t.sh:*)" "a toolchain prefix declared in .claude/ is read"
nowant "never run me" "a span outside the .claude/ toolchain section is not read"

newfix; printf '## Agent toolchain\n\n- Test: `make a`\n' > "$PROJ/CLAUDE.md"
printf -- '- Build: `make b`\n' > "$PROJ/.claude/CLAUDE.md"
sat "$PT" "$PAIR"
runp --supervisor human --runner-mode default
want "Bash(make a:*)" "the first file's toolchain section is read"
nowant "Bash(make b:*)" "the section ends with its file, not in the next one"

newfix; printf '## Agent toolchain\n\n- Test: `make a`\n' > "$PROJ/CLAUDE.md"
printf '## Agent toolchain\n\n- Merge: `gh pr merge <n> --merge`\n' > "$PROJ/.claude/CLAUDE.md"
runp --supervisor human --runner-mode default
want "Bash(make a:*)" "the root file's toolchain section is read"
want "Bash(gh pr merge:*)" "the .claude/ file's toolchain section is read too"

newfix; printf '## Agent toolchain\n\n- CI wait: `glab ci status --branch <branch> --wait`\n' > "$PROJ/CLAUDE.md"
sat "$PT" "$PAIR"
runp --supervisor human --runner-mode default
rc0 "a GitLab CI wait exits zero on the template's rules"
want "present (project) Bash(glab ci status --branch:*)" "the CI wait line is read with the other declared commands"

newfix; sat "$PT" "$PAIR"
edit_rm() { jq --arg r "$1" 'del(.permissions.allow[] | select(. == $r))' "$PT" > "$PT.new" && mv "$PT.new" "$PT"; }
runp --supervisor AI --runner-mode auto
rc0 "a declared toolchain command passes under auto"
want "present (project) Bash(bash t.sh:*)" "auto keeps a narrow toolchain prefix, so it is checked"
edit_rm "Bash(bash t.sh:*)"
runp --supervisor AI --runner-mode auto
[ "$RC" -ne 0 ] && pass "an absent toolchain prefix stops an AI-supervised run" \
  || die "an absent toolchain prefix passed under auto"
want "missing Bash(bash t.sh:*)" "the absent toolchain prefix is reported missing"

(( fail == 0 )) && echo "preflight-permissions-toolchain.test: ALL OK"
exit $fail
