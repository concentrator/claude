#!/usr/bin/env bash
# Tests scripts/provision-worker.sh keys-install - the operator's half of the
# forge key exchange. Split from provision-worker.test.sh, which keeps the
# instance and firewall subcommands, so neither suite outgrows the size gate.
# Nothing here contacts GCP or a forge.
# Run: bash scripts/test/provision-keys.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

# A mirror of /usr/bin and /bin with gcloud left out: every tool the script
# needs, and no real SDK for it to find behind the fixtures' backs.
HERMETIC=$(mktemp -d)
for f in /usr/bin/* /bin/*; do
  b=${f##*/}
  [ "$b" = gcloud ] && continue
  ln -s "$f" "$HERMETIC/$b" 2>/dev/null
done
trap 'rm -rf "$HERMETIC"' EXIT
SCRIPT="$(git rev-parse --show-toplevel)/scripts/provision-worker.sh"
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# A fake operator toolchain: a gcloud that hands back the host's public keys
# over the tunnel, plus gh and glab CLIs that record every call and answer a
# key listing from a fixture. Recording is the point - it is what lets a case
# assert that a dry run installed nothing and that a real run deleted only the
# keys it was entitled to.
mkforge() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<EOF
#!/usr/bin/env bash
[ "\${1:-}" = version ] && { echo "Google Cloud SDK 580.0.0"; exit 0; }
printf 'gcloud %s\n' "\$*" >> "$d/calls"
[ -n "\${FAKE_NO_KEYS:-}" ] && exit 0
case "\$*" in
  *id_ed25519_github*) echo "ssh-ed25519 AAAAHOSTGITHUB claude-worker-github" ;;
  *id_ed25519_gitlab*) echo "ssh-ed25519 AAAAHOSTGITLAB claude-worker-gitlab" ;;
esac
exit 0
EOF
  cat > "$d/bin/gh" <<EOF
#!/usr/bin/env bash
printf 'gh %s\n' "\$*" >> "$d/calls"
case "\$*" in
  *"ssh-key add"*|*DELETE*) exit 0 ;;
esac
cat "$d/github.json"
EOF
  cat > "$d/bin/glab" <<EOF
#!/usr/bin/env bash
printf 'glab GITLAB_HOST=\${GITLAB_HOST:-unset} %s\n' "\$*" >> "$d/calls"
case "\$*" in
  *POST*|*DELETE*) exit 0 ;;
esac
cat "$d/gitlab.json"
EOF
  chmod +x "$d/bin"/gcloud "$d/bin"/gh "$d/bin"/glab
  printf '[]' > "$d/github.json"; printf '[]' > "$d/gitlab.json"
  # An empty log rather than none, so a case asserting "nothing ran" reads a
  # real file instead of passing on a missing one.
  : > "$d/calls"
  printf '%s' "$d"
}

ki() { local d="$1"; shift; env PATH="$d/bin:$HERMETIC" "$@" bash "$SCRIPT" keys-install 2>&1; }

# 32. the dry run names both forges, the titles it would install under, and the
#     pinned GitLab host - and installs nothing
d=$(mkforge)
out=$(env PATH="$d/bin:$HERMETIC" bash "$SCRIPT" keys-install --dry-run 2>&1)
miss=""
for f in "claude-worker-github" "claude-worker-gitlab" "gl.wallarm.com"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "keys-install dry run names both forges" || die "keys-install missing:$miss"
grep -qE 'ssh-key add|POST|DELETE' "$d/calls" \
  && die "keys-install dry run changed a forge: $(cat "$d/calls")" \
  || pass "keys-install dry run changes nothing"
rm -rf "$d"

# 33. a key already on the forge is not added a second time. Re-running against
#     a provisioned host is the normal case, and gh rejects a duplicate key
#     outright, so a blind add turns a no-op into a failure.
d=$(mkforge)
printf '[{"id":1,"title":"claude-worker-github","key":"ssh-ed25519 AAAAHOSTGITHUB"}]' > "$d/github.json"
printf '[{"id":11,"title":"claude-worker-gitlab","key":"ssh-ed25519 AAAAHOSTGITLAB c"}]' > "$d/gitlab.json"
out=$(ki "$d")
grep -qE 'ssh-key add|POST' "$d/calls" && die "re-run added an installed key: $(cat "$d/calls")" \
  || pass "an installed key is not added again"
grep -q DELETE "$d/calls" && die "re-run deleted the current key: $(cat "$d/calls")" \
  || pass "the current key is never retired"
rm -rf "$d"

# 34. a previous host's key is retired, and nothing else is. A key titled
#     claude-worker that no longer matches the host is standing access for a
#     machine that is gone; a key with any other title belongs to a human and
#     deleting it locks them out of their own account.
d=$(mkforge)
printf '[{"id":1,"title":"claude-worker-github","key":"ssh-ed25519 AAAAOLDHOST"},{"id":2,"title":"laptop","key":"ssh-ed25519 AAAALAPTOP"}]' > "$d/github.json"
printf '[{"id":11,"title":"claude-worker-gitlab","key":"ssh-ed25519 AAAAOLDHOST"},{"id":12,"title":"laptop","key":"ssh-ed25519 AAAALAPTOP"}]' > "$d/gitlab.json"
out=$(ki "$d")
grep -q 'DELETE user/keys/1$' "$d/calls" && grep -q 'DELETE user/keys/11$' "$d/calls" \
  && pass "stale worker keys are retired" || die "stale keys kept: $(cat "$d/calls")"
grep -qE 'DELETE user/keys/(2|12)$' "$d/calls" \
  && die "keys-install deleted a key it does not own: $(cat "$d/calls")" \
  || pass "keys with other titles are untouched"
grep -q 'ssh-key add' "$d/calls" && grep -q 'POST' "$d/calls" \
  && pass "the current key is installed on both forges" || die "no install: $(cat "$d/calls")"

# 35. every GitLab call is host-pinned - unpinned, the token goes to gitlab.com
grep -q 'GITLAB_HOST=unset' "$d/calls" && die "an unpinned glab call was made: $(cat "$d/calls")" \
  || pass "every glab call pins the host"
rm -rf "$d"

# 36. a host with no keys yet fails pointing at the step that makes them,
#     rather than installing an empty string as a key
d=$(mkforge)
out=$(ki "$d" FAKE_NO_KEYS=1)
[ $? -ne 0 ] && grep -qF 'worker-credentials.sh keys' <<<"$out" \
  && pass "a keyless host names the step that fixes it" || die "keyless host mishandled: $out"
grep -qE 'ssh-key add|POST' "$d/calls" && die "installed a key from a keyless host" \
  || pass "nothing is installed from a keyless host"
rm -rf "$d"

exit $fail
