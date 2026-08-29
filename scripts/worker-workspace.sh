#!/usr/bin/env bash
# worker-workspace.sh - the worker's repositories and per-project settings
# (R040-T010). Runs ON the VM. Siblings: worker-setup.sh for system-level
# changes, worker-credentials.sh for keys and forge authentication.
set -uo pipefail

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
    printf '  - retire ~/%s, the bootstrap staging dir this checkout supersedes\n' \
      "${WORKER_BOOTSTRAP_DIR:-.worker-bootstrap}"
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

  # scripts/ is now the VM-side scripts' home, so the copies provision-worker.sh
  # push-scripts staged to bootstrap this host are superseded, and a second copy
  # is one an operator can edit or run by mistake. Removed only once every check
  # above has passed, and safe even though this script is running from there:
  # the kernel keeps the open file alive until it exits.
  rm -rf "$HOME/${WORKER_BOOTSTRAP_DIR:-.worker-bootstrap}"

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
    printf '  - worker-credentials.sh forge-cli %s/%s: glab repo view there proves\n' "$root" "$(basename "$proj")"
    printf '    the login resolves the remote, which forge-cli alone cannot\n'
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
  # The checkout is born here, after forge-cli's own step, so this is where the
  # login is proven against a remote. Install and login repeat as no-ops.
  bash "$(dirname "${BASH_SOURCE[0]}")/worker-credentials.sh" forge-cli "$root/$(basename "$proj")"
}

# Runs ON the VM. Writes the project's .claude/settings.local.json, which is
# gitignored (*.local.json) and therefore never arrives with a clone - and it
# is exactly the file that keeps a worker from stalling on a permission
# prompt. Built from companions/auto-permissions.template.json with
# __PROJECT_DIR__ and __HOME__ substituted; the rules carry a // prefix,
# so the paths go in without their leading slash.
settings() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local pd="${WORKER_PROJECT_DIR:-/opt/wallarm/attack-checker}"
  local tpl="$HOME/.claude/skills/dev/companions/auto-permissions.template.json"
  local out="$pd/.claude/settings.local.json"

  if [ "$dry" -eq 1 ]; then
    printf 'settings would:\n'
    printf '  - read %s\n' "$tpl"
    printf '  - substitute __PROJECT_DIR__=%s __HOME__=%s\n' "${pd#/}" "${HOME#/}"
    printf '  - grant read on %s, the projects root, since a doc cites the\n' "$(dirname "$pd")"
    printf '    sibling repositories its subject calls into\n'
    printf '  - add the project toolchain rules from its CLAUDE.md and the push\n'
    printf '    carve-out: git push -u origin doc/* feat/* fix/* refactor/*\n'
    printf '    mnt/* test/* plan/* batch/* - batch-only stalls manual branches\n'
    printf '  - write %s (gitignored, so it never arrives with a clone)\n' "$out"
    printf '  - trust the workspace and dismiss the auto-mode setup dialog in\n'
    printf '    ~/.claude.json, neither of which arrives with a clone\n'
    printf '  - verify by running a command the allowlist covers, unprompted\n'
    return 0
  fi

  [ -f "$tpl" ] || { printf 'settings: template missing at %s\n' "$tpl" >&2; return 1; }
  mkdir -p "$pd/.claude"

  local base; base=$(sed -e "s|__PROJECT_DIR__|${pd#/}|g" -e "s|__HOME__|${HOME#/}|g" "$tpl")
  printf '%s' "$base" | jq --arg siblings "//$(dirname "${pd#/}")/**" \
    '.permissions.allow += [
      "Read(" + $siblings + ")",
      "Bash(npm *)", "Bash(node *)", "Bash(npx *)", "Bash(glab *)", "Bash(gh *)",
      "Bash(git push -u origin batch/*)", "Bash(git push -u origin doc/*)",
      "Bash(git push -u origin feat/*)",  "Bash(git push -u origin fix/*)",
      "Bash(git push -u origin refactor/*)", "Bash(git push -u origin mnt/*)",
      "Bash(git push -u origin test/*)",  "Bash(git push -u origin plan/*)"
    ] | .permissions.deny = ["Bash(git push origin main:*)", "Bash(git push --force:*)"]' > "$out" || return 1

  jq -e . "$out" >/dev/null 2>&1 || { printf 'settings: %s is not valid JSON\n' "$out" >&2; return 1; }

  workspace_state "$pd" || return 1

  printf 'settings: %s written, %s allow rules, workspace trusted\n' \
    "$out" "$(jq '.permissions.allow | length' "$out")"
}

# Runs ON the VM. The two pieces of state that live in ~/.claude.json, outside
# the project, and so arrive with neither the clone nor the settings file.
#
# An untrusted workspace has its allow entries IGNORED - Claude Code reports
# "this workspace has not been trusted" and drops them, which on a worker reads
# as a permission prompt nobody can answer.
#
# The auto-mode setup dialog is the other. A fresh auto-mode session offers to
# scan the repo, recent sessions, shell history and other repositories, and the
# offer sits over the pane until answered - which stalled a supervisor mid-run
# for the better part of an hour, showing a dialog rather than an error.
# Dismissing it costs nothing, because auto mode needs no setup to function, and
# it leaves opting into the scan a deliberate act.
workspace_state() {
  local pd="$1"
  local cj="$HOME/.claude.json"
  [ -f "$cj" ] || printf '{}' > "$cj"
  local tmp; tmp=$(mktemp)
  jq --arg p "$pd" '.projects[$p].hasTrustDialogAccepted = true
      | .autoModeEnvSetup.dismissed = true' "$cj" > "$tmp" && mv "$tmp" "$cj"
}

main() {
  case "${1:-}" in
    config-clone)  shift; config_clone "$@" ;;
    project-clone) shift; project_clone "$@" ;;
    settings)      shift; settings "$@" ;;
    *) printf 'usage: worker-workspace.sh config-clone | project-clone | settings [--dry-run]\n' >&2; return 2 ;;
  esac
}

main "$@"
