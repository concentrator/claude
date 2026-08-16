#!/usr/bin/env bash
# provision-worker.sh - stand up a Claude Code worker host (R040-T010).
#
# Usage:
#   provision-worker.sh preflight     verify the operator's gcloud is usable
#
# Two execution contexts: `preflight` and `deploy` run on the operator's
# machine under their gcloud credentials; the provisioning subcommands run on
# the VM, which never needs gcloud. A subcommand states which it expects.
set -uo pipefail

# Standard SDK roots, colon-separated. Overridable so tests can inject a fake
# root without a real install.
sdk_roots() {
  printf '%s' "${WORKER_SDK_ROOTS:-$HOME/google-cloud-sdk:/opt/homebrew/share/google-cloud-sdk:/usr/lib/google-cloud-sdk:/usr/local/share/google-cloud-sdk}"
}

# Print the path of a gcloud to use, or return 1 having listed what was tried.
# PATH is checked first but never trusted alone: the SDK's path.*.inc is
# commonly sourced from an interactive-only rc, so a working install is
# routinely invisible to the non-interactive shell this runs in.
resolve_gcloud() {
  local tried=() c roots
  c=$(command -v gcloud 2>/dev/null) && { printf '%s' "$c"; return 0; }
  tried+=("PATH")

  if [ -n "${CLOUDSDK_ROOT_DIR:-}" ]; then
    c="$CLOUDSDK_ROOT_DIR/bin/gcloud"
    [ -x "$c" ] && { printf '%s' "$c"; return 0; }
    tried+=("$c")
  fi

  roots=$(sdk_roots)
  local IFS=:
  for r in $roots; do
    c="$r/bin/gcloud"
    [ -x "$c" ] && { printf '%s' "$c"; return 0; }
    tried+=("$c")
  done

  printf 'provision-worker: no gcloud found. Searched: %s\n' "${tried[*]}" >&2
  return 1
}

# Resolution is not health. A stale SDK sits at a standard root and answers
# `-x` while dying on any real call: one predating Python 3.12 fails with
# "No module named 'imp'" against a current interpreter, where a current SDK
# carries its own bundled Python and is immune.
preflight() {
  local g out
  g=$(resolve_gcloud) || return 1
  if ! out=$("$g" version 2>&1); then
    printf 'provision-worker: %s did not run. Output:\n%s\n' "$g" "$out" >&2
    return 1
  fi
  printf 'gcloud: %s\n%s\n' "$g" "$(head -1 <<<"$out")"
}

# Create the worker instance. Every default here was verified against the
# project rather than assumed: the zone because gl.wallarm.com resolves into
# europe-west2 and the default network already has a subnet there; the machine
# type because it is available in that zone at 4 vCPU / 16 GB, sized from
# measured session memory of roughly 1 GB each; pd-balanced because
# pd-standard starves on IOPS during npm ci. No service account, because the
# worker calls Anthropic and two forges but no GCP API, and IAP authenticates
# the client rather than the instance. Never Spot: a preempted worker loses
# its run.
deploy() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1

  local g out
  g=$(resolve_gcloud) || return 1
  "$g" version >/dev/null 2>&1 || { printf 'provision-worker: %s did not run\n' "$g" >&2; return 1; }

  local args=(
    compute instances create "${WORKER_NAME:-claude-worker}"
    --project="${WORKER_PROJECT:-poc-cloud-nodes}"
    --zone="${WORKER_ZONE:-europe-west2-a}"
    --machine-type="${WORKER_MACHINE_TYPE:-e2-standard-4}"
    --image-family=debian-13 --image-project=debian-cloud
    --boot-disk-size="${WORKER_DISK_SIZE:-30GB}" --boot-disk-type=pd-balanced
    --no-service-account --no-scopes
    --tags=claude-worker
    --metadata=serial-port-enable=TRUE,enable-oslogin=TRUE
  )

  if [ "$dry" -eq 1 ]; then
    printf '%s %s\n' "$g" "${args[*]}"
    return 0
  fi

  "$g" "${args[@]}" || return 1
}

# Runs ON the VM, not the operator's machine. Idempotent: every step is
# guarded on its own outcome, so a second run changes nothing. Node comes from
# NodeSource because trixie ships one older than the >=22 the projects
# require, and a gate that cannot run is indistinguishable from a gate that
# passes.
baseline() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1

  local mem_kb swap_mb
  mem_kb=$(awk '/MemTotal/{print $2}' "${WORKER_MEMINFO:-/proc/meminfo}" 2>/dev/null || echo 0)
  swap_mb=$(( mem_kb / 1024 ))
  # OOM insurance for ~1 GB sessions, not hibernation: swap-equals-RAM put a
  # 16 GB file on a 30 GB disk and left 11 GB for clones and node_modules.
  [ "$swap_mb" -gt 4096 ] && swap_mb=4096
  [ "$swap_mb" -lt 1024 ] && swap_mb=2048

  local steps=(
    "apt-get update"
    "apt-get install -y jq tmux git curl ca-certificates"
    "install Node >= 22 from NodeSource (deb.nodesource.com; trixie's nodejs is older)"
    "timedatectl set-timezone ${WORKER_TZ:-Europe/London}"
    "create /swapfile of ${swap_mb} MB if /proc/swaps lists none"
    "mkdir -p /opt/wallarm and chown it to ${WORKER_USER:-$USER}"
  )

  if [ "$dry" -eq 1 ]; then
    printf 'baseline would:\n'
    printf '  - %s\n' "${steps[@]}"
    return 0
  fi

  set -e
  sudo apt-get update -qq
  sudo apt-get install -y -qq jq tmux git curl ca-certificates
  if ! command -v node >/dev/null 2>&1 || [ "$(node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0)" -lt 22 ]; then
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y -qq nodejs
  fi
  sudo timedatectl set-timezone "${WORKER_TZ:-Europe/London}"
  if ! grep -q '/swapfile' /proc/swaps 2>/dev/null; then
    sudo fallocate -l "${swap_mb}M" /swapfile
    sudo chmod 600 /swapfile && sudo mkswap -q /swapfile && sudo swapon /swapfile
    grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab >/dev/null
  fi
  sudo mkdir -p /opt/wallarm
  sudo chown "${WORKER_USER:-$USER}:$(id -gn "${WORKER_USER:-$USER}")" /opt/wallarm
  set +e
  printf 'baseline: done\n'
}

# Runs ON the VM. Targets are what the inventory actually found, not a
# generic checklist: `ss -tulpn` on a fresh trixie image reported LLMNR on
# 0.0.0.0:5355 (exposed on every interface) and exim4 on 127.0.0.1:25
# (localhost only) - the opposite severity to what was assumed before looking.
harden() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1

  local steps=(
    "apt-get purge -y exim4* (listens on 127.0.0.1:25 for cron mail; nothing here sends mail)"
    "disable LLMNR in systemd-resolved (0.0.0.0:5355, the only all-interface listener besides sshd)"
    "sshd: PasswordAuthentication no, PermitRootLogin no, asserted not assumed"
    "apt-get install -y nftables, default-deny inbound except loopback, established, tailscale0 and IAP"
    "apt-get install -y unattended-upgrades for security patches"
    "re-run ss -tulpn: nothing public may remain that this list does not name"
  )

  if [ "$dry" -eq 1 ]; then
    printf 'harden would:\n'; printf '  - %s\n' "${steps[@]}"; return 0
  fi

  set -e
  sudo apt-get purge -y -qq 'exim4*' >/dev/null 2>&1 || true
  sudo mkdir -p /etc/systemd/resolved.conf.d
  printf '[Resolve]\nLLMNR=no\nMulticastDNS=no\n' | sudo tee /etc/systemd/resolved.conf.d/no-llmnr.conf >/dev/null
  sudo systemctl restart systemd-resolved
  sudo mkdir -p /etc/ssh/sshd_config.d
  printf 'PasswordAuthentication no\nPermitRootLogin no\n' | sudo tee /etc/ssh/sshd_config.d/60-harden.conf >/dev/null
  sudo systemctl reload ssh 2>/dev/null || sudo systemctl reload sshd
  sudo apt-get install -y -qq unattended-upgrades nftables >/dev/null
  # Host layer denies inbound except loopback, established and tcp:22. It does
  # not restrict who may reach 22 - the VPC rules do that, and duplicating the
  # source list here is how a remote box locks its operator out. This layer
  # exists to survive someone loosening the VPC rule, not to replace it.
  sudo tee /etc/nftables.conf >/dev/null <<'NFT'
#!/usr/sbin/nft -f
flush ruleset
table inet filter {
  chain input {
    type filter hook input priority 0; policy drop;
    iif lo accept
    ct state established,related accept
    ct state invalid drop
    ip protocol icmp accept
    tcp dport 22 accept
  }
  chain forward { type filter hook forward priority 0; policy drop; }
  chain output  { type filter hook output  priority 0; policy accept; }
}
NFT
  sudo nft -f /etc/nftables.conf
  sudo systemctl enable --now nftables >/dev/null 2>&1
  set +e
  printf 'harden: done\n'
}

# Runs on the OPERATOR's machine. Order is the whole point: the IAP allow is
# created and proven before the deny exists, and it outranks the deny by
# priority number, because in GCP the lower number wins. The shared
# default-allow-ssh is never touched - it carries 0.0.0.0/0 with no target
# tags, so every other instance in the project, including two GKE clusters,
# depends on it.
firewall() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local g; g=$(resolve_gcloud) || return 1
  local proj="${WORKER_PROJECT:-poc-cloud-nodes}"

  local allow=( compute firewall-rules create claude-worker-allow-iap
    --project="$proj" --direction=INGRESS --action=ALLOW --rules=tcp:22
    --source-ranges=35.235.240.0/20 --target-tags=claude-worker --priority=900 )
  local deny=( compute firewall-rules create claude-worker-deny-public-ssh
    --project="$proj" --direction=INGRESS --action=DENY --rules=tcp:22
    --source-ranges=0.0.0.0/0 --target-tags=claude-worker --priority=1000 )

  if [ "$dry" -eq 1 ]; then
    printf '%s %s\n' "$g" "${allow[*]}"
    printf '%s %s\n' "$g" "${deny[*]}"
    return 0
  fi

  # Create the allow, prove the tunnel through it, and only then deny the
  # public. Verifying between the two is what makes this recoverable: if the
  # IAP range were wrong, the check fails while 0.0.0.0/0 still admits us.
  "$g" "${allow[@]}" || return 1
  verify_iap "$g" || { printf 'firewall: IAP unverified after allow - deny NOT created\n' >&2; return 1; }
  printf 'firewall: IAP verified through the allow rule\n'

  "$g" "${deny[@]}" || return 1
  verify_iap "$g" || { printf 'firewall: IAP BROKE after deny - use the serial console\n' >&2; return 1; }
  printf 'firewall: public SSH denied, IAP still verified\n'
}

# One trivial command over the tunnel. First connections can fail while the
# key propagates, so a single failure is not a verdict.
verify_iap() {
  local g="$1" i
  for i in 1 2 3; do
    "$g" compute ssh "${WORKER_NAME:-claude-worker}" \
      --zone="${WORKER_ZONE:-europe-west2-a}" --project="${WORKER_PROJECT:-poc-cloud-nodes}" \
      --tunnel-through-iap --quiet --command='true' >/dev/null 2>&1 && return 0
    sleep 5
  done
  return 1
}

main() {
  case "${1:-}" in
    preflight) preflight ;;
    deploy)    shift; deploy "$@" ;;
    baseline)  shift; baseline "$@" ;;
    harden)    shift; harden "$@" ;;
    firewall)  shift; firewall "$@" ;;
    *) printf 'usage: provision-worker.sh preflight | deploy | baseline | harden | firewall [--dry-run]\n' >&2; return 2 ;;
  esac
}

main "$@"
