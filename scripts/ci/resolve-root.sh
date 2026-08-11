#!/usr/bin/env bash
# Resolve the DEV artifacts root for the Tier-1 gates: the
# `- DEV artifacts root:` declaration in CLAUDE.md, absent -> dev
# (skills/dev/plan.md § Where things live). Echoes the normalized root
# relative to the repo top-level (cwd) - empty for the repo root;
# callers append their subdir (e.g. plans/) and guard the call.
set -euo pipefail

root="$(sed -n 's/^- DEV artifacts root:[[:space:]]*//p' CLAUDE.md 2>/dev/null | head -n1 | sed -e 's/[[:space:][:cntrl:]]*$//' || true)"
root="${root:-dev}"
root="${root%/}"
root="${root#./}"
if [[ "$root" == "." ]]; then root=""; fi
echo "$root"
