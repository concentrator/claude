#!/usr/bin/env bash
# Tests scripts/worker-setup.sh - the system-level half of the worker host:
# packages, swap, timezone, and the surface hardening. Split from
# provision-worker.test.sh, which keeps the operator-side script, so each
# suite covers one execution surface.
# Run: bash scripts/test/worker-setup.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
VMSCRIPT="$(git rev-parse --show-toplevel)/scripts/worker-setup.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# --- baseline: host preparation, composed on the VM --------------------------

baseline() { env PATH=/usr/bin:/bin "$@" bash "$VMSCRIPT" baseline --dry-run 2>&1; }

# 10. dry run names every package and change the host needs
out=$(baseline)
miss=""
for f in "nodejs" "jq" "tmux" "git" "swapfile" "timedatectl" "/opt/wallarm"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss $f"
done
[ -z "$miss" ] && pass "baseline dry run names each change" || die "baseline missing:$miss"

# 11. Node comes from NodeSource, not the distro - trixie ships one older than
#     the >=22 the projects require
grep -qi 'nodesource' <<<"$out" && pass "node installs from NodeSource" \
  || die "no NodeSource in baseline: $out"

# 12. dry run mutates nothing
r=$(mktemp -d); mkdir -p "$r/bin"
cat > "$r/bin/apt-get" <<EOF
#!/usr/bin/env bash
printf '%s\\n' "\$*" >> "$r/calls"
EOF
chmod +x "$r/bin/apt-get"
env PATH="$r/bin:/usr/bin:/bin" bash "$VMSCRIPT" baseline --dry-run >/dev/null 2>&1
[ ! -s "$r/calls" ] && pass "baseline dry run installs nothing" \
  || die "baseline dry run called apt: $(cat "$r/calls")"
rm -rf "$r"

# 13. swap tracks memory but is capped - it is OOM insurance for ~1 GB
#     sessions, not hibernation space, and an uncapped rule ate 16 GB of a
#     30 GB disk on the real host
mi=$(mktemp)
printf 'MemTotal:        2097152 kB\n' > "$mi"; small=$(baseline WORKER_MEMINFO="$mi")
printf 'MemTotal:       16777216 kB\n' > "$mi"; large=$(baseline WORKER_MEMINFO="$mi")
grep -q '2048 MB' <<<"$small" && pass "swap tracks memory below the cap" \
  || die "small host swap wrong: $(grep -o '[0-9]* MB' <<<"$small")"
grep -q '4096 MB' <<<"$large" && pass "swap is capped on a large host" \
  || die "large host swap uncapped: $(grep -o '[0-9]* MB' <<<"$large")"
rm -f "$mi"

# --- harden: the host surface an inventory actually found --------------------

harden() { env PATH=/usr/bin:/bin "$@" bash "$VMSCRIPT" harden --dry-run 2>&1; }

# 14. harden names each surface the inventory actually found on the host
out=$(harden)
miss=""
for f in "exim4" "5355" "PasswordAuthentication no" "PermitRootLogin no" \
         "nftables" "unattended-upgrades"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "harden names each found surface" || die "harden missing:$miss"

# 15. harden dry run mutates nothing
r=$(mktemp -d); mkdir -p "$r/bin"
printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$*" >> %s/calls\n' "$r" > "$r/bin/apt-get"
chmod +x "$r/bin/apt-get"
env PATH="$r/bin:/usr/bin:/bin" bash "$VMSCRIPT" harden --dry-run >/dev/null 2>&1
[ ! -s "$r/calls" ] && pass "harden dry run changes nothing" || die "harden dry run ran apt"
rm -rf "$r"

# --- claude install: the SSO handoff and the PATH trap ----------------------

cc() { env PATH=/usr/bin:/bin "$@" bash "$VMSCRIPT" claude-install --dry-run 2>&1; }

# 27. claude install verifies from a non-interactive shell, the context that
#     caught gcloud out
out=$(cc)
grep -qiF 'non-interactive' <<<"$out" && grep -qF 'claude --version' <<<"$out" \
  && pass "claude verified non-interactively" || die "claude verify weak: $out"

# 28. the dry run installs nothing
r=$(mktemp -d); mkdir -p "$r/bin"
printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$*" >> %s/calls\n' "$r" > "$r/bin/apt-get"
chmod +x "$r/bin/apt-get"
env PATH="$r/bin:/usr/bin:/bin" bash "$VMSCRIPT" claude-install --dry-run >/dev/null 2>&1
[ ! -s "$r/calls" ] && pass "install dry runs change nothing" || die "dry run ran apt"
rm -rf "$r"

exit $fail
