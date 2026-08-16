#!/usr/bin/env bash
# Tests scripts/provision-worker.sh - the worker-host deploy + provision
# wrapper (R040-T010). Cases run the real script against fake SDK roots in
# throwaway dirs; nothing here contacts GCP.
# Run: bash scripts/test/provision-worker.test.sh
set -uo pipefail
SCRIPT="$(git rev-parse --show-toplevel)/scripts/provision-worker.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# A fake SDK root whose gcloud answers `version`, as a healthy install does.
mkroot() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<'EOF'
#!/usr/bin/env bash
[ "${1:-}" = version ] && { echo "Google Cloud SDK 580.0.0"; exit 0; }
exit 0
EOF
  chmod +x "$d/bin/gcloud"; printf '%s' "$d"
}

# A fake root whose gcloud is present but dies - the stale-install shape,
# where presence must not be read as health.
mkbroken() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<'EOF'
#!/usr/bin/env bash
echo "ModuleNotFoundError: No module named 'imp'" >&2; exit 1
EOF
  chmod +x "$d/bin/gcloud"; printf '%s' "$d"
}

# Run preflight with PATH stripped of any real gcloud, so only what a case
# injects can be found.
preflight() { env PATH=/usr/bin:/bin "$@" bash "$SCRIPT" preflight 2>&1; }

# 1. resolves a gcloud that is on PATH
r=$(mkroot)
out=$(env PATH="$r/bin:/usr/bin:/bin" bash "$SCRIPT" preflight 2>&1)
[ $? -eq 0 ] && grep -q "$r/bin/gcloud" <<<"$out" \
  && pass "resolves gcloud from PATH" || die "PATH resolution failed: $out"
rm -rf "$r"

# 2. resolves via CLOUDSDK_ROOT_DIR when not on PATH
r=$(mkroot)
out=$(preflight CLOUDSDK_ROOT_DIR="$r")
[ $? -eq 0 ] && grep -q "$r/bin/gcloud" <<<"$out" \
  && pass "resolves via CLOUDSDK_ROOT_DIR" || die "root-dir resolution failed: $out"
rm -rf "$r"

# 3. resolves from a standard root when PATH and env give nothing - the real
#    case, where the SDK is sourced only from an interactive .zshrc
r=$(mkroot)
out=$(preflight HOME="$(dirname "$r")" WORKER_SDK_ROOTS="$r")
[ $? -eq 0 ] && grep -q "$r/bin/gcloud" <<<"$out" \
  && pass "resolves from a standard root" || die "standard-root resolution failed: $out"
rm -rf "$r"

# 4. absent everywhere -> fails naming what was searched
out=$(preflight WORKER_SDK_ROOTS="/nonexistent/sdk")
[ $? -ne 0 ] && grep -q '/nonexistent/sdk' <<<"$out" \
  && pass "absent SDK fails naming the search" || die "absent SDK not reported: $out"

# 5. present but broken -> fails; presence is not health
r=$(mkbroken)
out=$(preflight WORKER_SDK_ROOTS="$r")
[ $? -ne 0 ] && grep -qi 'not run\|failed' <<<"$out" \
  && pass "broken SDK fails despite being present" || die "broken SDK passed: $out"
rm -rf "$r"

exit $fail
