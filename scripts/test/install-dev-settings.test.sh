#!/usr/bin/env bash
# Tests what scripts/install-dev.sh writes to the target's settings.json and
# CLAUDE.md: a settings.json holding every toolset entry keeps its bytes, a
# write only adds a missing entry or drops a retired one, and CLAUDE.md only
# gains an import line.
# Run: bash scripts/test/install-dev-settings.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
cd "$(git rev-parse --show-toplevel)"

INSTALL="$PWD/scripts/install-dev.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }
same() { [ "$(jq -S . "$1")" = "$(jq -S . "$2")" ]; }   # equal JSON values, formatting aside

P=$(mktemp -d); C="$P/.claude"; mkdir -p "$C"
printf '{"model":"x","hooks":{"PostToolUse":[{"matcher":"Skill","hooks":[{"type":"command","command":"echo hi"}]}]}}\n' > "$C/settings.json"
bash "$INSTALL" --project "$P" >/dev/null 2>&1 || die "install exits nonzero"
cp "$C/settings.json" "$P/registered.json"

# --- registered settings, custom-formatted and holding a user entry with no
# hooks, survive a re-install byte-identical ---
jq --tab '{hooks: (.hooks | .PreToolUse += [{matcher: "Read", hooks: []}]), model}' "$P/registered.json" > "$C/settings.json"
printf '# Mine\n\nkeep this\n\n@writing.md\n' > "$C/CLAUDE.md"
cp "$C/settings.json" "$P/custom.json"; cp "$C/CLAUDE.md" "$P/claude.before"
bash "$INSTALL" --project "$P" >/dev/null 2>&1 || die "re-install exits nonzero"
cmp -s "$C/settings.json" "$P/custom.json" && pass "registered custom-formatted settings.json survives a re-install byte-identical" \
  || die "re-install rewrote settings.json: $(diff "$P/custom.json" "$C/settings.json" | head -5)"
cmp -s "$C/CLAUDE.md" "$P/claude.before" && pass "a CLAUDE.md importing writing.md survives a re-install byte-identical" \
  || die "re-install rewrote CLAUDE.md"

# --- a missing toolset entry is added back, nothing else changed ---
jq '.hooks.UserPromptSubmit = []' "$P/registered.json" > "$C/settings.json"
bash "$INSTALL" --project "$P" >/dev/null 2>&1 && same "$C/settings.json" "$P/registered.json" \
  && pass "a missing toolset entry is added, the rest unchanged" || die "missing entry: $(jq -c .hooks.UserPromptSubmit "$C/settings.json")"

# --- a retired entry is dropped, its event's other entries kept ---
jq '.hooks.Stop = [{hooks: [{type: "command", command: "~/.claude/hooks/dev-context-fill.sh"}, {type: "command", command: "echo bye"}]}, {hooks: []}]' \
  "$P/registered.json" > "$C/settings.json"
jq '.hooks.Stop = [{hooks: [{type: "command", command: "echo bye"}]}, {hooks: []}]' "$P/registered.json" > "$P/want.json"
bash "$INSTALL" --project "$P" >/dev/null 2>&1 && same "$C/settings.json" "$P/want.json" \
  && pass "a retired entry is dropped, the rest unchanged" || die "retired entry: $(jq -c .hooks.Stop "$C/settings.json")"

# --- CLAUDE.md without the import only gains the import line ---
printf '# Mine\n\nkeep this' > "$C/CLAUDE.md"
bash "$INSTALL" --project "$P" >/dev/null 2>&1 && [ "$(cat "$C/CLAUDE.md")" = "$(printf '# Mine\n\nkeep this\n@writing.md')" ] \
  && pass "CLAUDE.md gains only the import line" || die "CLAUDE.md: $(cat "$C/CLAUDE.md")"
rm -rf "$P"

(( fail == 0 )) && echo "install-dev-settings.test: OK"
exit $fail
