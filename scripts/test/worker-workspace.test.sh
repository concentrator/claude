#!/usr/bin/env bash
# Tests scripts/worker-workspace.sh - the worker's own $HOME: forge keys, CLI
# authentication and the config clone. Split from provision-worker.test.sh to
# mirror the script split, so each suite covers one execution surface.
# Run: bash scripts/test/worker-workspace.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
WSSCRIPT="$(git rev-parse --show-toplevel)/scripts/worker-workspace.sh"
# Credentials live in their own script - the surface a mistake leaks.
CRSCRIPT="$(git rev-parse --show-toplevel)/scripts/worker-credentials.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# --- keys: one per forge, generated on the VM --------------------------------

keys() { env PATH=/usr/bin:/bin "$@" bash "$CRSCRIPT" keys --dry-run 2>&1; }

# 19. dry run names both forges, the algorithm, and the config it writes
out=$(keys)
miss=""
for f in "ed25519" "github.com" "gl.wallarm.com" "~/.ssh/config" "no passphrase"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "keys dry run names both forges" || die "keys missing:$miss"

# 20. separate keys per forge - one key reused across both means revoking
#     access to either revokes both
grep -q 'id_ed25519_github' <<<"$out" && grep -q 'id_ed25519_gitlab' <<<"$out" \
  && pass "a distinct key per forge" || die "keys not separated: $out"

# 21. dry run writes nothing
h=$(mktemp -d)
env PATH=/usr/bin:/bin HOME="$h" bash "$CRSCRIPT" keys --dry-run >/dev/null 2>&1
[ ! -e "$h/.ssh" ] && pass "keys dry run writes nothing" || die "keys dry run wrote to ~/.ssh"
rm -rf "$h"

# --- forge CLIs: installed on the VM, authenticated from a gitignored .env ---

forge() { env PATH=/usr/bin:/bin "$@" bash "$CRSCRIPT" forge-cli --dry-run 2>&1; }

# 22. dry run names both CLIs and where the tokens come from
out=$(forge)
miss=""
for f in "glab" "gh" ".env" "GITLAB_TOKEN" "GITHUB_TOKEN"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "forge-cli names both CLIs and the token source" || die "forge missing:$miss"

# 23. a token value never appears in output - the script reads secrets but must
#     not echo them, since this output lands in transcripts and shell history
h=$(mktemp -d); mkdir -p "$h/.claude"
printf 'GITLAB_TOKEN=fixtureleakcanary\nGITHUB_TOKEN=fixtureleakcanary\n' > "$h/.claude/.env"
out=$(env PATH=/usr/bin:/bin HOME="$h" bash "$CRSCRIPT" forge-cli --dry-run 2>&1)
grep -q 'fixtureleakcanary' <<<"$out" && die "forge-cli echoed a token value" \
  || pass "token values never printed"

# 24. a missing GitHub token is reported, not fatal - a worker delivering only
#     GitLab work never needs one
printf 'GITLAB_TOKEN=fixtureleakcanary\n' > "$h/.claude/.env"
out=$(env PATH=/usr/bin:/bin HOME="$h" bash "$CRSCRIPT" forge-cli --dry-run 2>&1)
[ $? -eq 0 ] && grep -qi 'github' <<<"$out" \
  && pass "absent GitHub token reported, not fatal" || die "missing token mishandled: $out"

# 39. a declared-but-empty token reads as absent, not present. .env.example
#     ships GITHUB_TOKEN= for the operator to fill, so "the line exists" and
#     "there is a token" are different questions - and the real run answers the
#     second, which left the dry run promising an authentication it then skipped.
printf 'GITLAB_TOKEN=fixtureleakcanary\nGITHUB_TOKEN=\n' > "$h/.claude/.env"
out=$(env PATH=/usr/bin:/bin HOME="$h" bash "$CRSCRIPT" forge-cli --dry-run 2>&1)
grep -q 'GITHUB_TOKEN=no' <<<"$out" && pass "an empty token reads as absent" \
  || die "empty token reported present: $out"
grep -q 'GITLAB_TOKEN=yes' <<<"$out" && pass "a filled token still reads as present" \
  || die "filled token reported absent: $out"
rm -rf "$h"

# --- forge CLIs, the real run: a stub glab/gh on PATH records what is called --

# A host entry is what every repo-relative glab call resolves against, and the
# identity check does not need one - so a run that skips the login passes the
# check and leaves the worker unable to open its MR. The stub records argv and
# stdin so the test can see the login happen, and see where the token went.
stub=$(mktemp -d); h=$(mktemp -d); mkdir -p "$h/.claude"; : > "$h/.bashrc"
cat > "$stub/glab" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$GLAB_LOG"
case "$1 ${2:-}" in
  "auth login") cat > "$GLAB_STDIN" ;;
  "api user")   printf '{"username":"fixture"}\n' ;;
  "repo view")  exit "${GLAB_REPO_VIEW_RC:-0}" ;;
esac
STUB
cat > "$stub/gh" <<'STUB'
#!/usr/bin/env bash
[ "$1 ${2:-}" = "api user" ] && printf '{"login":"fixture"}\n'
exit 0
STUB
chmod +x "$stub/glab" "$stub/gh"
printf 'GIT_USER_NAME=Fixture\nGIT_USER_EMAIL=fixture@example.test\n' > "$h/.claude/.env"
printf 'GITLAB_HOST=gl.example.test\nGITLAB_TOKEN=fixtureleakcanary\n' >> "$h/.claude/.env"
real() {
  env PATH="$stub:/usr/bin:/bin" HOME="$h" GLAB_LOG="$stub/log" GLAB_STDIN="$stub/stdin" "$@" \
    bash "$CRSCRIPT" forge-cli ${CHECKOUT:+"$CHECKOUT"} 2>&1
}

# 40. the run logs in to the host from .env, and only then checks the identity
: > "$stub/log"; : > "$stub/stdin"
out=$(real)
login=$(grep -n '^auth login' "$stub/log")
[ -n "$login" ] && grep -q -- '--hostname gl.example.test' <<<"$login" \
  && grep -q -- '--stdin' <<<"$login" \
  && pass "forge-cli logs glab in to the .env host over stdin" \
  || die "no glab auth login --hostname <host> --stdin in: $(cat "$stub/log")"
check=$(grep -n '^api user' "$stub/log")
[ -n "$login" ] && [ -n "$check" ] && [ "${login%%:*}" -lt "${check%%:*}" ] \
  && pass "login precedes the identity check" || die "identity checked before login"

# 41. the token reaches the login on stdin and never argv - argv is visible to
#     every process on the host
grep -q 'fixtureleakcanary' "$stub/stdin" && ! grep -q 'fixtureleakcanary' "$stub/log" \
  && pass "token travels on stdin, never argv" || die "token missing from stdin or present in argv"
grep -q 'fixtureleakcanary' <<<"$out" && die "forge-cli echoed a token value" \
  || pass "real run prints no token value"

# 42. the dry run names the login and the identity check that run, not a
#     verification the script rejects
out=$(env PATH=/usr/bin:/bin HOME="$h" bash "$CRSCRIPT" forge-cli --dry-run 2>&1)
grep -q 'glab auth login --hostname gl.example.test' <<<"$out" && grep -q 'glab api user' <<<"$out" \
  && ! grep -q 'auth status' <<<"$out" \
  && pass "dry run names the login and the identity check" || die "dry run misnames what runs: $out"

# 43. given a checkout, the run proves the login there: a repo-relative call
#     resolves the host from the remote, which is what the identity check
#     cannot exercise. Failure names the host in one line; success says nothing.
mkdir -p "$h/proj"
: > "$stub/log"
out=$(CHECKOUT="$h/proj" real GLAB_REPO_VIEW_RC=1); rc=$?
[ "$rc" -ne 0 ] && grep -q 'gl.example.test' <<<"$out" \
  && pass "a failed repo-relative check names the host" || die "check failure unreported (rc=$rc): $out"
grep -q '^repo view --output json' "$stub/log" \
  && pass "the check is glab repo view in the checkout" || die "no repo view in: $(cat "$stub/log")"
out=$(CHECKOUT="$h/proj" real); rc=$?
[ "$rc" -eq 0 ] && ! grep -qi 'repo' <<<"$out" \
  && pass "a passing check stays silent" || die "passing check noisy or failed (rc=$rc): $out"
rm -rf "$h" "$stub"

# --- config clone: the framework cloned, then installed into ~/.claude ------

# 29. names the repo, where it is cloned, the hooks path clone drops, and the
#     global install that copies the framework into ~/.claude
h=$(mktemp -d); mkdir -p "$h/.claude" "$h/.worker-bootstrap"
out=$(env PATH=/usr/bin:/bin HOME="$h" bash "$WSSCRIPT" config-clone --dry-run 2>&1)
miss=""
for f in "concentrator/claude-dev" "src/claude-dev" "core.hooksPath" "pre-push" "install-dev.sh" "~/.claude"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "config-clone names repo, clone, hooks, pre-push check and install" || die "config-clone missing:$miss"

# 31. dry run clones nothing and installs nothing
[ ! -e "$h/src" ] && [ -z "$(ls -A "$h/.claude")" ] && pass "config-clone dry run clones and installs nothing" \
  || die "dry run wrote: $(ls -A "$h" "$h/.claude")"

# 38. the dry run names the staging dir it retires, and removes nothing
grep -qF -- ".worker-bootstrap" <<<"$out" && [ -d "$h/.worker-bootstrap" ] && pass "config-clone dry run names the staging dir without removing it" \
  || die "staging dir removal unannounced or done anyway: $out"

# A local bare repo standing in for the framework remote, so a real config-clone runs
# offline: the file it verifies after the clone, and an install-dev.sh stub logging its run.
mkremote() {
  local d; d=$(mktemp -d); local w="$d/work"
  mkdir -p "$w/.githooks" "$w/scripts"; printf '#!/bin/sh\nexit 0\n' > "$w/.githooks/pre-push"
  printf '#!/bin/sh\necho "$PWD $*" > "$HOME/install.log"\nexit "${STUB_INSTALL_RC:-0}"\n' > "$w/scripts/install-dev.sh"
  chmod +x "$w/.githooks/pre-push"
  { git -C "$w" init -q -b main && git -C "$w" add -A \
    && git -C "$w" -c user.email=t@example.com -c user.name=t commit -qm init; } >/dev/null 2>&1
  git clone -q --bare "$w" "$d/remote.git" >/dev/null 2>&1
  printf '%s' "$d"
}

clone() { env PATH=/usr/bin:/bin HOME="$h" WORKER_CONFIG_REMOTE="file://$rem/remote.git" "$@" bash "$WSSCRIPT" config-clone 2>&1; }

# 49. the clone lands at ~/src/claude-dev with its hooks path; ~/.claude stays no checkout
rem=$(mkremote); cp /dev/null "$h/.worker-bootstrap/worker-setup.sh"
out=$(clone); rc=$?
[ "$rc" -eq 0 ] && [ "$(git -C "$h/src/claude-dev" config --get core.hooksPath)" = ".githooks" ] \
  && [ ! -e "$h/.claude/.git" ] && pass "config-clone clones to ~/src/claude-dev, not ~/.claude" \
  || die "config-clone misplaced the clone (rc=$rc): $out"

# 50. it runs the global install from the clone: no flag, so ~/.claude
[ "$(cat "$h/install.log" 2>/dev/null)" = "$h/src/claude-dev " ] \
  && pass "config-clone runs the global install from the clone" \
  || die "install not run from the clone as global: $(cat "$h/install.log" 2>/dev/null)"

# 37. the clone retires the bootstrap staging dir: its scripts/ is the scripts' home, and a
#     second copy in ~/.worker-bootstrap is one the operator can edit or run by mistake.
[ ! -d "$h/.worker-bootstrap" ] && pass "config-clone retires the staging dir" \
  || die "staging dir survived the clone"

# 51. a failed install fails the step, and the staging dir stays for a re-run
mkdir -p "$h/.worker-bootstrap"; out=$(clone STUB_INSTALL_RC=1); rc=$?
[ "$rc" -ne 0 ] && [ -d "$h/.worker-bootstrap" ] && pass "a failed install fails config-clone" \
  || die "install failure passed or retired the staging dir (rc=$rc): $out"
rm -rf "$h" "$rem"

# --- project clone: into /opt/wallarm, siblings adjacent --------------------

proj() { env PATH=/usr/bin:/bin "$@" bash "$WSSCRIPT" project-clone --dry-run 2>&1; }

# 10. names the root, the project and the sibling it cannot build without
out=$(proj)
miss=""
for f in "/opt/wallarm" "attack-checker" "wallarm-api-js" "npm ci"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "project-clone names root, project and sibling" || die "project-clone missing:$miss"

# 44. the fresh checkout is where the glab login is proven: forge-cli runs
#     before any project exists, so the repo-relative check runs from here
grep -q 'forge-cli' <<<"$out" && grep -q 'repo view' <<<"$out" \
  && pass "project-clone hands the checkout to forge-cli" || die "project-clone names no forge-cli check: $out"

# 45. no session tree or supervisor/ is written any more, so a clone of a
#     project still declaring Session: excludes neither
! grep -q 'info/exclude' <<<"$out" \
  && pass "project-clone names no session or ledger exclude" \
  || die "project-clone still names an exclude: $out"

pr=$(mktemp -d); for r in attack-checker wallarm-api-js; do git init -q "$pr/$r"; done
mkdir "$pr/attack-checker/.claude"; printf -- '- Session: var/state/\n' > "$pr/attack-checker/.claude/CLAUDE.md"
env PATH=/usr/bin:/bin HOME="$pr" WORKER_PROJECTS_ROOT="$pr" bash "$WSSCRIPT" project-clone >/dev/null 2>&1
ex="$pr/attack-checker/.git/info/exclude"; ! grep -qE '^var/(state|supervisor)/$' "$ex" 2>/dev/null \
  && pass "project-clone excludes no session tree declared in .claude/" || die "excluded: $(cat "$ex")"; rm -rf "$pr"

# 11. the sibling is not optional - file:../wallarm-api-js means npm ci fails
#     outright without it, so the dry run must say so rather than list it as
#     one repo among several
grep -qiE 'adjacent|sibling|file:\.\.' <<<"$out" && pass "adjacency stated as a requirement" \
  || die "adjacency not explained: $out"

# 12. running the project's own gate is the acceptance, not the clone
grep -qiE 'gate|npm test|lint' <<<"$out" && pass "gate run is the acceptance" \
  || die "no gate verification planned: $out"

# --- settings: the allowlist that does not travel with a clone --------------

setl() { env PATH=/usr/bin:/bin "$@" bash "$WSSCRIPT" settings --dry-run 2>&1; }

# 13. names the template, the substitutions and the target
out=$(setl)
miss=""
for f in "auto-permissions.template.json" "__PROJECT_DIR__" "__HOME__" \
         ".claude/settings.local.json"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "settings names template, substitutions and target" || die "settings missing:$miss"

# 14. the push carve-out must cover task-branch prefixes, not just batch/* -
#     batch-only stalls every task-scoped run's branch at push time
grep -qF -- 'git push -u origin doc/*' <<<"$out" && pass "carve-out covers task branches" \
  || die "push carve-out is batch-shaped: $out"

# 15. dry run writes no settings file
h=$(mktemp -d); mkdir -p "$h/proj/.claude"
env PATH=/usr/bin:/bin HOME="$h" WORKER_PROJECT_DIR="$h/proj" bash "$WSSCRIPT" settings --dry-run >/dev/null 2>&1
[ ! -f "$h/proj/.claude/settings.local.json" ] && pass "settings dry run writes nothing" \
  || die "dry run wrote settings.local.json"
rm -rf "$h"

# 46. a real run whose project path carries an &. A substitution that re-scans
#     its replacement half expands & to the whole match, so the seed would grant
#     Edit on a directory that does not exist - and nothing downstream says so:
#     the rule is still valid JSON, so jq -e passes it, and workspace_state
#     trusts the real path either way.
h=$(mktemp -d); mkdir -p "$h/.claude/skills/dev/companions" "$h/a&b/.claude"
cp "$(git rev-parse --show-toplevel)/skills/dev/companions/auto-permissions.template.json" \
  "$h/.claude/skills/dev/companions/"
out=$(env PATH=/usr/bin:/bin HOME="$h" WORKER_PROJECT_DIR="$h/a&b" bash "$WSSCRIPT" settings 2>&1)
sf="$h/a&b/.claude/settings.local.json"
allow=$(jq -r '.permissions.allow[]' "$sf" 2>/dev/null)
edit=$(grep -F 'Edit(//' <<<"$allow" | head -1)
grep -qxF -- "Edit(//${h#/}/a&b/**)" <<<"$allow" \
  && pass "settings seeds the project path as given, & included" \
  || die "seeded Edit rule misnames the project: ${edit:-nothing written} ($out)"
grep -qxF -- "Read(//${h#/}/**)" <<<"$allow" \
  && pass "the siblings rule survives an & path" || die "siblings rule wrong: $allow"

# 47. no placeholder survives anywhere in the written file. The substitution
#     reaches .permissions.allow[] alone, and settings() reads the installed
#     template rather than the tracked one, so a placeholder anywhere else in it
#     would land in the seed unseen - still valid JSON, still past the jq -e.
! grep -qE '__PROJECT_DIR__|__HOME__' "$sf" \
  && pass "no placeholder survives into the seeded settings" \
  || die "a placeholder survived: $(grep -nE '__PROJECT_DIR__|__HOME__' "$sf")"
# 48. the seed declares no interpreter or package-manager rule, which auto drops.
! grep -qE '^Bash\((node|npm|npx)[ :]' <<<"$allow" && pass "the seed carries no rule auto drops" || die "auto-dropped rule seeded: $allow"
rm -rf "$h"

exit $fail
