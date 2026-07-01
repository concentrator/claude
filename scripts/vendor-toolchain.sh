#!/usr/bin/env bash
# vendor-toolchain.sh — copy the portable DEV toolchain core into a target
# project's .claude/, per plans/R-015-embeddable-dev/manifest.md.
#
# Usage: vendor-toolchain.sh <target-dir> [--update] [--source <ref>]
#   <target-dir>   project root to embed into (its .claude/ is created)
#   --update       re-vendor an already-embedded target in place (T-033)
#   --source <ref> toolchain ref to vendor from (default: current checkout)
set -euo pipefail

usage() { echo "usage: vendor-toolchain.sh <target-dir> [--update] [--source <ref>]" >&2; exit 2; }

target=""; update=0
while [ $# -gt 0 ]; do
  case "$1" in
    --update) update=1 ;;
    --source) shift ;;            # reserved; vendor uses the current checkout
    -*) usage ;;
    *) target="$1" ;;
  esac
  shift
done
[ -n "$target" ] || usage

SRC="$(git rev-parse --show-toplevel)"
DEST="$target/.claude"

# Re-running would double-prefix namespaced skills, so a bare re-run is
# refused; --update first removes the vendor-managed footprint (below).
embedded=0; [ -e "$DEST/.dev-toolchain.json" ] && embedded=1
if [ "$embedded" -eq 1 ] && [ "$update" -eq 0 ]; then
  echo "error: $DEST already embeds the toolchain; re-vendor with --update" >&2
  exit 1
fi

mkdir -p "$DEST"

# --- update mode: remove the vendor-managed footprint, preserving adopter
# content (their own rules/skills/plans) and CLAUDE.md (handled at emit). ---
if [ "$embedded" -eq 1 ]; then
  git -C "$SRC" ls-files rules | grep -vE '^rules/js' | while IFS= read -r f; do rm -f "$DEST/$f"; done
  rm -rf "$DEST/skills/dev" "$DEST"/skills/dev-* "$DEST/scripts/ci"
  rm -f "$DEST/scripts/dev-embed-check.sh" "$DEST/.dev-toolchain.json"
fi

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
# Only the vendored skills (from the source) are namespaced — never an
# adopter's own skills that may sit alongside them (matters on --update).
AMBIG=" release "
SKILL_NAMES=$(git -C "$SRC" ls-files skills | grep -vE '^skills/wallarm-' | sed -E 's#^skills/([^/]+).*#\1#' | sort -u | grep -v '^dev$')
for name in $SKILL_NAMES; do
  find "$DEST" -type f ! -name "$PROTECT" -print0 | while IFS= read -r -d '' f; do
    sed -i.bak "s|\.claude/skills/${name}|.claude/skills/dev-${name}|g" "$f" && rm -f "$f.bak"
    case "$f" in "$DEST"/rules/*) [[ "$AMBIG" == *" ${name} "* ]] && continue ;; esac
    sed -i.bak "s|\`${name}\`|\`dev-${name}\`|g" "$f" && rm -f "$f.bak"
  done
  mv "$DEST/skills/$name" "$DEST/skills/dev-$name"
  # the `name:` frontmatter must match the new dir (else it collides with a
  # global same-named skill and dispatch breaks on dir ≠ name)
  sed -i.bak "s|^name: ${name}\$|name: dev-${name}|" "$DEST/skills/dev-$name/SKILL.md" \
    && rm -f "$DEST/skills/dev-$name/SKILL.md.bak"
done

# --- emit a generic DEV CLAUDE.md backbone (preserve an existing one) ---
# @-imports the always-on rules (no `paths:` frontmatter); path-scoped rules
# (planning, branch-plan, …) load on their own when matching files are edited.
emit_backbone() {
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
}
if [ -e "$DEST/CLAUDE.md" ]; then
  emit_backbone > "$DEST/CLAUDE.md.new"
  if cmp -s "$DEST/CLAUDE.md" "$DEST/CLAUDE.md.new"; then
    rm -f "$DEST/CLAUDE.md.new"      # identical — nothing to merge
  else
    echo "note: existing CLAUDE.md preserved; review $DEST/CLAUDE.md.new for backbone changes" >&2
  fi
else
  emit_backbone > "$DEST/CLAUDE.md"
fi

# --- ship the clone-time embed-host check ---
mkdir -p "$DEST/scripts"
cp "$SRC/scripts/dev-embed-check.sh" "$DEST/scripts/dev-embed-check.sh"
chmod +x "$DEST/scripts/dev-embed-check.sh"

# --- ship the embedded CI subset: 3 portable checks + a ledger-free,
# .claude/-rooted run-all (stray/todos are self-hosting/repo-scoped — excluded).
mkdir -p "$DEST/scripts/ci"
for c in check-caps check-plan-integrity check-references; do
  cp "$SRC/scripts/ci/$c.sh" "$DEST/scripts/ci/$c.sh"
  chmod +x "$DEST/scripts/ci/$c.sh"
done
{
  echo '#!/usr/bin/env bash'
  echo '# Embedded Tier-1 gate — portable checks, .claude/-rooted, no ledger.'
  echo 'set -uo pipefail'
  echo 'cd "$(git rev-parse --show-toplevel)"'
  echo 'export CLAUDE_ROOT=.claude'
  echo 'fail=0'
  echo 'for c in caps plan-integrity references; do'
  echo '  echo "== check-$c =="'
  echo '  bash ".claude/scripts/ci/check-$c.sh" || fail=1'
  echo 'done'
  echo '(( fail == 0 )) && echo "run-all: ALL OK"'
  echo 'exit $fail'
} > "$DEST/scripts/ci/run-all.sh"
chmod +x "$DEST/scripts/ci/run-all.sh"

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
