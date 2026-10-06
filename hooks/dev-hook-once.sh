#!/usr/bin/env bash

global_hook_runs() {
  local self global name settings="$HOME/.claude/settings.json"
  self=$(cd "$(dirname -- "$1")" 2>/dev/null && pwd -P) || return 1
  global=$(cd "$HOME/.claude/hooks" 2>/dev/null && pwd -P)
  [ "$self" != "$global" ] || return 1
  [ -f "$settings" ] && command -v jq >/dev/null 2>&1 || return 1
  name=$(basename -- "$1")
  jq -e --arg event "$2" --arg subject "$3" \
    --arg short "~/.claude/hooks/$name" --arg long "$HOME/.claude/hooks/$name" '
    [(.hooks[$event] // [])[]
      | (.matcher // "") as $m
      | select($m == "" or $m == "*" or (try ($subject | test("^(?:" + $m + ")$")) catch false))
      | .hooks[]?.command]
    | any(. == $short or . == $long)
  ' "$settings" >/dev/null 2>&1
}
