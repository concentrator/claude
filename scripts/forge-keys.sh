#!/usr/bin/env bash
# forge-keys.sh - the operator's half of the worker's forge key exchange
# (R040-T010). Sourced by provision-worker.sh, which sits beside it and owns
# the subcommand surface; not runnable on its own. Split out because the GCP
# instance and the two forges are separate systems reached with separate
# credentials, and each half now fits one file. Tests: provision-keys.test.sh.

# Finishes the exchange `worker-credentials.sh keys` starts on the VM: that step can generate a key but not install it,
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
