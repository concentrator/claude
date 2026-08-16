#!/usr/bin/env bash
# worker-workspace.sh - the worker's own $HOME: credentials and repositories
# (R040-T010). Runs ON the VM. Its sibling worker-setup.sh makes system-level
# changes through apt and systemd; nothing here needs root, and the split is
# that boundary rather than an arbitrary size cut.
set -uo pipefail

# Runs ON the VM. A distinct key per forge, because one key shared across both
# means revoking access to either revokes both. No passphrase: a worker cannot
# answer a prompt, and the protection that matters here is that the box is
# reachable only over IAP.
keys() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local d="$HOME/.ssh"

  local steps=(
    "ssh-keygen -t ed25519 -N '' (no passphrase) -f $d/id_ed25519_github"
    "ssh-keygen -t ed25519 -N '' (no passphrase) -f $d/id_ed25519_gitlab"
    "write ~/.ssh/config: github.com -> id_ed25519_github, gl.wallarm.com -> id_ed25519_gitlab"
    "print both public keys for the operator to install on each forge"
  )
  if [ "$dry" -eq 1 ]; then
    printf 'keys would:\n'; printf '  - %s\n' "${steps[@]}"; return 0
  fi

  mkdir -p "$d" && chmod 700 "$d"
  local f
  for f in github gitlab; do
    [ -f "$d/id_ed25519_$f" ] || ssh-keygen -q -t ed25519 -N '' -C "claude-worker-$f" -f "$d/id_ed25519_$f"
  done
  if ! grep -q 'claude-worker keys' "$d/config" 2>/dev/null; then
    cat >> "$d/config" <<CFG
# claude-worker keys
Host github.com
  IdentityFile ~/.ssh/id_ed25519_github
  IdentitiesOnly yes
Host gl.wallarm.com
  IdentityFile ~/.ssh/id_ed25519_gitlab
  IdentitiesOnly yes
CFG
    chmod 600 "$d/config"
  fi
  printf '\n=== install these public keys on each forge ===\n'
  printf -- '--- github.com ---\n%s\n' "$(cat "$d/id_ed25519_github.pub")"
  printf -- '--- gl.wallarm.com ---\n%s\n' "$(cat "$d/id_ed25519_gitlab.pub")"
}

# Report the identity each forge hands back. A key that authenticates as the
# wrong account is the failure worth catching, and it looks like success.
keys_verify() {
  local h
  for h in github.com gl.wallarm.com; do
    printf '%s: %s\n' "$h" "$(ssh -o StrictHostKeyChecking=accept-new -o BatchMode=yes -T "git@$h" 2>&1 | head -1)"
  done
}

# Runs ON the VM. Both CLIs are API-layer only: git traffic rides the SSH keys
# above, so these exist for MR/PR create, view and merge. Tokens come from
# ~/.claude/.env, which is gitignored and therefore does not arrive with the
# config clone - the operator places it. Values are read, never echoed: this
# output reaches transcripts and shell history.
forge_cli() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local envf="$HOME/.claude/.env"

  local have_gl=no have_gh=no
  if [ -f "$envf" ]; then
    grep -q '^GITLAB_TOKEN=' "$envf" && have_gl=yes
    grep -q '^GITHUB_TOKEN=' "$envf" && have_gh=yes
  fi

  if [ "$dry" -eq 1 ]; then
    printf 'forge-cli would:\n'
    printf '  - install glab and gh (API layer only; git itself rides the SSH keys)\n'
    printf '  - read GITLAB_TOKEN and GITHUB_TOKEN from %s (values never printed)\n' "$envf"
    printf '  - glab auth login --stdin, then verify with glab auth status\n'
    printf '  - gh auth login --with-token, then verify with gh auth status\n'
    printf '  - token present: GITLAB_TOKEN=%s GITHUB_TOKEN=%s\n' "$have_gl" "$have_gh"
    [ "$have_gh" = no ] && printf '  - note: no GITHUB_TOKEN. Not fatal - a worker delivering only GitLab\n    work never needs one; it gates gh pr create and merge.\n'
    return 0
  fi

  [ -f "$envf" ] || { printf 'forge-cli: no %s - place it before authenticating\n' "$envf" >&2; return 1; }
  set -a; . "$envf"; set +a

  command -v glab >/dev/null 2>&1 || {
    curl -fsSL https://raw.githubusercontent.com/upciti/wakemeops/main/assets/install_repository | sudo bash
    sudo apt-get install -y -qq glab
  }
  command -v gh >/dev/null 2>&1 || sudo apt-get install -y -qq gh

  if [ -n "${GITLAB_TOKEN:-}" ]; then
    printf '%s' "$GITLAB_TOKEN" | glab auth login --hostname gl.wallarm.com --stdin >/dev/null 2>&1
    glab auth status >/dev/null 2>&1 && printf 'glab: authenticated\n' || printf 'glab: NOT authenticated\n' >&2
  fi
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    printf '%s' "$GITHUB_TOKEN" | gh auth login --with-token >/dev/null 2>&1
    gh auth status >/dev/null 2>&1 && printf 'gh: authenticated\n' || printf 'gh: NOT authenticated\n' >&2
  else
    printf 'gh: no GITHUB_TOKEN, skipped (only needed for toolset PRs)\n'
  fi
}

# Runs ON the VM. The config repo becomes ~/.claude itself, giving the worker
# byte-identical config to the operator: CLAUDE.md, rules/, skills/, agents/,
# hooks/, settings.json, with all harness state gitignored. Deliberately not
# install-dev.sh, which targets adopter projects and omits personal convention
# rules the worker needs.
#
# Claude Code has already written credentials and state into ~/.claude, so a
# plain clone would refuse a non-empty target. Initialise in place instead and
# check out over the top; the ignored state survives untouched.
config_clone() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local d="$HOME/.claude" remote="${WORKER_CONFIG_REMOTE:-git@github.com:concentrator/claude.git}"

  if [ "$dry" -eq 1 ]; then
    printf 'config-clone would:\n'
    printf '  - git init in the existing %s (Claude Code state already lives there)\n' "$d"
    printf '  - add %s as origin and check out main over the top\n' "$remote"
    printf '  - restore core.hooksPath=.githooks, which clone never carries\n'
    printf '  - prove the pre-push hook actually fires, rather than assuming it\n'
    printf '  - leave .credentials.json and other ignored state in place\n'
    return 0
  fi

  mkdir -p "$d"
  if [ ! -d "$d/.git" ]; then
    git -C "$d" init -q
    git -C "$d" remote add origin "$remote" 2>/dev/null || git -C "$d" remote set-url origin "$remote"
    git -C "$d" fetch -q --depth=1 origin main || return 1
    git -C "$d" checkout -q -f -B main FETCH_HEAD || return 1
  else
    git -C "$d" fetch -q origin main && git -C "$d" merge -q --ff-only FETCH_HEAD 2>/dev/null
  fi
  git -C "$d" config core.hooksPath .githooks

  # Belt and braces, local to this checkout: the worker's Claude Code
  # credentials must never be stageable, and relying on the cloned .gitignore
  # makes that depend on which commit was fetched. A clone of an older main
  # left .credentials.json untracked-and-visible on a real worker.
  local ex="$d/.git/info/exclude"
  mkdir -p "$(dirname "$ex")"
  grep -q '^\.credentials\.json$' "$ex" 2>/dev/null || printf '.credentials.json\ndownloads/\n' >> "$ex"

  local hp; hp=$(git -C "$d" config --get core.hooksPath)
  [ "$hp" = ".githooks" ] || { printf 'config-clone: hooksPath not set\n' >&2; return 1; }
  [ -x "$d/.githooks/pre-push" ] || { printf 'config-clone: pre-push hook missing or not executable\n' >&2; return 1; }
  printf 'config-clone: %s at %s, hooksPath=%s, pre-push present\n' \
    "$d" "$(git -C "$d" rev-parse --short HEAD)" "$hp"
}

# Runs ON the VM. Clones a project and the siblings it cannot build without,
# into /opt/wallarm. Adjacency is a hard requirement rather than a
# convenience: attack-checker's package.json names
# "wallarm-api-js": "file:../wallarm-api-js", so npm ci fails outright if the
# sibling is absent. Acceptance is the project's own gate running green - a
# host that cannot execute the gate cannot deliver a batch, and finding that
# out here costs less than finding it at a checkpoint.
project_clone() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local root="${WORKER_PROJECTS_ROOT:-/opt/wallarm}"
  local host="${WORKER_FORGE_HOST:-gl.wallarm.com}"
  local proj="${WORKER_PROJECT_REPO:-support/attack-checker}"
  local sib="${WORKER_SIBLING_REPO:-support/wallarm-api-js}"

  if [ "$dry" -eq 1 ]; then
    printf 'project-clone would:\n'
    printf '  - clone git@%s:%s.git into %s/attack-checker\n' "$host" "$proj" "$root"
    printf '  - clone git@%s:%s.git into %s/wallarm-api-js, adjacent - the\n' "$host" "$sib" "$root"
    printf '    dependency is file:../wallarm-api-js, so npm ci fails without it\n'
    printf '  - npm ci in the project\n'
    printf '  - run the project gate (npm test, npm run lint) as the acceptance\n'
    return 0
  fi

  mkdir -p "$root" || return 1
  local name
  for pair in "$proj" "$sib"; do
    name=$(basename "$pair")
    if [ -d "$root/$name/.git" ]; then
      git -C "$root/$name" fetch -q origin 2>/dev/null
    else
      git clone -q "git@$host:$pair.git" "$root/$name" || { printf 'project-clone: clone failed for %s\n' "$pair" >&2; return 1; }
    fi
  done

  ( cd "$root/$(basename "$proj")" && npm ci --silent ) || { printf 'project-clone: npm ci failed\n' >&2; return 1; }
  printf 'project-clone: cloned, now running the project gate\n'
  ( cd "$root/$(basename "$proj")" && npm test >/dev/null 2>&1 ) \
    && printf 'project-clone: npm test green\n' || { printf 'project-clone: npm test FAILED\n' >&2; return 1; }
  ( cd "$root/$(basename "$proj")" && npm run lint >/dev/null 2>&1 ) \
    && printf 'project-clone: npm run lint clean\n' || { printf 'project-clone: lint FAILED\n' >&2; return 1; }
}

# Runs ON the VM. Writes the project's .claude/settings.local.json, which is
# gitignored (*.local.json) and therefore never arrives with a clone - and it
# is exactly the file that keeps a worker from stalling on a permission
# prompt. Built from companions/auto-permissions.template.json with
# __PROJECT_DIR__, __HOME__ and __ARTIFACTS_ROOT__ substituted; the rules carry
# a // prefix, so the paths go in without their leading slash.
settings() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local pd="${WORKER_PROJECT_DIR:-/opt/wallarm/attack-checker}"
  local tpl="$HOME/.claude/skills/dev/companions/auto-permissions.template.json"
  local out="$pd/.claude/settings.local.json"
  local root="${WORKER_ARTIFACTS_ROOT:-dev}"

  if [ "$dry" -eq 1 ]; then
    printf 'settings would:\n'
    printf '  - read %s\n' "$tpl"
    printf '  - substitute __PROJECT_DIR__=%s __HOME__=%s __ARTIFACTS_ROOT__=%s\n' \
      "${pd#/}" "${HOME#/}" "$root"
    printf '  - add the project toolchain rules from its CLAUDE.md and the push\n'
    printf '    carve-out: git push -u origin doc/* feat/* fix/* refactor/*\n'
    printf '    mnt/* test/* plan/* batch/* - batch-only stalls manual branches\n'
    printf '  - write %s (gitignored, so it never arrives with a clone)\n' "$out"
    printf '  - verify by running a command the allowlist covers, unprompted\n'
    return 0
  fi

  [ -f "$tpl" ] || { printf 'settings: template missing at %s\n' "$tpl" >&2; return 1; }
  mkdir -p "$pd/.claude"

  local base; base=$(sed -e "s|__PROJECT_DIR__|${pd#/}|g" -e "s|__HOME__|${HOME#/}|g" \
                         -e "s|__ARTIFACTS_ROOT__/|$root/|g" -e "s|__ARTIFACTS_ROOT__|$root|g" "$tpl")
  printf '%s' "$base" | jq '.permissions.allow += [
      "Bash(npm *)", "Bash(node *)", "Bash(npx *)", "Bash(glab *)", "Bash(gh *)",
      "Bash(git push -u origin batch/*)", "Bash(git push -u origin doc/*)",
      "Bash(git push -u origin feat/*)",  "Bash(git push -u origin fix/*)",
      "Bash(git push -u origin refactor/*)", "Bash(git push -u origin mnt/*)",
      "Bash(git push -u origin test/*)",  "Bash(git push -u origin plan/*)"
    ] | .permissions.deny = ["Bash(git push origin main:*)", "Bash(git push --force:*)"]' > "$out" || return 1

  jq -e . "$out" >/dev/null 2>&1 || { printf 'settings: %s is not valid JSON\n' "$out" >&2; return 1; }

  # An untrusted workspace has its allow entries IGNORED - Claude Code reports
  # "this workspace has not been trusted" and drops them, which on a worker
  # reads as a permission prompt nobody can answer. The trust flag lives in
  # ~/.claude.json, outside the project, so it never arrives with a clone
  # either. Accepting it here is what the operator would otherwise do by
  # opening an interactive session on the box.
  local cj="$HOME/.claude.json"
  [ -f "$cj" ] || printf '{}' > "$cj"
  local tmp; tmp=$(mktemp)
  jq --arg p "$pd" '.projects[$p].hasTrustDialogAccepted = true' "$cj" > "$tmp" && mv "$tmp" "$cj"

  printf 'settings: %s written, %s allow rules, workspace trusted\n' \
    "$out" "$(jq '.permissions.allow | length' "$out")"
}

main() {
  case "${1:-}" in
    settings)      shift; settings "$@" ;;
    project-clone) shift; project_clone "$@" ;;
    keys)         shift; keys "$@" ;;
    keys-verify)  keys_verify ;;
    forge-cli)    shift; forge_cli "$@" ;;
    config-clone) shift; config_clone "$@" ;;
    *) printf 'usage: worker-workspace.sh keys | forge-cli | config-clone | project-clone | settings [--dry-run] | keys-verify\n' >&2; return 2 ;;
  esac
}

main "$@"
