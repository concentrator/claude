#!/usr/bin/env bash
# Tests scripts/preflight-permissions.sh (R080-T007): the declared permission
# set resolves against the three settings tiers, every report line names the
# tier that satisfied its rule, the carve-out pattern is read off the tiers'
# working-tree files with no git state in the answer, and --apply closes an
# allow gap in the local tier and never a deny one.
# Run: bash scripts/test/preflight-permissions.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
# Host git config must not leak into fixtures (the script resolves the
# default branch; NOSYSTEM for Apple git's vendor config).
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
ROOT=$(git rev-parse --show-toplevel)
SCRIPT="$ROOT/scripts/preflight-permissions.sh"
TPL="$ROOT/skills/dev/companions/auto-permissions.template.json"
PAIR='["Bash(git push origin main:*)","Bash(git push --force:*)"]'
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
# Physical path: the script canonicalizes --project, and $TMPDIR is a symlink
# on macOS, so an unresolved fixture path would miss every trust lookup.
W=$(cd "$(mktemp -d)" && pwd -P)
trap 'chmod -R u+w "$W" 2>/dev/null; rm -rf "$W"' EXIT
n=0

# A fresh fixture: a git-initialised project with a toolchain section, a
# trusted workspace and an empty user tier. Sets FIX, PROJ, PT, LT. $1 names
# the project directory, for a case that needs a particular path.
newfix() {
  n=$((n + 1)); FIX="$W/$n"; PROJ="$FIX/${1:-proj}"
  PT="$PROJ/.claude/settings.json"; LT="$PROJ/.claude/settings.local.json"
  mkdir -p "$PROJ/.claude"
  git -c init.defaultBranch=main -C "$PROJ" init -q
  git -C "$PROJ" symbolic-ref refs/remotes/origin/HEAD refs/remotes/origin/main
  git -C "$PROJ" config user.email t@e; git -C "$PROJ" config user.name t
  printf '## Agent toolchain\n\nThis project overrides `## Agent toolchain`.\n\n' > "$PROJ/CLAUDE.md"
  printf -- '- Test (fast): `bash t.sh`\n' >> "$PROJ/CLAUDE.md"
  printf -- '- VCS host: GitHub, CLI `gh`\n' >> "$PROJ/CLAUDE.md"
  printf -- '- State-check: `gh pr view <n> --json state`\n' >> "$PROJ/CLAUDE.md"
  printf -- '\n## Next\n\n- not read: `never run me`\n' >> "$PROJ/CLAUDE.md"
  trust true
  printf '{}\n' > "$FIX/user.json"
}
trust() { printf '{"projects":{"%s":{"hasTrustDialogAccepted":%s}}}\n' "$PROJ" "$1" > "$FIX/claude.json"; }

# A tier satisfying the whole declared set: the template's rules with the
# placeholders substituted, the fixture's two toolchain prefixes, pattern 1's
# checkpoint-push block - no template entry of its own, the template being
# pattern 2's starting point - and $2 as the deny set.
sat() {
  jq --arg p "${PROJ#/}" --arg h "${FIX#/}" --argjson d "$2" \
    '{permissions: {allow: ([.permissions.allow[]
       | gsub("__PROJECT_DIR__"; $p) | gsub("__HOME__"; $h)]
       + ["Bash(bash t.sh:*)", "Bash(gh pr view:*)"]
       + (["batch", "doc", "feat", "fix", "refactor", "mnt", "test", "plan"]
          | map("Bash(git push -u origin " + . + "/*)"))), deny: $d}}' "$TPL" > "$1"
}
# In-place jq edit of a tier.
edit() { local f=$1; shift; jq "$@" "$f" > "$f.new" && mv "$f.new" "$f"; }

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
rcn()  { [ "$RC" -ne 0 ] && pass "$1" || die "$1 - exited zero"; }

# --- 1. an untrusted workspace stops before anything is resolved ---
newfix; sat "$PT" "$PAIR"; trust false
runp --supervisor AI --runner-mode auto
rcn "untrusted workspace is cannot-apply"
want "cannot apply" "untrusted names the verdict"
want "workspace trust" "untrusted names the check"
nowant "present (" "untrusted resolves no rule"
[ ! -f "$LT" ] && pass "untrusted writes nothing" || die "untrusted wrote a tier"

# --- 2. a full set exits zero with every line naming its tier ---
newfix; sat "$PT" "$PAIR"
runp --supervisor human --runner-mode default
rc0 "a full set exits zero"
want "present (project) Edit(//${PROJ#/}/**)" "the Edit rule names its tier"
want "present (project) Bash(bash t.sh:*)" "a toolchain prefix is declared"
want "present (project) Bash(gh pr view:*)" "the State-check prefix is declared"
want "present (project) Bash(git push -u origin batch/*)" "pattern 1 declares the checkpoint push"
nowant "never run me" "a span outside the toolchain section is not read"
nowant "Bash(## Agent toolchain:*)" "a span in the section's prose is not a command"
nowant "Bash(gh:*)" "a one-word span is a CLI name, not a prefix"
nowant "missing" "a full set reports no gap"

# --- 2b. a project path carrying `&` resolves to the path itself ---
newfix 'a&b'; sat "$PT" "$PAIR"
runp --supervisor human --runner-mode default --apply
rc0 "a project path carrying & exits zero"
want "present (project) Edit(//${PROJ#/}/**)" "the Edit rule spells the fixture's own path"
nowant "__PROJECT_DIR__" "no placeholder survives the substitution"
[ ! -f "$LT" ] && pass "an & path opens no gap to apply" || die "an & path was applied around"
runp --supervisor human --runner-mode default
rc0 "a re-run on an & path exits zero"

# --- 3/4. a missing allow rule is reported, applied, and reads back ---
newfix; sat "$PT" "$PAIR"; edit "$PT" 'del(.permissions.allow[] | select(. == "WebSearch"))'
printf '{"model":"x","permissions":{"allow":["Bash(foo:*)"]}}\n' > "$LT"
runp --supervisor human --runner-mode default
rcn "a missing allow rule stops the run"
want "missing WebSearch" "a missing rule is reported"
want "--apply" "the missing-allow remedy is the --apply line"
runp --supervisor human --runner-mode default --apply
rc0 "--apply exits zero"
want "applied (local) WebSearch" "--apply reports the write"
[ "$(jq -r '.model' "$LT")" = x ] && pass "--apply keeps the tier's other keys" || die "--apply lost a key"
jq -e '.permissions.allow | index("Bash(foo:*)") and index("WebSearch")' "$LT" >/dev/null \
  && pass "--apply merges into the local allow" || die "--apply did not merge"
runp --supervisor human --runner-mode default
rc0 "a re-run after --apply exits zero"
want "present (local) WebSearch" "the applied rule reads back from the local tier"

# --- 5. a broader tier rule covers a declared child path ---
newfix; sat "$PT" "$PAIR"
edit "$PT" --arg e "Edit(//${PROJ#/}/**)" --arg b "Edit(//${W#/}/**)" \
  '.permissions.allow |= map(if . == $e then $b else . end)'
runp --supervisor human --runner-mode default --apply
rc0 "a broader rule covers the declared child path"
want "present (project) Edit(//${PROJ#/}/**)" "the covered rule names the covering tier"
[ ! -f "$LT" ] && pass "a covered rule is not rewritten" || die "a covered rule was applied"

# --- 6. the Bash prefix set binds under human alone, checkpoint push included ---
newfix; sat "$PT" "$PAIR"
edit "$PT" 'del(.permissions.allow[] | select(startswith("Bash(git push -u origin")))'
runp --supervisor human --runner-mode default
rcn "an absent checkpoint-push string stops a human-supervised run"
want "missing Bash(git push -u origin batch/*)" "an absent push string is missing under human"
want "--apply" "the missing push string takes the --apply remedy"
runp --supervisor AI --runner-mode auto
rc0 "an absent push string does not stop an AI-supervised run"
want "inert (auto) Bash(git push -u origin batch/*)" "an absent push string is inert under AI"
edit "$PT" 'del(.permissions.allow[] | select(. == "Bash(git log:*)"))'
runp --supervisor AI --runner-mode auto
rc0 "an absent Bash prefix does not stop an AI-supervised run"
want "inert (auto) Bash(git log:*)" "an absent prefix is inert under AI"
want "present (project) Bash(git status:*)" "a carried prefix names its tier under AI"
runp --supervisor human --runner-mode default
rcn "the same prefix stops a human-supervised run"
want "missing Bash(git log:*)" "an absent prefix is missing under human"
runp --supervisor human --runner-mode default --apply
rc0 "--apply closes a Bash gap under human"
jq -e '.permissions.allow | index("Bash(git log:*)")' "$LT" >/dev/null \
  && pass "--apply creates the local tier when it is absent" || die "--apply wrote no local tier"

# --- 6b. a tier deny bars a declared allow rule it swallows ---
newfix; sat "$PT" '["Bash(git push origin main:*)","Bash(git push --force:*)","Bash(git:*)"]'
runp --supervisor human --runner-mode default
rcn "a broad tier deny over a declared allow rule is cannot-apply"
want "cannot apply: the project tier's deny reaches it Bash(git log:*)" "the denied rule is named"
edit "$PT" '.permissions.deny = ["Bash(git push origin main:*)", "Bash(git push --force:*)",
  "Bash(git log --oneline:*)"]'
runp --supervisor human --runner-mode default
rc0 "a deny narrower than a declared rule is a narrowing, not a conflict"

# --- 7. pattern 2 is the human-supervised path ---
newfix; sat "$PT" '["Bash(git push:*)"]'
runp --supervisor human --runner-mode default
rc0 "pattern 2 is accepted under human"
want "present (project) Bash(git push:*)" "pattern 2's entry names its tier"
nowant "Bash(git push origin main:*)" "pattern 2 declares no pattern-1 string"
nowant "Bash(git push -u origin" "pattern 2 declares no checkpoint-push rule"
runp --supervisor AI --runner-mode auto
rcn "pattern 2 is cannot-apply under AI"
want "pattern 2" "the pattern-2 verdict names the pattern"

# --- 8/9. pattern 1's pair, and a union carrying neither pattern ---
newfix; sat "$PT" "$PAIR"
runp --supervisor AI --runner-mode auto
rc0 "the narrow pair satisfies the declared deny"
want "present (project) Bash(git push --force:*)" "each pair entry names its tier"
nowant "Bash(git push:*)" "the pair is not reported as missing the blanket rule"
newfix; sat "$PT" '[]'
runp --supervisor AI --runner-mode auto --apply
rcn "a union carrying neither pattern is the missing-deny gap"
want "missing Bash(git push origin main:*)" "the missing deny string is printed"
want "$PT" "the missing-deny remedy names the tracked project tier"
[ ! -f "$LT" ] && pass "--apply writes no deny" || die "--apply wrote a tier for a deny gap"

# --- 10. the shape a provisioned worker arrives in ---
newfix; sat "$LT" "$PAIR"
runp --supervisor AI --runner-mode auto
rc0 "a seeded local tier passes the gate"
want "present (local) Bash(git push origin main:*)" "the seeded pair reads present (local)"

# --- 11. the working-tree file decides, never the committed one ---
newfix; sat "$PT" '[]'
git -C "$PROJ" add -A >/dev/null; git -C "$PROJ" commit -q -m init
edit "$PT" --argjson d "$PAIR" '.permissions.deny = $d'
runp --supervisor AI --runner-mode auto
rc0 "an uncommitted deny satisfies the declared set"
want "present (project) Bash(git push --force:*)" "the working-tree deny is what is read"

# --- 12. a tier staged and never committed has no tracked value ---
newfix; sat "$PT" "$PAIR"; edit "$PT" '.permissions.defaultMode = "acceptEdits"'
git -C "$PROJ" add -A >/dev/null
runp --supervisor AI --runner-mode auto
rc0 "a staged, never-committed tier passes"
want "untracked mode key (project): acceptEdits" "its mode key prints untracked with its value"

# --- 13/14. the tiers can disagree, and the first tier wins ---
newfix; sat "$PT" "$PAIR"
printf '{"permissions":{"deny":["Bash(git push:*)"]}}\n' > "$FIX/user.json"
runp --supervisor human --runner-mode default
rc0 "a user-tier blanket deny is pattern 2 under human"
want "present (user) Bash(git push:*)" "pattern 2 is satisfied from the user tier"
runp --supervisor AI --runner-mode auto
rcn "the same tiers are cannot-apply under AI"
newfix; sat "$PT" "$PAIR"; sat "$FIX/user.json" '[]'
runp --supervisor human --runner-mode default
want "present (user) WebSearch" "a rule two tiers carry names the first"
[ "$(printf '%s\n' "$OUT" | grep -cF ' WebSearch')" -eq 1 ] \
  && pass "a rule two tiers carry is one line" || die "a rule two tiers carry printed twice"

# --- 15. an unstated launch mode fails the assertion under AI alone ---
newfix; sat "$PT" "$PAIR"
runp --supervisor AI --runner-mode unknown
rcn "an unknown launch mode is cannot-apply under AI"
want "permission mode" "the failed assertion names the permission mode"
runp --supervisor human --runner-mode unknown
rc0 "an unknown launch mode is ignored under human"

# --- 16/17. the mode key: drift is a defect, the never-list is absolute ---
newfix; sat "$PT" "$PAIR"; edit "$PT" '.permissions.defaultMode = "acceptEdits"'
git -C "$PROJ" add -A >/dev/null; git -C "$PROJ" commit -q -m init
edit "$PT" '.permissions.defaultMode = "default"'
runp --supervisor AI --runner-mode auto
rcn "a mode key drifted from its tracked value is cannot-apply"
want "drifted" "the drift verdict is named"
edit "$PT" '.permissions.defaultMode = "bypassPermissions"'
runp --supervisor AI --runner-mode auto
rcn "bypassPermissions in a tier is cannot-apply"
want "bypassPermissions" "the never-list verdict names the mode"

# --- 18. the tier --apply writes to must be writable ---
newfix; sat "$PT" "$PAIR"
chmod a-w "$PROJ/.claude"
if [ -w "$PROJ/.claude" ]; then
  pass "an unwritable local tier is cannot-apply (skipped: running as root)"
else
  runp --supervisor AI --runner-mode auto
  rcn "an unwritable local tier is cannot-apply"
  want "writable" "the unwritable tier is named"
fi
chmod u+w "$PROJ/.claude"

(( fail == 0 )) && echo "preflight-permissions.test: ALL OK"
exit $fail
