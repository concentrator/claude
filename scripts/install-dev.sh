#!/usr/bin/env bash
# install-dev.sh - install the DEV toolset into a target .claude.
#
# Usage:
#   install-dev.sh                 install into ~/.claude (global)
#   install-dev.sh --project <p>   install into <p>/.claude (project copy)
#
# Copies the /dev router + its companions, the bundled dependency skills, the
# branch-guard + secrets-guard + branch-state hooks (registered in the target
# settings.json), the shipped Tier-1 checks with their self-tests, and the
# writing conventions (@imported by CLAUDE.md).
# Does NOT ship the user's personal convention rules.
# Idempotent + re-runnable.
set -euo pipefail

SRC="$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "install-dev: run from a checkout of the toolset repo" >&2; exit 1; }
command -v jq >/dev/null || { echo "install-dev: jq is required" >&2; exit 1; }
target="$HOME/.claude"; scope="global"
while [ $# -gt 0 ]; do
  case "$1" in
    --project) target="${2:?--project needs a path}/.claude"; scope="project"; shift ;;
    *) echo "usage: install-dev.sh [--project <path>]" >&2; exit 2 ;;
  esac
  shift
done

BUNDLED="test-driven-development systematic-debugging verification-before-completion receiving-code-review dispatching-parallel-agents"

mkdir -p "$target/skills" "$target/hooks"

# 1. the /dev router + companions
rm -rf "$target/skills/dev"
cp -R "$SRC/skills/dev" "$target/skills/dev"

# 2. bundled dependency skills (the companions reference these by name)
for s in $BUNDLED; do
  rm -rf "$target/skills/$s"
  cp -R "$SRC/skills/$s" "$target/skills/$s"
done

# 3. hooks: copy + register the branch-guard and the secrets guard
#    (PreToolUse) and the branch-state line (UserPromptSubmit)
#    (idempotent; preserve everything else in settings.json)
if [ "$scope" = global ]; then hp="~/.claude/hooks"; else hp=".claude/hooks"; fi
settings="$target/settings.json"
[ -f "$settings" ] || echo '{}' > "$settings"

register_hook() {   # $1 = hook script basename
  cp "$SRC/hooks/$1" "$target/hooks/$1"
  chmod +x "$target/hooks/$1"
  local cmd="$hp/$1" tmp; tmp="$(mktemp)"
  if jq --arg cmd "$cmd" '
    if ([.hooks.PreToolUse[]?.hooks[]?.command] | any(. == $cmd)) then .
    else .hooks.PreToolUse = ((.hooks.PreToolUse // []) + [
      {matcher: "Write|Edit|NotebookEdit", hooks: [{type: "command", command: $cmd}]},
      {matcher: "Bash", hooks: [{type: "command", command: $cmd}]}
    ]) end
  ' "$settings" > "$tmp"; then
    mv "$tmp" "$settings"
  else
    rm -f "$tmp"; echo "install-dev: failed to update $settings (invalid JSON?)" >&2; exit 1
  fi
}

register_state_hook() {   # $1 = hook script basename; UserPromptSubmit, no matcher
  cp "$SRC/hooks/$1" "$target/hooks/$1"
  chmod +x "$target/hooks/$1"
  local cmd="$hp/$1" tmp; tmp="$(mktemp)"
  if jq --arg cmd "$cmd" '
    if ([.hooks.UserPromptSubmit[]?.hooks[]?.command] | any(. == $cmd)) then .
    else .hooks.UserPromptSubmit = ((.hooks.UserPromptSubmit // []) + [
      {hooks: [{type: "command", command: $cmd}]}
    ]) end
  ' "$settings" > "$tmp"; then
    mv "$tmp" "$settings"
  else
    rm -f "$tmp"; echo "install-dev: failed to update $settings (invalid JSON?)" >&2; exit 1
  fi
}

register_hook dev-branch-guard.sh
register_hook dev-secrets-guard.sh
register_state_hook dev-branch-state.sh
# The secrets guard's predicate lives beside it (sourced, not registered).
cp "$SRC/hooks/secret-patterns.sh" "$target/hooks/secret-patterns.sh"

# 4. shipped Tier-1 checks - the ones with no dependency on this repo's
#    own layout; adopters wire them into their CI (the batch-tags gate
#    enforces locally, e.g. a pre-push hook - its CI run reports a
#    skip). The accretion and batch-tags pair ship their self-tests:
#    both are tuned per project (the MARKERS list, the ref namespaces)
#    and the self-test is how an adopter validates that edit. Adopter
#    tuning survives a re-run: the code-size allowlist is written only
#    when absent, and an existing MARKERS line is carried across the
#    accretion-check copy.
mkdir -p "$target/scripts/ci" "$target/scripts/test"
markers=""
[ -f "$target/scripts/ci/check-accretion.sh" ] \
  && markers="$(grep -m1 '^MARKERS=' "$target/scripts/ci/check-accretion.sh" || true)"
for f in ci/check-code-size.sh ci/check-no-em-dash.sh ci/check-accretion.sh \
         ci/check-batch-tags.sh ci/resolve-root.sh \
         test/check-accretion.test.sh test/check-batch-tags.test.sh; do
  cp "$SRC/scripts/$f" "$target/scripts/$f"
done
chmod +x "$target"/scripts/ci/check-*.sh
if [ -n "$markers" ]; then
  tmp="$(mktemp)"
  while IFS= read -r line; do
    case "$line" in MARKERS=*) printf '%s\n' "$markers" ;; *) printf '%s\n' "$line" ;; esac
  done < "$target/scripts/ci/check-accretion.sh" > "$tmp"
  mv "$tmp" "$target/scripts/ci/check-accretion.sh"
  chmod +x "$target/scripts/ci/check-accretion.sh"
fi
if [ ! -f "$target/scripts/ci/code-size-allow.txt" ]; then
  cat > "$target/scripts/ci/code-size-allow.txt" <<'EOF'
# check-code-size.sh exemptions: one tracked path per line; text after `#` is
# the reason. Exempts a path from both the file-size and function-size checks.
EOF
fi

# 5. writing conventions: ship writing.md + @import it from the target CLAUDE.md
#    (append-only + idempotent; never clobbers an existing CLAUDE.md).
cp "$SRC/writing.md" "$target/writing.md"
claudemd="$target/CLAUDE.md"
grep -qxF '@writing.md' "$claudemd" 2>/dev/null || printf '\n@writing.md\n' >> "$claudemd"

# 6. committability: for a project install, allowlist installed paths that the
# target repo's .gitignore excludes (idempotent), so they can be committed.
if [ "$scope" = project ] && git -C "${target%/.claude}" rev-parse --show-toplevel >/dev/null 2>&1; then
  repo="$(git -C "${target%/.claude}" rev-parse --show-toplevel)"; gi="$repo/.gitignore"
  for p in ".claude/skills/" ".claude/hooks/" ".claude/scripts/" ".claude/writing.md" ".claude/CLAUDE.md" ".claude/settings.json"; do
    git -C "$repo" check-ignore -q "${p%/}" 2>/dev/null || continue   # not ignored → skip
    grep -qxF "!$p" "$gi" 2>/dev/null && continue                      # already allowlisted
    printf '!%s\n' "$p" >> "$gi"
  done
  # 7. session state: <artifacts root>/session/ holds per-session files the
  # PreCompact hook and hand-off notes write (skills/dev/handoff.md); never
  # tracked, so the target's .gitignore takes the line (idempotent).
  art="$(cd "$repo" && bash "$SRC/scripts/ci/resolve-root.sh" 2>/dev/null)" || art=dev
  line="${art:+$art/}session/"
  grep -qxF "$line" "$gi" 2>/dev/null || printf '%s\n' "$line" >> "$gi"
fi

echo "install-dev: DEV toolset installed into $target ($scope)"
echo "install-dev: Tier-1 checks in $target/scripts/ci/ (check-code-size.sh, check-no-em-dash.sh, check-accretion.sh, check-batch-tags.sh)"
echo "install-dev: self-tests in $target/scripts/test/ - wire checks and self-tests into your CI"
