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
  chmod +x "$d/bin/gcloud"
  # An empty log rather than none, so a case asserting "nothing ran" reads a
  # real file instead of passing on a missing one.
  : > "$d/calls"
  printf '%s' "$d"
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

# --- push-scripts: getting the VM-side scripts onto a bare host --------------

push() { env PATH="$HERMETIC" WORKER_SDK_ROOTS="$1" bash "$SCRIPT" push-scripts 2>&1; }

# 37. the dry run names every script it would stage and where, and copies
#     nothing. All three are needed: steps 3 to 7 all run on the VM before the
#     config repo that is their permanent home has been cloned.
r=$(mkrecorder)
out=$(env PATH="$HERMETIC" WORKER_SDK_ROOTS="$r" bash "$SCRIPT" push-scripts --dry-run 2>&1)
miss=""
for f in "worker-setup.sh" "worker-credentials.sh" "worker-workspace.sh" \
         ".worker-bootstrap" "claude-worker"; do
  grep -qF -- "$f" <<<"$out" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "push-scripts dry run names what it would stage" \
  || die "push-scripts dry run missing:$miss"
[ ! -s "$r/calls" ] && pass "push-scripts dry run copies nothing" \
  || die "push-scripts dry run called gcloud: $(cat "$r/calls")"
rm -rf "$r"

# 38. a real run copies all three and makes them executable there. Presence is
#     not usability: a file arriving without its executable bit fails at the
#     next step instead of this one.
r=$(mkrecorder)
out=$(push "$r")
grep -q 'compute scp' "$r/calls" || die "push-scripts copied nothing: $(cat "$r/calls")"
miss=""
for f in worker-setup.sh worker-credentials.sh worker-workspace.sh; do
  grep -q "scp.*$f" "$r/calls" || miss="$miss [$f]"
done
[ -z "$miss" ] && pass "push-scripts stages all three scripts" || die "not staged:$miss"
grep -q 'chmod +x' "$r/calls" && pass "staged scripts are made executable" \
  || die "no chmod on the host: $(cat "$r/calls")"

# 39. every call rides the IAP tunnel and pins zone and project. Public SSH is
#     denied by the tagged firewall rule, so an unpinned call has no path in.
untunnelled=$(grep -c 'compute \(ssh\|scp\)' "$r/calls")
tunnelled=$(grep 'compute \(ssh\|scp\)' "$r/calls" | grep -c 'tunnel-through-iap')
[ "$untunnelled" -gt 0 ] && [ "$untunnelled" -eq "$tunnelled" ] \
  && pass "every remote call rides the IAP tunnel" \
  || die "$((untunnelled - tunnelled)) call(s) bypassed the tunnel: $(cat "$r/calls")"
grep -q 'zone=europe-west2-a' "$r/calls" && grep -q 'project=poc-cloud-nodes' "$r/calls" \
  && pass "push-scripts pins zone and project" || die "unpinned target: $(cat "$r/calls")"

# 40. the staging directory is not $HOME. A script loose in the worker's home
#     is indistinguishable from the repo copy that supersedes it at step 7.
grep -qE 'scp[^\n]*:~?/?$|:~/ ' "$r/calls" \
  && die "push-scripts staged into \$HOME: $(cat "$r/calls")" \
  || pass "staged into its own directory, not \$HOME"
rm -rf "$r"

# 41. a script missing locally fails naming it, and stages nothing. A partial
#     set is worse than none: provisioning stops halfway with no signal why.
# Both operator-side files, so the script loads; none of the three it stages.
r=$(mkrecorder); lone=$(mktemp -d); cp "$SCRIPT" "${SCRIPT%/*}/forge-keys.sh" "$lone/"
out=$(env PATH="$HERMETIC" WORKER_SDK_ROOTS="$r" bash "$lone/provision-worker.sh" push-scripts 2>&1)
[ $? -ne 0 ] && grep -qF 'worker-setup.sh' <<<"$out" \
  && pass "a missing script fails naming it" || die "missing script mishandled: $out"
grep -q 'compute scp' "$r/calls" && die "staged a partial set: $(cat "$r/calls")" \
  || pass "nothing is staged from an incomplete set"
rm -rf "$r" "$lone"

# --- keys-install lives in provision-keys.test.sh ----------------------------

exit $fail
