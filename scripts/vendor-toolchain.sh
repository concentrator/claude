#!/usr/bin/env bash
# vendor-toolchain.sh — copy the portable DEV toolchain core into a target
# project's .claude/, per plans/R-015-embeddable-dev/manifest.md.
#
# Usage: vendor-toolchain.sh <target-dir> [--source <ref>]
#   <target-dir>   project root to embed into (its .claude/ is created)
#   --source <ref> toolchain ref to vendor from (default: current checkout)
set -euo pipefail

usage() { echo "usage: vendor-toolchain.sh <target-dir> [--source <ref>]" >&2; exit 2; }

target="${1:-}"; shift || true
[ -n "${target:-}" ] || usage

SRC="$(git rev-parse --show-toplevel)"
DEST="$target/.claude"

# Initial vendor only — refuse an already-embedded target (re-running would
# double-prefix namespaced skills). Update-in-place is re-vendor sync (T-033).
if [ -e "$DEST/.dev-toolchain.json" ]; then
  echo "error: $DEST already embeds the toolchain; updates are handled by re-vendor sync (T-033)" >&2
  exit 1
fi

mkdir -p "$DEST"

# --- copy the portable core (manifest.md) ---
# Tracked files only, so untracked wallarm-* skills are excluded inherently;
# js.md (project-specific) is pruned explicitly.
EXCLUDE_RE='^rules/js\.md$|^skills/wallarm-'
git -C "$SRC" ls-files rules skills | grep -vE "$EXCLUDE_RE" | while IFS= read -r f; do
  mkdir -p "$DEST/$(dirname "$f")"
  cp "$SRC/$f" "$DEST/$f"
done

# --- path rewrite: ~/.claude/ -> .claude/ (skip the illustrative example) ---
# Exclude by basename: the example's dir is renamed during namespacing below,
# so a full-path exclusion would go stale.
PROTECT="CLAUDE_MD_TESTING.md"
find "$DEST" -type f ! -name "$PROTECT" -print0 | while IFS= read -r -d '' f; do
  grep -q '~/\.claude/' "$f" 2>/dev/null || continue
  sed -i.bak 's|~/\.claude/|.claude/|g' "$f" && rm -f "$f.bak"
done

# --- dev-* namespacing: prefix every embedded skill except the `dev`
# orchestrator, and repoint references. Path refs are rewritten everywhere;
# backticked skill-name refs are rewritten too, except ambiguous tokens
# inside rules/ (`release` is also a branch-prefix token in git-workflow.md).
AMBIG=" release "
for name in $(ls "$DEST/skills" | grep -v '^dev$'); do
  find "$DEST" -type f ! -name "$PROTECT" -print0 | while IFS= read -r -d '' f; do
    sed -i.bak "s|\.claude/skills/${name}|.claude/skills/dev-${name}|g" "$f" && rm -f "$f.bak"
    case "$f" in "$DEST"/rules/*) [[ "$AMBIG" == *" ${name} "* ]] && continue ;; esac
    sed -i.bak "s|\`${name}\`|\`dev-${name}\`|g" "$f" && rm -f "$f.bak"
  done
  mv "$DEST/skills/$name" "$DEST/skills/dev-$name"
done

# --- emit a generic DEV CLAUDE.md backbone ---
# @-imports the always-on rules (no `paths:` frontmatter); path-scoped rules
# (planning, branch-plan, …) load on their own when matching files are edited.
{
  echo "# Project conventions"
  echo
  echo "Default mode is **VIBE** (freestyle). \`/dev\` enters spec-driven DEV"
  echo "mode. Skills live in \`.claude/skills/\` (\`dev-*\`); rules in"
  echo "\`.claude/rules/\`."
  echo
  echo "## Always-on rules"
  echo
  for r in "$DEST"/rules/*.md; do
    sed -n '1,6p' "$r" | grep -q '^paths:' || echo "@rules/$(basename "$r")"
  done
  echo
  echo "After cloning, run \`.claude/scripts/dev-embed-check.sh\` to confirm"
  echo "your global \`dev\` (if any) is embed-aware."
} > "$DEST/CLAUDE.md"

# --- ship the clone-time embed-host check ---
mkdir -p "$DEST/scripts"
cp "$SRC/scripts/dev-embed-check.sh" "$DEST/scripts/dev-embed-check.sh"
chmod +x "$DEST/scripts/dev-embed-check.sh"

# --- genericize repo-specific model routing in the copy (manifest transform) ---
# Replace the whole `## Models` section (repo model IDs + routing/effort prose)
# with an adopter slot, and neutralize the `B-003` batch evidence.
vp="$DEST/skills/dev-delegating-to-agents/verification-policy.md"
if [ -f "$vp" ]; then
  awk '
    /^## Models/ { print; print ""; print "Adopter slot: define a model-per-role routing table (dispatch values + effort) for this project."; skip=1; next }
    /^## / && skip { skip=0 }
    !skip { print }
  ' "$vp" > "$vp.tmp" && mv "$vp.tmp" "$vp"
  sed -i.bak 's/B-003/earlier batches/g' "$vp" && rm -f "$vp.bak"
fi

# --- version stamp / embed marker ---
# Records the source toolchain version (drift is measured against this by
# the re-vendor sync, T-033). Its presence marks an embedded project (T-032).
SRC_VER="$(git -C "$SRC" describe --tags --always 2>/dev/null || echo unknown)"
printf '{"source":"%s"}\n' "$SRC_VER" > "$DEST/.dev-toolchain.json"
