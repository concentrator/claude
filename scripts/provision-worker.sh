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

main() {
  case "${1:-}" in
    preflight) preflight ;;
    deploy)    shift; deploy "$@" ;;
    *) printf 'usage: provision-worker.sh preflight | deploy [--dry-run]\n' >&2; return 2 ;;
  esac
}

main "$@"
