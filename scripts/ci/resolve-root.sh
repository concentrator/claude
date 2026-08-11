#!/usr/bin/env bash
# Resolve the DEV artifacts root for the Tier-1 gates: the
# `- DEV artifacts root:` declaration in CLAUDE.md, absent -> dev/
# (skills/dev/plan.md § Where things live). Echoes the plans/ prefix
# the gates scan, relative to the repo top-level (cwd).
set -euo pipefail

root="$(sed -n 's/^- DEV artifacts root: *//p' CLAUDE.md 2>/dev/null | head -n1 || true)"
root="${root:-dev/}"
root="${root%/}"
if [[ "$root" == "." || -z "$root" ]]; then
  echo "plans"
else
  echo "$root/plans"
fi
