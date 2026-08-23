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

# Runs on the OPERATOR's machine, and finishes the exchange `worker-credentials.sh
# keys` starts on the VM: that step can generate a key but not install it,
# because the forge credentials are the operator's. Retirement has no other
# owner at all - a key titled claude-worker that no longer matches the host is
# standing access for a machine that has been deleted, and nothing on the new
# host would ever notice it.
keys_install() {
  local dry=0
  [ "${1:-}" = "--dry-run" ] && dry=1
  local g; g=$(resolve_gcloud) || return 1
  local glhost="${WORKER_GITLAB_HOST:-gl.wallarm.com}"

  local c
  for c in gh glab; do
    command -v "$c" >/dev/null 2>&1 || {
      printf 'keys-install: %s not found on this machine\n' "$c" >&2; return 1; }
  done

  local forge host key material listed present stale id title mat rc=0
  for forge in github gitlab; do
    case "$forge" in github) host=github.com ;; gitlab) host="$glhost" ;; esac

    key=$(vm_pubkey "$g" "$forge") || { rc=1; continue; }
    material=$(awk '{print $2}' <<<"$key")
    listed=$(forge_keys "$forge" "$glhost") || { rc=1; continue; }

    # Match on the base64 field alone. Titles and trailing comments differ
    # between what the host generated and what each forge stores, so that
    # field is the only part that identifies a key across both.
    present=no; stale=""
    while IFS=$'\t' read -r id title mat; do
      [ -n "$id" ] || continue
      [ "$mat" = "$material" ] && { present=yes; continue; }
      case "$title" in claude-worker*) stale="$stale $id" ;; esac
    done <<<"$listed"

    if [ "$present" = yes ]; then
      printf '%s: claude-worker-%s already installed\n' "$host" "$forge"
    elif [ "$dry" -eq 1 ]; then
      printf '%s: would add the host key as claude-worker-%s\n' "$host" "$forge"
    else
      forge_add "$forge" "$glhost" "$key" "claude-worker-$forge" \
        && printf '%s: installed claude-worker-%s\n' "$host" "$forge" || rc=1
    fi

    for id in $stale; do
      if [ "$dry" -eq 1 ]; then
        printf '%s: would retire key %s - titled claude-worker, matches no key on the host\n' "$host" "$id"
      else
        forge_api "$forge" "$glhost" --method DELETE "user/keys/$id" >/dev/null \
          && printf '%s: retired key %s\n' "$host" "$id" || rc=1
      fi
    done
  done
  return $rc
}

# Read one public key off the host. Read-only, so a dry run does it too: what
# the run would change depends on which keys are already on each forge.
vm_pubkey() {
  local g="$1" forge="$2" name="${WORKER_NAME:-claude-worker}" out
  out=$("$g" compute ssh "$name" \
    --zone="${WORKER_ZONE:-europe-west2-a}" --project="${WORKER_PROJECT:-poc-cloud-nodes}" \
    --tunnel-through-iap --quiet --command="cat ~/.ssh/id_ed25519_$forge.pub" 2>/dev/null \
    | grep -m1 '^ssh-')
  [ -n "$out" ] || {
    printf 'keys-install: no %s key on %s - run worker-credentials.sh keys there first\n' \
      "$forge" "$name" >&2; return 1; }
  printf '%s' "$out"
}

# One API call to a forge, host-pinned. `glab` takes its host from the current
# directory's git remote and falls back to gitlab.com everywhere else, so an
# unpinned call sends a gl.wallarm.com token to the wrong server and the
# failure reads as a token problem (`companions/pitfalls.md`).
forge_api() {
  local forge="$1" glhost="$2"; shift 2
  case "$forge" in
    github) gh api "$@" ;;
    gitlab) GITLAB_HOST="$glhost" glab api "$@" ;;
  esac
}

# id, title and key material for every key on the forge, one per line.
forge_keys() {
  local forge="$1" glhost="$2" json
  json=$(forge_api "$forge" "$glhost" --paginate user/keys 2>&1) || {
    printf 'keys-install: listing %s keys failed. Output:\n%s\n' "$forge" "$json" >&2; return 1; }
  jq -r '.[] | [(.id|tostring), .title, (.key|split(" ")[1])] | @tsv' <<<"$json" 2>/dev/null || {
    printf 'keys-install: %s key listing was not a key list. Output:\n%s\n' "$forge" "$json" >&2
    return 1; }
}

# GitHub takes a key file, GitLab takes API fields. Both titles carry the
# forge name, which is what makes a key retirable later.
forge_add() {
  local forge="$1" glhost="$2" key="$3" title="$4" f st
  case "$forge" in
    github)
      f=$(mktemp); printf '%s\n' "$key" > "$f"
      gh ssh-key add "$f" --title "$title"; st=$?
      rm -f "$f"; return $st ;;
    gitlab)
      forge_api gitlab "$glhost" --method POST user/keys \
        --raw-field "title=$title" --raw-field "key=$key" >/dev/null ;;
  esac
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
    firewall)  shift; firewall "$@" ;;
    keys-install) shift; keys_install "$@" ;;
    *) printf 'usage: provision-worker.sh preflight | deploy | firewall | keys-install [--dry-run]\n' >&2; return 2 ;;
  esac
}

main "$@"
