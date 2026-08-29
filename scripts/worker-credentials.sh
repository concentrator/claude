#!/usr/bin/env bash
# worker-credentials.sh - forge keys and CLI authentication on the worker
# (R040-T010). Runs ON the VM. Siblings: worker-setup.sh makes system-level
# changes, worker-workspace.sh manages repositories. Credentials are their own
# surface because they are the part a mistake leaks.
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
  local host="${GITLAB_HOST:-gl.wallarm.com}"

  # A value, not a line. .env.example ships both names empty for the operator to
  # fill, so testing for the name alone reports a token the real run then finds
  # blank and skips - a dry run promising an authentication that never happens.
  local have_gl=no have_gh=no
  if [ -f "$envf" ]; then
    grep -qE '^GITLAB_TOKEN=[^[:space:]]' "$envf" && have_gl=yes
    grep -qE '^GITHUB_TOKEN=[^[:space:]]' "$envf" && have_gh=yes
    host=$(sed -n 's/^GITLAB_HOST=\([^[:space:]]\{1,\}\).*/\1/p' "$envf" | head -1)
    host="${host:-${GITLAB_HOST:-gl.wallarm.com}}"
  fi

  if [ "$dry" -eq 1 ]; then
    printf 'forge-cli would:\n'
    printf '  - install glab and gh (API layer only; git itself rides the SSH keys)\n'
    printf '  - read GITLAB_TOKEN and GITHUB_TOKEN from %s (values never printed)\n' "$envf"
    printf '  - glab auth login --hostname %s --stdin, then verify with glab api user\n' "$host"
    printf '  - export GITHUB_TOKEN for gh (it needs no login), then verify with gh api user\n'
    printf '  - token present: GITLAB_TOKEN=%s GITHUB_TOKEN=%s\n' "$have_gl" "$have_gh"
    [ "$have_gh" = no ] && printf '  - note: no GITHUB_TOKEN. Not fatal - a worker delivering only GitLab\n    work never needs one; it gates gh pr create and merge.\n'
    return 0
  fi

  forge_install || return 1
  forge_auth
}


# Install both CLIs from their vendors' own distributions. This box holds keys
# for both forges, so a third-party apt repository is the wrong trust boundary.
# Needs no tokens - refusing to install because a credential file is absent
# conflates two separate steps, and did exactly that on a real host.
forge_install() {
  if ! command -v glab >/dev/null 2>&1; then
    local url tmpdeb
    url=$(curl -fsSL "https://gitlab.com/api/v4/projects/gitlab-org%2Fcli/releases" \
          | jq -r '.[0].assets.links[]? | select(.name | test("amd64.deb$")) | .url' | head -1)
    if [ -n "$url" ]; then
      tmpdeb=$(mktemp --suffix=.deb)
      curl -fsSL "$url" -o "$tmpdeb" && sudo apt-get install -y -qq "$tmpdeb"
      rm -f "$tmpdeb"
    else
      printf 'forge-cli: could not resolve a glab release asset\n' >&2
    fi
  fi
  if ! command -v gh >/dev/null 2>&1; then
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg status=none
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    printf 'deb [arch=%s signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\n' \
      "$(dpkg --print-architecture)" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update -qq && sudo apt-get install -y -qq gh
  fi
  printf 'forge-cli: glab %s, gh %s\n' \
    "$(glab --version 2>/dev/null | head -1 || echo missing)" \
    "$(gh --version 2>/dev/null | head -1 || echo missing)"

}

# Authenticate, and make the tokens reach a worker session - not just this
# shell. glab needs a login as well as the token: an exported GITLAB_TOKEN
# satisfies `glab api user --hostname`, but a repo-relative call resolves the
# host from the checkout's remote against the hosts glab has logged in to, and
# with none it fails - after the batch, at MR create. Verification is scoped to
# the instance in question and reports the identity: `glab auth status` checks
# every configured instance and fails if any one does, which produced a false
# negative here while real calls worked.
# Two identities, because a supervised commit has two facts to state. The
# author is the human whose work it is; the committer says how it was applied.
# git honours committer.* independently of user.*, so `git log --author`,
# shortlog and blame keep answering about the human while the distinction stays
# visible where a reader looks for it. The committer name derives from the
# hostname rather than from .env, because it states two facts about this
# machine and nothing a second copy could disagree with.
#
# Both variables are required rather than optional: without an identity git
# refuses to commit outright, so the failure is a worker halting at its first
# commit, not a misattributed history. Provisioning that reported success here
# while leaving the host unable to commit is the shape this check exists to
# rule out.
git_identity() {
  local envf="$1"
  if [ -z "${GIT_USER_NAME:-}" ] || [ -z "${GIT_USER_EMAIL:-}" ]; then
    printf 'git: GIT_USER_NAME or GIT_USER_EMAIL absent from %s\n' "$envf" >&2
    printf 'git: git refuses to commit without an identity, so a worker would\n' >&2
    printf '     halt at its first commit. Fill both in and re-run.\n' >&2
    return 1
  fi
  git config --global user.name  "$GIT_USER_NAME"
  git config --global user.email "$GIT_USER_EMAIL"
  git config --global committer.name  "$(hostname) (supervised)"
  git config --global committer.email "$GIT_USER_EMAIL"
  printf 'git: %s authors, %s commits\n' \
    "$(git config --global --get user.name)" "$(git config --global --get committer.name)"
}

forge_auth() {
  local envf="$HOME/.claude/.env"
  if [ ! -f "$envf" ]; then
    printf 'forge-cli: installed, but %s is absent so nothing is authenticated\n' "$envf" >&2
    return 1
  fi
  set -a; . "$envf"; set +a

  # A worker session is not this shell, so the tokens have to reach it. Source
  # .env above the interactivity guard, the same place the claude PATH goes -
  # otherwise glab works here and not where the work happens.
  if ! grep -q 'claude-worker env' "$HOME/.bashrc" 2>/dev/null; then
    printf '%s\n%s\n' '# claude-worker env - before the non-interactive guard below' \
      '[ -f "$HOME/.claude/.env" ] && set -a && . "$HOME/.claude/.env" && set +a' \
      | cat - "$HOME/.bashrc" > "$HOME/.bashrc.new" && mv "$HOME/.bashrc.new" "$HOME/.bashrc"
  fi

  git_identity "$envf" || return 1

  local who host="${GITLAB_HOST:-gl.wallarm.com}"
  if [ -n "${GITLAB_TOKEN:-}" ]; then
    printf '%s' "$GITLAB_TOKEN" | glab auth login --hostname "$host" --stdin >/dev/null 2>&1 \
      || { printf 'glab: login to %s failed\n' "$host" >&2; return 1; }
    who=$(glab api user --hostname "$host" 2>/dev/null | jq -r '.username // empty')
    [ -n "$who" ] && printf 'glab: authenticated to %s as %s\n' "$host" "$who" \
                  || { printf 'glab: NOT authenticated to %s\n' "$host" >&2; return 1; }
  fi
  if [ -n "${GITHUB_TOKEN:-}" ]; then
    who=$(gh api user 2>/dev/null | jq -r '.login // empty')
    [ -n "$who" ] && printf 'gh: authenticated as %s\n' "$who" \
                  || { printf 'gh: NOT authenticated\n' >&2; return 1; }
  else
    printf 'gh: no GITHUB_TOKEN, skipped (only needed for toolset PRs)\n'
  fi
}

main() {
  case "${1:-}" in
    keys)        shift; keys "$@" ;;
    keys-verify) keys_verify ;;
    forge-cli)   shift; forge_cli "$@" ;;
    *) printf 'usage: worker-credentials.sh keys | forge-cli [--dry-run] | keys-verify\n' >&2; return 2 ;;
  esac
}

main "$@"
