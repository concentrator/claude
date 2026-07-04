#!/usr/bin/env bash
# install-dev.sh — install the DEV toolset into a target .claude.
#
# Usage:
#   install-dev.sh                 install into ~/.claude (global)
#   install-dev.sh --project <p>   install into <p>/.claude (project copy)
#
# Copies the /dev router + its companions, the bundled dependency skills,
# and the branch-guard hook, then registers the hook in the target
# settings.json (idempotent). Does NOT ship the user's personal convention
# rules. Re-runnable.
set -euo pipefail

SRC="$(git rev-parse --show-toplevel)"
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

# 3. branch-guard hook
cp "$SRC/hooks/dev-branch-guard.sh" "$target/hooks/dev-branch-guard.sh"
chmod +x "$target/hooks/dev-branch-guard.sh"

# 4. register the hook in settings.json (idempotent; preserve everything else)
if [ "$scope" = global ]; then cmd="~/.claude/hooks/dev-branch-guard.sh"; else cmd=".claude/hooks/dev-branch-guard.sh"; fi
settings="$target/settings.json"
[ -f "$settings" ] || echo '{}' > "$settings"
tmp="$(mktemp)"
jq --arg cmd "$cmd" '
  if ([.hooks.PreToolUse[]?.hooks[]?.command] | any(. == $cmd)) then .
  else .hooks.PreToolUse = ((.hooks.PreToolUse // []) + [
    {matcher: "Write|Edit|NotebookEdit", hooks: [{type: "command", command: $cmd}]},
    {matcher: "Bash", hooks: [{type: "command", command: $cmd}]}
  ]) end
' "$settings" > "$tmp" && mv "$tmp" "$settings"

echo "install-dev: DEV toolset installed into $target ($scope)"
