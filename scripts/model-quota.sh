#!/usr/bin/env bash
# model-quota.sh <display-name> - pre-flight gate for a model-pinned dispatch
# (R040-T015). Exit 0 while the model's weekly window has headroom, 1 at or
# over the ceiling, 2 when the answer is unknown. A caller treats 2 as 1:
# dispatching a pinned model wrongly stalls on a consent dialog, dispatching
# the fallback wrongly costs a weaker review.
#
# Claude Code offers no supported reader for this - `/usage` is interactive
# and the endpoint is labelled experimental in the binary - so every unknown
# fails closed rather than guessing.
set -uo pipefail

CEILING=80
ENDPOINT="https://api.anthropic.com/api/oauth/usage"

unknown() { printf 'model-quota: %s\n' "$1" >&2; return 2; }

# The access token only. The refresh token stays untouched: rotation is Claude
# Code's, and a script racing it can leave the session's credential unusable.
access_token() {
  local f="$HOME/.claude/.credentials.json" raw
  if [ -f "$f" ]; then
    raw=$(cat "$f")
  elif command -v security >/dev/null 2>&1; then
    raw=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null) \
      || { unknown "no Claude Code credential in the keychain"; return; }
  else
    unknown "no credential: $f absent and no keychain"; return
  fi
  local tok
  tok=$(jq -r '.claudeAiOauth.accessToken // empty' <<<"$raw" 2>/dev/null)
  [ -n "$tok" ] || { unknown "credential holds no access token"; return; }
  printf '%s' "$tok"
}

main() {
  local name="${1:-}"
  [ -n "$name" ] || { printf 'usage: model-quota.sh <display-name>\n' >&2; exit 2; }
  local tok
  tok=$(access_token) || return

  # Headers travel in a file: argv is visible to every process on the host.
  local hf resp rc status body
  hf=$(mktemp) || { unknown "cannot create the header file"; return; }
  trap 'rm -f "${hf:-}"' EXIT
  printf 'Authorization: Bearer %s\nanthropic-beta: oauth-2025-04-20\n' "$tok" > "$hf"
  # A hung endpoint must not hang the dispatch: the gate exists to remove stalls.
  resp=$(curl -s --max-time 15 -H "@$hf" -w '\n%{http_code}' "$ENDPOINT" 2>/dev/null); rc=$?
  rm -f "$hf"
  [ "$rc" -eq 0 ] || { unknown "usage endpoint unreachable (curl $rc)"; return; }
  status=${resp##*$'\n'}
  body=${resp%$'\n'*}
  [ "$status" = 200 ] || { unknown "usage endpoint answered $status"; return; }

  # The scoped entry is the only source: the plan-level seven_day_* fields are
  # null on this plan, and scope.model.id is null, so the server-supplied
  # display name is the only selector.
  local entry seen percent resets
  entry=$(jq -c --arg n "$name" '[.limits[]? | select(.scope.model.display_name == $n)][0] // empty' \
            <<<"$body" 2>/dev/null) || { unknown "usage body has an unexpected shape"; return; }
  if [ -z "$entry" ]; then
    seen=$(jq -r '[.limits[]?.scope.model.display_name // empty] | join(", ")' <<<"$body" 2>/dev/null)
    unknown "no weekly window scoped to $name (seen: ${seen:-none})"; return
  fi
  percent=$(jq -r '.percent // empty' <<<"$entry")
  resets=$(jq -r '.resets_at // "unknown"' <<<"$entry")
  case "$percent" in
    ''|.*|*[!0-9.]*) unknown "window for $name carries no usable percent"; return ;;
  esac
  printf '%s: %s%% of the weekly window used, resets %s\n' "$name" "$percent" "$resets"
  [ "${percent%.*}" -lt "$CEILING" ]
}

main "$@"
