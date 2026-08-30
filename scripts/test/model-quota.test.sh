#!/usr/bin/env bash
# Tests scripts/model-quota.sh - the pre-flight gate for a model-pinned
# dispatch. The usage endpoint and the credential store are stubbed on PATH;
# the shape they return is the one the plan probed (R040-T015).
# Run: bash scripts/test/model-quota.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
SCRIPT="$(git rev-parse --show-toplevel)/scripts/model-quota.sh"
# A mirror of /usr/bin and /bin with curl and security left out, so the script
# can only reach the fixtures.
HERMETIC=$(mktemp -d)
for f in /usr/bin/* /bin/*; do
  b=${f##*/}
  case "$b" in curl|security) continue ;; esac
  ln -s "$f" "$HERMETIC/$b" 2>/dev/null
done
LEAKS=$(mktemp)
trap 'rm -rf "$HERMETIC" "$LEAKS"' EXIT
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# A fixture: $HOME with a credentials file, a curl that logs its argv, copies
# the header file it is handed, and answers from body/status, and a security
# that answers the keychain query from keychain.json.
fixture() {
  local d; d=$(mktemp -d)
  mkdir -p "$d/bin" "$d/home/.claude"
  printf '{"claudeAiOauth":{"accessToken":"fixtureleakcanary","refreshToken":"fixturerefreshcanary"}}\n' \
    > "$d/home/.claude/.credentials.json"
  cat > "$d/bin/curl" <<STUB
#!/usr/bin/env bash
printf '%s\n' "\$*" >> "$d/calls"
while [ \$# -gt 0 ]; do
  case "\$1" in -H) [ "\${2#@}" != "\$2" ] && cat "\${2#@}" >> "$d/headers"; shift ;; esac
  shift
done
[ "\$(cat "$d/curlrc")" = 0 ] || exit "\$(cat "$d/curlrc")"
cat "$d/body"; printf '\n%s\n' "\$(cat "$d/status")"
STUB
  cat > "$d/bin/security" <<STUB
#!/usr/bin/env bash
printf 'security %s\n' "\$*" >> "$d/calls"
cat "$d/keychain.json"
STUB
  chmod +x "$d/bin/curl" "$d/bin/security"
  : > "$d/calls"; : > "$d/headers"
  printf '200' > "$d/status"; printf '0' > "$d/curlrc"
  printf '%s' "$d"
}
window() {  # <display-name> <percent>
  printf '{"seven_day_opus":null,"limits":[{"scope":{"model":{"id":null,"display_name":"%s"}},"percent":%s,"severity":"ok","resets_at":"2026-08-31T00:00:00Z","is_active":true}]}' \
    "$1" "$2"
}
# Every run's output is screened for a credential value, whichever path it took.
gate() {
  local out rc
  out=$(env PATH="$1/bin:$HERMETIC" HOME="$1/home" bash "$SCRIPT" "Fable" 2>&1); rc=$?
  grep -q 'canary' <<<"$out" && printf '%s\n' "$out" >> "$LEAKS"
  printf '%s' "$out"; return $rc
}

# 1. headroom below the ceiling exits 0 and reports the window
d=$(fixture); window "Fable" 42 > "$d/body"
out=$(gate "$d"); rc=$?
[ "$rc" -eq 0 ] && grep -q '42' <<<"$out" \
  && pass "headroom exits 0 and reports the percent" || die "headroom rc=$rc: $out"

# 2. the token reaches the request in a header file and nowhere else: argv is
#     visible to every process on the host, and output lands in transcripts
grep -q 'Bearer fixtureleakcanary' "$d/headers" && pass "token sent as a bearer header" \
  || die "no bearer header: $(cat "$d/headers")"
grep -q 'fixtureleakcanary' "$d/calls" && die "token in curl argv: $(cat "$d/calls")" \
  || pass "token never in argv"

# 3. the refresh token is Claude Code's to rotate; the script never reads it
grep -q 'fixturerefreshcanary' "$d/headers" "$d/calls" && die "refresh token used" \
  || pass "refresh token untouched"

# 4. the beta header and the endpoint the probe recorded
grep -q 'anthropic-beta: oauth-2025-04-20' "$d/headers" && grep -q 'api.anthropic.com/api/oauth/usage' "$d/calls" \
  && pass "request matches the probed shape" || die "request shape: $(cat "$d/calls" "$d/headers")"
rm -rf "$d"

# 5. at the ceiling, and over it, exit 1 - the caller dispatches the fallback;
#     the endpoint may answer with a float, and the boundary holds either way
for p in 80 80.0 97; do
  d=$(fixture); window "Fable" "$p" > "$d/body"
  out=$(gate "$d"); rc=$?
  [ "$rc" -eq 1 ] && pass "$p percent exits 1" || die "$p percent rc=$rc: $out"
  rm -rf "$d"
done
d=$(fixture); window "Fable" 79.9 > "$d/body"
out=$(gate "$d"); rc=$?
[ "$rc" -eq 0 ] && pass "79.9 percent exits 0" || die "79.9 percent rc=$rc: $out"
rm -rf "$d"

# 6. with no credentials file, the macOS keychain item is the credential
d=$(fixture); rm "$d/home/.claude/.credentials.json"
printf '{"claudeAiOauth":{"accessToken":"fixtureleakcanary"}}\n' > "$d/keychain.json"
window "Fable" 10 > "$d/body"
out=$(gate "$d"); rc=$?
[ "$rc" -eq 0 ] && grep -q 'security find-generic-password' "$d/calls" \
  && grep -q 'Claude Code-credentials' "$d/calls" && grep -q 'Bearer fixtureleakcanary' "$d/headers" \
  && pass "keychain item read when the file is absent" || die "keychain path rc=$rc: $out $(cat "$d/calls")"
rm -rf "$d"

# 7. every unknown fails closed: exit 2 and one line on stderr naming why. A
#     caller treats 2 as 1, so the cost of a wrong answer stays on the cheap side.
unknown() {  # <label> <fixture>
  local out rc
  out=$(gate "$2"); rc=$?
  [ "$rc" -eq 2 ] && [ "$(wc -l <<<"$out")" -eq 1 ] && grep -q '^model-quota: ' <<<"$out" \
    && pass "$1 exits 2 with one reason" || die "$1 rc=$rc: $out"
}
d=$(fixture); rm "$d/home/.claude/.credentials.json"; rm "$d/bin/security"
window "Fable" 10 > "$d/body"
unknown "absent credential" "$d"
[ ! -s "$d/calls" ] && pass "no request without a credential" || die "requested anyway: $(cat "$d/calls")"
rm -rf "$d"

d=$(fixture); window "Fable" 10 > "$d/body"; printf '401' > "$d/status"
unknown "non-200 answer" "$d"; rm -rf "$d"

d=$(fixture); window "Opus 5" 10 > "$d/body"
unknown "absent scoped entry" "$d"; rm -rf "$d"

d=$(fixture); printf '<html>maintenance</html>' > "$d/body"
unknown "unparseable body" "$d"; rm -rf "$d"

d=$(fixture); printf '{"claudeAiOauth":{"refreshToken":"fixturerefreshcanary"}}' > "$d/home/.claude/.credentials.json"
unknown "credential without an access token" "$d"; rm -rf "$d"

d=$(fixture); printf '7' > "$d/curlrc"
unknown "unreachable endpoint" "$d"; rm -rf "$d"

d=$(fixture); window "Fable" '"n/a"' > "$d/body"
unknown "non-numeric percent" "$d"; rm -rf "$d"

# 8. an absent entry names what the endpoint did return, so a renamed model
#     reads as a wrong selector rather than an outage
d=$(fixture); window "Opus 5" 10 > "$d/body"
out=$(gate "$d")
grep -q 'seen: Opus 5' <<<"$out" && pass "absent entry lists the names seen" || die "names not listed: $out"
rm -rf "$d"

# 9. no run on any path printed a credential value
[ ! -s "$LEAKS" ] && pass "no credential value printed on any path" || die "credential printed: $(cat "$LEAKS")"

exit $fail
