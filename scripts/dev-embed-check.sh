#!/usr/bin/env bash
# dev-embed-check.sh — run after cloning a project that embeds the DEV
# toolchain. Confirms the contributor's global `dev` skill (if any) can
# route /dev into this project's dev-* skills. Advisory; never fails.
#
# Run from the project root. Override the global location with
# DEV_GLOBAL_DIR (defaults to ~/.claude).
set -uo pipefail

if [ ! -e ".claude/.dev-toolchain.json" ]; then
  echo "not an embedded toolchain project (no .claude/.dev-toolchain.json)" >&2
  exit 0
fi

gdev="${DEV_GLOBAL_DIR:-$HOME/.claude}/skills/dev/SKILL.md"

if [ ! -f "$gdev" ]; then
  echo "info: no global \`dev\` skill — the embedded \`dev\` serves /dev here."
  exit 0
fi
if grep -q '<!-- dev-embed-aware -->' "$gdev"; then
  echo "ok: global \`dev\` is embed-aware; /dev routes into this project's dev-* skills."
  exit 0
fi
echo "warning: your global \`dev\` skill predates embedded-project support — update ~/.claude so /dev routes into this project's dev-* skills." >&2
exit 0
