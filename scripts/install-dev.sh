#!/usr/bin/env bash
# install-dev.sh — install the DEV toolset into a target .claude.
#
# Usage:
#   install-dev.sh                 install into ~/.claude (global)
#   install-dev.sh --project <p>   install into <p>/.claude (project copy)
#
# Copies the /dev router + its companions, the bundled dependency skills, the
# branch-guard + secrets-guard hooks (registered in the target settings.json),
# the code-size check, and the writing conventions (@imported by CLAUDE.md).
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

register_hook dev-branch-guard.sh
register_hook dev-secrets-guard.sh

# 4. code-size check + a template allowlist (adopters wire it into their CI).
#    Ship a fresh allowlist only when absent, so re-install never clobbers an
#    adopter's own exemptions.
mkdir -p "$target/scripts/ci"
cp "$SRC/scripts/ci/check-code-size.sh" "$target/scripts/ci/check-code-size.sh"
chmod +x "$target/scripts/ci/check-code-size.sh"
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
fi

echo "install-dev: DEV toolset installed into $target ($scope)"
echo "install-dev: code-size gate at $target/scripts/ci/check-code-size.sh (wire it into your CI)"
