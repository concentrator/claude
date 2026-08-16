#!/usr/bin/env bash
# Tests scripts/provision-worker.sh - the worker-host deploy + provision
# wrapper (R040-T010). Cases run the real script against fake SDK roots in
# throwaway dirs; nothing here contacts GCP.
# Run: bash scripts/test/provision-worker.test.sh
set -uo pipefail
SCRIPT="$(git rev-parse --show-toplevel)/scripts/provision-worker.sh"
# VM-side subcommands live in the counterpart script, split by execution context.
VMSCRIPT="$(git rev-parse --show-toplevel)/scripts/worker-setup.sh"
# $HOME-level subcommands live in the workspace script; system-level in VMSCRIPT.
WSSCRIPT="$(git rev-parse --show-toplevel)/scripts/worker-workspace.sh"
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

# --- deploy: command assembly (no GCP contact) -------------------------------

# A fake SDK whose gcloud records every invocation, so a case can assert both
# what was assembled and whether anything ran at all.
mkrecorder() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<EOF
#!/usr/bin/env bash
[ "\${1:-}" = version ] && { echo "Google Cloud SDK 580.0.0"; exit 0; }
printf '%s\n' "\$*" >> "$d/calls"
exit 0
EOF
  chmod +x "$d/bin/gcloud"; printf '%s' "$d"
}

deploy() { env PATH=/usr/bin:/bin "$@" bash "$SCRIPT" deploy --dry-run 2>&1; }

# 6. dry run assembles every verified parameter
r=$(mkrecorder)
out=$(deploy WORKER_SDK_ROOTS="$r")
miss=""
for f in "--project=poc-cloud-nodes" "--zone=europe-west2-a" \
         "--machine-type=e2-standard-4" "--image-family=debian-13" \
         "--image-project=debian-cloud" "--boot-disk-size=30GB" \
         "--boot-disk-type=pd-balanced" "--no-service-account" "--no-scopes" \
         "--tags=claude-worker" "serial-port-enable=TRUE" "enable-oslogin=TRUE"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss $f"
done
[ -z "$miss" ] && pass "dry run assembles the verified parameters" \
  || die "dry run missing:$miss"

# 7. dry run never invokes gcloud for the create - it prints only
[ ! -s "$r/calls" ] && pass "dry run runs no create" \
  || die "dry run invoked gcloud: $(cat "$r/calls")"
rm -rf "$r"

# 8. never provisions Spot or preemptible - a preempted worker loses its run
r=$(mkrecorder)
out=$(deploy WORKER_SDK_ROOTS="$r")
grep -qiE 'spot|preemptible' <<<"$out" \
  && die "dry run offers a preemptible instance" || pass "no Spot or preemptible"
rm -rf "$r"

# 9. overrides win over the defaults
r=$(mkrecorder)
out=$(deploy WORKER_SDK_ROOTS="$r" WORKER_ZONE=europe-west2-c WORKER_NAME=w2)
grep -qF -- "--zone=europe-west2-c" <<<"$out" && grep -qF -- " w2 " <<<" $out " \
  && pass "overrides win over defaults" || die "overrides ignored: $out"
rm -rf "$r"

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

# --- harden: host surface, and the firewall that must not lock us out -------

harden()   { env PATH=/usr/bin:/bin "$@" bash "$VMSCRIPT" harden --dry-run 2>&1; }
firewall() { env PATH=/usr/bin:/bin "$@" bash "$SCRIPT" firewall --dry-run 2>&1; }

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

# 16. firewall composes a tagged allow and a tagged deny, never touching the
#     shared default-allow-ssh other instances in the project depend on
r=$(mkrecorder); out=$(firewall WORKER_SDK_ROOTS="$r")
grep -q 'target-tags=claude-worker' <<<"$out" \
  && grep -q '35.235.240.0/20' <<<"$out" \
  && grep -qE 'action=DENY|--action DENY|deny' <<<"$out" \
  && ! grep -q 'firewall-rules delete' <<<"$out" \
  && pass "firewall composes tagged allow and deny" || die "firewall composition wrong: $out"

# 17. the IAP allow must outrank the deny. Lower number wins in GCP, so an
#     allow numbered above the deny locks the operator out of their own box -
#     the one ordering error this whole item exists to avoid.
allow_p=$(grep -o 'priority=[0-9]*' <<<"$out" | head -1 | cut -d= -f2)
deny_p=$(grep -o 'priority=[0-9]*' <<<"$out" | tail -1 | cut -d= -f2)
[ -n "$allow_p" ] && [ -n "$deny_p" ] && [ "$allow_p" -lt "$deny_p" ] \
  && pass "IAP allow outranks the deny" \
  || die "priority order unsafe: allow=$allow_p deny=$deny_p"

# 18. firewall dry run creates nothing
[ ! -s "$r/calls" ] && pass "firewall dry run creates nothing" \
  || die "firewall dry run called gcloud: $(cat "$r/calls")"
rm -rf "$r"

# --- tailscale + claude: install, then hand the SSO step back ---------------

ts() { env PATH=/usr/bin:/bin "$@" bash "$VMSCRIPT" tailscale-install --dry-run 2>&1; }
cc() { env PATH=/usr/bin:/bin "$@" bash "$VMSCRIPT" claude-install --dry-run 2>&1; }

# 25. tailscale install names the repo, the boot-persistence, and the handoff
out=$(ts)
miss=""
for f in "tailscale" "systemctl enable" "tailscale up" "browser"; do
  grep -qiF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "tailscale install names repo, boot and handoff" || die "tailscale missing:$miss"

# 26. it must not claim completion it cannot reach - SSO needs a human, so the
#     dry run has to say the run pauses rather than finishes
grep -qiE 'operator|pause|stop|hand' <<<"$out" && pass "tailscale defers to the operator" \
  || die "tailscale implies unattended completion: $out"

# 27. claude install verifies from a non-interactive shell, the context that
#     caught gcloud out
out=$(cc)
grep -qiF 'non-interactive' <<<"$out" && grep -qF 'claude --version' <<<"$out" \
  && pass "claude verified non-interactively" || die "claude verify weak: $out"

# 28. neither dry run installs anything
r=$(mktemp -d); mkdir -p "$r/bin"
printf '#!/usr/bin/env bash\nprintf "%%s\\n" "$*" >> %s/calls\n' "$r" > "$r/bin/apt-get"
chmod +x "$r/bin/apt-get"
env PATH="$r/bin:/usr/bin:/bin" bash "$VMSCRIPT" tailscale-install --dry-run >/dev/null 2>&1
env PATH="$r/bin:/usr/bin:/bin" bash "$VMSCRIPT" claude-install --dry-run >/dev/null 2>&1
[ ! -s "$r/calls" ] && pass "install dry runs change nothing" || die "dry run ran apt"
rm -rf "$r"

rm -rf "$h"

exit $fail
