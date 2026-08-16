#!/usr/bin/env bash
# worker-setup.sh - prepare a Claude Code worker host, run ON the VM
# (R040-T010). Its counterpart scripts/provision-worker.sh runs on the
# operator's machine and creates the instance; this file never needs gcloud.
# Split by execution context, not by size: a step that assumes the wrong
# machine fails confusingly, and the boundary is the plan's own.
set -uo pipefail

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
    "apt-get install -y nftables, default-deny inbound except loopback, established and SSH"
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
# Runs ON the VM. Install, then an SSO handoff the operator completes.
claude_install() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  if [ "$dry" -eq 1 ]; then
    printf 'claude-install would:\n'
    printf '  - install the Claude Code client\n'
    printf '  - verify with claude --version from a non-interactive shell, the\n'
    printf '    context a supervisor dispatches into; an installer that edits\n'
    printf '    only an interactive rc leaves it invisible there, and the\n'
    printf '    failure reads as "not installed" rather than "not on PATH"\n'
    printf '  - start SSO login and PAUSE for the operator to complete it\n'
    return 0
  fi

  command -v claude >/dev/null 2>&1 || curl -fsSL https://claude.ai/install.sh | bash
  local c; c=$(command -v claude 2>/dev/null || echo "$HOME/.local/bin/claude")
  [ -x "$c" ] || { printf 'claude-install: not found after install\n' >&2; return 1; }

  # The installer puts claude in ~/.local/bin and adds it to an interactive
  # profile. Debian's ~/.bashrc returns before that on a non-interactive shell,
  # which is precisely how a supervisor dispatches (`ssh host command`), so the
  # binary would be invisible exactly where it is needed. Export it above the
  # interactivity guard.
  if ! grep -q 'claude-worker PATH' "$HOME/.bashrc" 2>/dev/null; then
    printf '%s\n%s\n' '# claude-worker PATH - before the non-interactive guard below' \
      'case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) PATH="$HOME/.local/bin:$PATH" ;; esac' \
      | cat - "$HOME/.bashrc" > "$HOME/.bashrc.new" && mv "$HOME/.bashrc.new" "$HOME/.bashrc"
  fi

  printf 'claude: %s (%s)\n' "$c" "$("$c" --version 2>&1 | head -1)"
  printf 'claude: authenticate by running `claude` once and completing SSO\n'
}

main() {
  case "${1:-}" in
    baseline)          shift; baseline "$@" ;;
    harden)            shift; harden "$@" ;;
    claude-install)    shift; claude_install "$@" ;;
    *) printf 'usage: worker-setup.sh baseline | harden | claude-install [--dry-run]\n' >&2; return 2 ;;
  esac
}

main "$@"
