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

# --- config clone: this repo becomes the worker's ~/.claude -----------------

cfg() { env PATH=/usr/bin:/bin "$@" bash "$WSSCRIPT" config-clone --dry-run 2>&1; }

# 29. names the repo, the hooks path clone drops, and why it is not install-dev
out=$(cfg)
miss=""
for f in "concentrator/claude" "core.hooksPath" "pre-push"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "config-clone names repo, hooks and proof" || die "config-clone missing:$miss"

# 30. it must clone INTO an existing directory - Claude Code has already put
#     credentials and state in ~/.claude, and a plain clone would refuse or
#     replace them
grep -qiE 'existing|in place|init' <<<"$out" && pass "clones into the existing dir" \
  || die "config-clone assumes an empty target: $out"

# 31. dry run creates no repo
h=$(mktemp -d); mkdir -p "$h/.claude"
env PATH=/usr/bin:/bin HOME="$h" bash "$WSSCRIPT" config-clone --dry-run >/dev/null 2>&1
[ ! -d "$h/.claude/.git" ] && pass "config-clone dry run creates no repo" || die "dry run made a repo"
rm -rf "$h"

# A local bare repo standing in for the config remote, so a real config-clone
# runs offline. It carries the one file config-clone verifies after checkout.
mkremote() {
  local d; d=$(mktemp -d); local w="$d/work"
  mkdir -p "$w/.githooks"; printf '#!/bin/sh\nexit 0\n' > "$w/.githooks/pre-push"
  chmod +x "$w/.githooks/pre-push"
  git -C "$w" init -q -b main >/dev/null 2>&1
  git -C "$w" add -A >/dev/null 2>&1
  git -C "$w" -c user.email=t@example.com -c user.name=t commit -qm init >/dev/null 2>&1
  git clone -q --bare "$w" "$d/remote.git" >/dev/null 2>&1
  printf '%s' "$d"
}

# 37. the checkout retires the bootstrap staging dir. Once ~/.claude is the repo,
#     scripts/ is the scripts' home, and a second copy in ~/.worker-bootstrap is
#     one the operator can edit or run by mistake.
h=$(mktemp -d); mkdir -p "$h/.claude" "$h/.worker-bootstrap"
rem=$(mkremote); cp /dev/null "$h/.worker-bootstrap/worker-setup.sh"
out=$(env PATH=/usr/bin:/bin HOME="$h" WORKER_CONFIG_REMOTE="file://$rem/remote.git" \
  bash "$WSSCRIPT" config-clone 2>&1)
if [ -d "$h/.claude/.git" ]; then
  [ ! -d "$h/.worker-bootstrap" ] && pass "config-clone retires the staging dir" \
    || die "staging dir survived the checkout"
else
  die "config-clone did not check out from the fixture remote: $out"
fi

# 38. the dry run says so, and removes nothing
h2=$(mktemp -d); mkdir -p "$h2/.claude" "$h2/.worker-bootstrap"
out=$(env PATH=/usr/bin:/bin HOME="$h2" bash "$WSSCRIPT" config-clone --dry-run 2>&1)
grep -qF -- ".worker-bootstrap" <<<"$out" && [ -d "$h2/.worker-bootstrap" ] \
  && pass "config-clone dry run names the staging dir without removing it" \
  || die "staging dir removal unannounced or done anyway: $out"
rm -rf "$h" "$h2" "$rem"

# --- project clone: into /opt/wallarm, siblings adjacent --------------------

proj() { env PATH=/usr/bin:/bin "$@" bash "$WSSCRIPT" project-clone --dry-run 2>&1; }

# 10. names the root, the project and the sibling it cannot build without
out=$(proj)
miss=""
for f in "/opt/wallarm" "attack-checker" "wallarm-api-js" "npm ci"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "project-clone names root, project and sibling" || die "project-clone missing:$miss"

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
#     batch-only stalls every manual /dev code branch at push time
grep -qF -- 'git push -u origin doc/*' <<<"$out" && pass "carve-out covers task branches" \
  || die "push carve-out is batch-shaped: $out"

# 15. dry run writes no settings file
h=$(mktemp -d); mkdir -p "$h/proj/.claude"
env PATH=/usr/bin:/bin HOME="$h" WORKER_PROJECT_DIR="$h/proj" bash "$WSSCRIPT" settings --dry-run >/dev/null 2>&1
[ ! -f "$h/proj/.claude/settings.local.json" ] && pass "settings dry run writes nothing" \
  || die "dry run wrote settings.local.json"
rm -rf "$h"

exit $fail
