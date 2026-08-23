#!/usr/bin/env bash
# Tests scripts/provision-worker.sh - the worker-host deploy + provision
# wrapper (R040-T010). Cases run the real script against fake SDK roots in
# throwaway dirs; nothing here contacts GCP.
# Run: bash scripts/test/provision-worker.test.sh
set -uo pipefail
# Never inherit a git environment - see scripts/test/isolation.test.sh.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE

# Most cases exercise resolve_gcloud's fallbacks, which only run when PATH
# holds no gcloud. A host that has one - a CI runner with /usr/bin/gcloud, say -
# satisfies the PATH branch first, so the fixtures below would go unexercised
# while still reporting ok. Cases therefore run under a mirror of /usr/bin and
# /bin with gcloud left out: every tool a script needs, no SDK to find.
HERMETIC=$(mktemp -d)
for f in /usr/bin/* /bin/*; do
  b=${f##*/}
  [ "$b" = gcloud ] && continue
  ln -s "$f" "$HERMETIC/$b" 2>/dev/null
done
trap 'rm -rf "$HERMETIC"' EXIT
SCRIPT="$(git rev-parse --show-toplevel)/scripts/provision-worker.sh"
# VM-side subcommands live in the counterpart scripts, each with its own suite:
# worker-setup.test.sh for system-level, worker-workspace.test.sh for $HOME.
fail=0
pass() { echo "ok - $1"; }
die()  { echo "not ok - $1"; fail=1; }

# A fake SDK root whose gcloud answers `version`, as a healthy install does.
mkroot() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<'EOF'
#!/usr/bin/env bash
[ "${1:-}" = version ] && { echo "Google Cloud SDK 580.0.0"; exit 0; }
exit 0
EOF
  chmod +x "$d/bin/gcloud"; printf '%s' "$d"
}

# A fake root whose gcloud is present but dies - the stale-install shape,
# where presence must not be read as health.
mkbroken() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<'EOF'
#!/usr/bin/env bash
echo "ModuleNotFoundError: No module named 'imp'" >&2; exit 1
EOF
  chmod +x "$d/bin/gcloud"; printf '%s' "$d"
}

# Run preflight with PATH stripped of any real gcloud, so only what a case
# injects can be found.
preflight() { env PATH="$HERMETIC" "$@" bash "$SCRIPT" preflight 2>&1; }

# 1. resolves a gcloud that is on PATH
r=$(mkroot)
out=$(env PATH="$r/bin:$HERMETIC" bash "$SCRIPT" preflight 2>&1)
[ $? -eq 0 ] && grep -q "$r/bin/gcloud" <<<"$out" \
  && pass "resolves gcloud from PATH" || die "PATH resolution failed: $out"
rm -rf "$r"

# 2. resolves via CLOUDSDK_ROOT_DIR when not on PATH
r=$(mkroot)
out=$(preflight CLOUDSDK_ROOT_DIR="$r")
[ $? -eq 0 ] && grep -q "$r/bin/gcloud" <<<"$out" \
  && pass "resolves via CLOUDSDK_ROOT_DIR" || die "root-dir resolution failed: $out"
rm -rf "$r"

# 3. resolves from a standard root when PATH and env give nothing - the real
#    case, where the SDK is sourced only from an interactive .zshrc
r=$(mkroot)
out=$(preflight HOME="$(dirname "$r")" WORKER_SDK_ROOTS="$r")
[ $? -eq 0 ] && grep -q "$r/bin/gcloud" <<<"$out" \
  && pass "resolves from a standard root" || die "standard-root resolution failed: $out"
rm -rf "$r"

# 4. absent everywhere -> fails naming what was searched
out=$(preflight WORKER_SDK_ROOTS="/nonexistent/sdk")
[ $? -ne 0 ] && grep -q '/nonexistent/sdk' <<<"$out" \
  && pass "absent SDK fails naming the search" || die "absent SDK not reported: $out"

# 5. present but broken -> fails; presence is not health
r=$(mkbroken)
out=$(preflight WORKER_SDK_ROOTS="$r")
[ $? -ne 0 ] && grep -qi 'not run\|failed' <<<"$out" \
  && pass "broken SDK fails despite being present" || die "broken SDK passed: $out"
rm -rf "$r"

# --- deploy: command assembly (no GCP contact) -------------------------------

# A fake SDK whose gcloud records every invocation, so a case can assert both
# what was assembled and whether anything ran at all.
mkrecorder() {
  local d; d=$(mktemp -d); mkdir -p "$d/bin"
  cat > "$d/bin/gcloud" <<EOF
#!/usr/bin/env bash
[ "\${1:-}" = version ] && { echo "Google Cloud SDK 580.0.0"; exit 0; }
printf '%s\n' "\$*" >> "$d/calls"
exit 0
EOF
  chmod +x "$d/bin/gcloud"; printf '%s' "$d"
}

deploy() { env PATH="$HERMETIC" "$@" bash "$SCRIPT" deploy --dry-run 2>&1; }

# 6. dry run assembles every verified parameter
r=$(mkrecorder)
out=$(deploy WORKER_SDK_ROOTS="$r")
miss=""
for f in "--project=poc-cloud-nodes" "--zone=europe-west2-a" \
         "--machine-type=e2-standard-4" "--image-family=debian-13" \
         "--image-project=debian-cloud" "--boot-disk-size=30GB" \
         "--boot-disk-type=pd-balanced" "--no-service-account" "--no-scopes" \
         "--tags=claude-worker" "serial-port-enable=TRUE" "enable-oslogin=TRUE"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss $f"
done
[ -z "$miss" ] && pass "dry run assembles the verified parameters" \
  || die "dry run missing:$miss"

# 7. dry run never invokes gcloud for the create - it prints only
[ ! -s "$r/calls" ] && pass "dry run runs no create" \
  || die "dry run invoked gcloud: $(cat "$r/calls")"
rm -rf "$r"

# 8. never provisions Spot or preemptible - a preempted worker loses its run
r=$(mkrecorder)
out=$(deploy WORKER_SDK_ROOTS="$r")
grep -qiE 'spot|preemptible' <<<"$out" \
  && die "dry run offers a preemptible instance" || pass "no Spot or preemptible"
rm -rf "$r"

# 9. overrides win over the defaults
r=$(mkrecorder)
out=$(deploy WORKER_SDK_ROOTS="$r" WORKER_ZONE=europe-west2-c WORKER_NAME=w2)
grep -qF -- "--zone=europe-west2-c" <<<"$out" && grep -qF -- " w2 " <<<" $out " \
  && pass "overrides win over defaults" || die "overrides ignored: $out"
rm -rf "$r"

# --- firewall: the rules that must not lock us out ---------------------------

firewall() { env PATH="$HERMETIC" "$@" bash "$SCRIPT" firewall --dry-run 2>&1; }

# 16. firewall composes a tagged allow and a tagged deny, never touching the
#     shared default-allow-ssh other instances in the project depend on
r=$(mkrecorder); out=$(firewall WORKER_SDK_ROOTS="$r")
grep -q 'target-tags=claude-worker' <<<"$out" \
  && grep -q '35.235.240.0/20' <<<"$out" \
  && grep -qE 'action=DENY|--action DENY|deny' <<<"$out" \
  && ! grep -q 'firewall-rules delete' <<<"$out" \
  && pass "firewall composes tagged allow and deny" || die "firewall composition wrong: $out"

# 17. the IAP allow must outrank the deny. Lower number wins in GCP, so an
#     allow numbered above the deny locks the operator out of their own box -
#     the one ordering error this whole item exists to avoid.
allow_p=$(grep -o 'priority=[0-9]*' <<<"$out" | head -1 | cut -d= -f2)
deny_p=$(grep -o 'priority=[0-9]*' <<<"$out" | tail -1 | cut -d= -f2)
[ -n "$allow_p" ] && [ -n "$deny_p" ] && [ "$allow_p" -lt "$deny_p" ] \
  && pass "IAP allow outranks the deny" \
  || die "priority order unsafe: allow=$allow_p deny=$deny_p"

# 18. firewall dry run creates nothing
[ ! -s "$r/calls" ] && pass "firewall dry run creates nothing" \
  || die "firewall dry run called gcloud: $(cat "$r/calls")"
rm -rf "$r"

# --- keys-install: the operator's half of the key exchange -------------------

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
