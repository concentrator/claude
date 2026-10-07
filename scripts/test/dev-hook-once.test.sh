#!/usr/bin/env bash
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
HOOKS="$(git rev-parse --show-toplevel)/hooks"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

AKIA_PREFIX="AKIA"
FAKE_AWS="${AKIA_PREFIX}IOSFODNN7EXAMPLE"

M=$(mktemp -d); H=$(mktemp -d); PD=$(mktemp -d); trap 'rm -rf "$M" "$H" "$PD"' EXIT
git -c init.defaultBranch=main -C "$M" init -q
git -C "$M" config user.email t@e >/dev/null; git -C "$M" config user.name t >/dev/null
printf 'clean\n' > "$M/tracked.sh"
git -C "$M" add tracked.sh; git -C "$M" commit -qm init >/dev/null
cd "$M"

jb=$(jq -nc --arg c "git commit -m $FAKE_AWS" '{tool_name:"Bash",tool_input:{command:$c}}')
jw=$(jq -nc --arg p "$M/tracked.sh" --arg c "k=$FAKE_AWS" '{tool_name:"Write",tool_input:{file_path:$p,content:$c}}')
je=$(jq -nc --arg p "$M/tracked.sh" --arg c "k=$FAKE_AWS" '{tool_name:"Edit",tool_input:{file_path:$p,new_string:$c}}')

global_runs() { jq -n --arg m "$1" --arg c "$2" '{hooks:{PreToolUse:[{matcher:$m,hooks:[{type:"command",command:$c}]}]}}' > "$H/.claude/settings.json"; }
runh() {
  local out; out=$(printf '%s' "$2" | HOME="$H" bash "$1" 2>&1)
  if [ -z "$out" ]; then echo silent; elif grep -q '"permissionDecision":"deny"' <<<"$out"; then echo deny; else echo other; fi
}

for name in dev-branch-guard.sh dev-secrets-guard.sh; do
  rm -rf "$H/.claude" "$PD/.claude"
  mkdir -p "$H/.claude/hooks" "$PD/.claude/hooks"
  for d in "$H/.claude/hooks" "$PD/.claude/hooks"; do
    cp "$HOOKS/$name" "$HOOKS/secret-patterns.sh" "$HOOKS/dev-hook-once.sh" "$d/"
  done
  p="$PD/.claude/hooks/$name" g="$H/.claude/hooks/$name"

  global_runs Bash "~/.claude/hooks/$name"
  [ "$(runh "$p" "$jb")" = silent ] && pass "$name: project copy silent when the global settings run it for Bash" || die "$name: project copy acted beside the global registration"
  [ "$(runh "$p" "$jw")" = deny ] && pass "$name: project copy acts for a tool the global matcher misses" || die "$name: project copy skipped a Write the global matcher misses"
  [ "$(runh "$g" "$jb")" = deny ] && pass "$name: global copy acts on its own registration" || die "$name: global copy skipped itself"

  global_runs "Write|Edit|NotebookEdit" "$H/.claude/hooks/$name"
  [ "$(runh "$p" "$jw")" = silent ] && [ "$(runh "$p" "$je")" = silent ] && pass "$name: expanded global path counts as the global hook" || die "$name: expanded global path not recognised"
  [ "$(runh "$p" "$jb")" = deny ] && pass "$name: Bash acts under a Write-only global matcher" || die "$name: Bash skipped under a Write-only global matcher"

  global_runs Bash "~/.claude/hooks/dev-other.sh"
  [ "$(runh "$p" "$jb")" = deny ] && pass "$name: another hook's global registration does not silence it" || die "$name: silenced by another hook's registration"

  rm -f "$H/.claude/settings.json"
  [ "$(runh "$p" "$jb")" = deny ] && pass "$name: project copy acts with no global settings" || die "$name: project copy skipped with no global settings"

  printf '{"hooks":' > "$H/.claude/settings.json"
  [ "$(runh "$p" "$jb")" = deny ] && pass "$name: project copy acts on unparsable global settings" || die "$name: project copy skipped on unparsable global settings"

  global_runs Bash "~/.claude/hooks/$name"
  rm -f "$PD/.claude/hooks/dev-hook-once.sh"
  [ "$(runh "$p" "$jb")" = deny ] && pass "$name: project copy acts without its run-once helper" || die "$name: project copy skipped without its run-once helper"
done

(( fail == 0 )) && echo "dev-hook-once.test: OK"
exit $fail
