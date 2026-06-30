#!/usr/bin/env bash
# dev-drift-check.sh <embedded-project> — report whether a project's
# embedded toolchain lags this source checkout. Run from the toolchain repo.
# Override the source version with DEV_SRC_VER (default: git describe here).
set -uo pipefail

proj="${1:-}"
[ -n "$proj" ] || { echo "usage: dev-drift-check.sh <embedded-project>" >&2; exit 2; }

stamp="$proj/.claude/.dev-toolchain.json"
[ -f "$stamp" ] || { echo "unknown: no toolchain stamp at $stamp"; exit 0; }

emb=$(sed -n 's/.*"source":"\([^"]*\)".*/\1/p' "$stamp")
[ -n "$emb" ] || { echo "unknown: stamp has no source"; exit 0; }

cur="${DEV_SRC_VER:-$(git describe --tags --always 2>/dev/null || echo unknown)}"

if [ "$emb" = "$cur" ]; then
  echo "up-to-date: $emb"
else
  echo "stale: embedded $emb, source $cur — re-vendor with: vendor-toolchain.sh --update $proj"
fi
