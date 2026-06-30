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

mkdir -p "$DEST"
