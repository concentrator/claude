---
task: R040-T010
type: feat
depends-on: R040-T002
---

Branch: `feat/worker-host`.

Create a worker host and take it to a state where a worker session can
run a batch unattended. Two artifacts: `scripts/provision-worker.sh`
for the mechanical, idempotent parts, and `skills/worker-host/SKILL.md`
for the sequence a human drives, including the steps that cannot be
scripted.

**Two execution contexts, and the skill must not blur them.** Creating
the instance runs on the operator's machine under their `gcloud`
credentials; everything after runs on the VM. A step that assumes the
wrong one fails confusingly - `gcloud` is not installed on the worker
and does not need to be.

**Measured sizing, so the skill states requirements rather than
guesses.** A fresh Claude Code session peaks at 437 MB resident; sessions
run for a day or two reach 827-943 MB, growing with transcript length.
Subagents run in-process, so dispatching implementers grows that one
number rather than adding processes. A project's full suite peaks near
70 MB and uses about 2.5 cores' worth for a few seconds. One worker
therefore wants 2 GB and 2 vCPU as a floor, 4 GB comfortably; the
supervisor need not live on the host at all, being repo-less by design.

**What cannot be scripted, and must be stated as such**: Tailscale and
Claude Code both authenticate by SSO in a browser. The skill marks them
human-in-the-loop with a verification command each, rather than
pretending to automate them.

**Tailscale is here for egress**, so the worker can reach the internal
GitLab - not as the host's access path. Establish what it buys **from
the VM**, before the clone step depends on it: with the tailnet down,
does `gl.wallarm.com` resolve, and do HTTPS and SSH answer? That
single test says whether Tailscale is required for the clone or merely
present, and it has to run on the VM - an operator laptop cannot
answer it, because a workstation's own tailnet state is not reliably
observable from a shell on it, and a reachability result there
attributes to the public internet what may have travelled the tunnel.

**Secrets never pass through the agent.** Tokens live in a gitignored
`~/.claude/.env` (ignored as of the baseline fix); the script reads
them, never echoes them, and never takes one as an argument. Anything
missing is reported as absent, never printed.

- [x] Preflight `gcloud` from a **non-interactive** shell, since that
      is where the deploy step runs. Resolve the SDK rather than
      trusting `PATH`: `command -v gcloud`, then `$CLOUDSDK_ROOT_DIR`,
      then the standard roots (`~/google-cloud-sdk`,
      `/opt/homebrew/share/google-cloud-sdk`,
      `/usr/lib/google-cloud-sdk`), and fail naming what was searched.
      A working install is routinely invisible here - the SDK's
      `path.*.inc` is typically sourced from `.zshrc`, which loads for
      interactive shells only, so the operator's own `gcloud` works
      while an agent's does not.
      Then **verify the resolved binary runs**, because presence is
      not health and a stale copy can sit at a standard root: an SDK
      predating Python 3.12 dies on `ModuleNotFoundError: No module
      named 'imp'` against a current interpreter, while a current one
      carries `bundled-python3-unix` and is immune. `gcloud version`
      answering is the check; absolute-path invocation then works for
      auth and config too, which live under `~/.config/gcloud` and
      never depended on `PATH`.
- [x] Deploy the instance, from the operator's machine. A
      `gcloud compute instances create` wrapper, values as variables
      with these defaults, each verified against the project rather
      than assumed:
      `--project=poc-cloud-nodes`, `--zone=europe-west2-a`
      (`gl.wallarm.com` at `34.39.72.42` sits in `34.39.0.0/17`, scope
      `europe-west2`, per Google's published ranges - same region keeps
      git round-trips short; the `default` network already has a
      `10.154.0.0/20` subnet there, while every existing instance in
      this project is in `us-central1`);
      `--machine-type=e2-standard-4` (4 vCPU / 16 GB, confirmed
      available in that zone - sized for three concurrent workers at
      roughly 1 GB per session plus gates; `e2-medium` suffices for
      one to two, and resizing is a stop-and-start);
      `--image-family=debian-13 --image-project=debian-cloud`;
      `--boot-disk-size=30GB --boot-disk-type=pd-balanced` (clones,
      `node_modules` and transcripts; `pd-standard` starves on IOPS
      during `npm ci`);
      `--no-service-account --no-scopes` - the worker calls Anthropic,
      GitHub and GitLab, none of them GCP APIs, and IAP authenticates
      the client rather than the instance, so a machine holding forge
      credentials gets no ambient Google identity;
      `--tags=claude-worker` for the firewall rules to target;
      `--metadata=serial-port-enable=TRUE,enable-oslogin=TRUE`;
      an ephemeral external IP for egress; and explicitly **not**
      Spot or preemptible, since a preempted worker loses its run.
      **Acceptance is the break-glass, proven at creation time**:
      `gcloud compute ssh --tunnel-through-iap` connects before
      anything else is configured. That is the one path that must work
      independently of Tailscale and of any later firewall change, so
      it is verified first rather than assumed, and nothing in the
      hardening step closes a door until it has answered.
- [x] `scripts/provision-worker.sh`, OS baseline. Debian 13: Node >= 22
      from NodeSource (the distro package is older than
      `attack-checker`'s `engines` demands, so every gate fails without
      this), plus `jq`, `tmux`, `git`, `curl`, `ca-certificates`. Set
      the timezone from a variable defaulting to the operator's, since
      dated artifacts (findings files, `approved:` and `status:` stamps)
      drift a day in UTC. Create a swapfile sized to RAM - on a 2 GB box
      a long-lived session meeting the OOM killer mid-batch is the
      failure mode. Create `/opt/wallarm` as the projects root and chown
      it to the worker user - it needs root to create and the worker
      must own it, so it belongs here rather than in the clone step
      where sudo would be a surprise. Idempotent: prove it by running
      twice and showing the second run changes nothing.
- [x] Harden the host, before any credential reaches it. This box will
      hold SSH keys for two forges, two API tokens and a Claude Code
      session; a compromise is push access to every repository the
      operator owns, so the posture here is the repositories' posture.
      **Inventory first**: `ss -tulpn` and justify or remove every
      listening socket. Debian 13 ships `exim4` bound to 25 for cron
      mail - purge it, nothing here sends mail. **SSH**: key-only
      (`PasswordAuthentication no`), `PermitRootLogin no`, and assert
      it rather than trusting the image default. **Reachability** is a
      separate decision from Tailscale, which is installed here for
      egress to the internal GitLab, not as the way in. Restricting
      ingress is still worth doing and costs nothing to combine with
      it, because Tailscale is outbound-initiated and NAT-traverses -
      it needs no inbound rule, so every public ingress port can close
      without breaking the tailnet. Do it at the **VPC** firewall,
      where it is worth more than any host control: tag the instance
      and add a higher-priority deny for tcp:22 from `0.0.0.0/0`
      against that tag, rather than deleting a network-wide
      `default-allow-ssh` that other instances may rely on. Establish
      the break-glass **first** - the deploy step already proved IAP
      connects and set `serial-port-enable=TRUE`, so this step adds the
      firewall allow for Google's IAP range and re-verifies the tunnel
      after each rule change rather than at the end. A tailnet-only box
      whose Tailscale fails to start after reboot has no way in, and a
      deny rule applied before the allow is tested produces exactly
      that. Confirm the IAP range from Google's current documentation,
      not from memory. **Then**
      add `nftables` default-deny inbound, permitting loopback,
      established, `tailscale0` and the IAP range: partly redundant
      with a correct VPC rule, which is the point - it is the layer
      that survives someone loosening the other. **Patching**:
      `unattended-upgrades` for security updates, since a long-lived
      box nobody logs into rots quietly.
      Deliberately excluded, so it is a decision rather than an
      oversight: `fail2ban` (pointless once SSH is not publicly
      reachable) and benchmark-scale hardening (wrong cost for a
      single-purpose worker). Acceptance is the inventory re-run -
      `ss -tulpn` shows nothing on a public interface that the item
      does not name.
- [x] SSH keys, one per host. Generate separate ed25519 keys for GitHub
      and GitLab with no passphrase (a worker cannot answer a prompt),
      write a matching `~/.ssh/config` stanza per host, and print the
      public halves for the operator to install. Verify each with
      `ssh -T` and report the identity the host reports back - a key
      that authenticates as the wrong account is the failure worth
      catching here.
- [x] `glab` and `gh` installed and authenticated. Both are API-layer
      only: git traffic runs over the SSH keys above, so these are
      needed for MR/PR create, view and merge. Read `GITLAB_TOKEN` and
      `GITHUB_TOKEN` from `~/.claude/.env`; authenticate non-
      interactively; verify with `glab auth status` and
      `gh auth status`. Missing `GITHUB_TOKEN` is not an error - a
      worker delivering only GitLab projects never needs it - so report
      it as absent and continue, naming what it would unlock.
- [ ] Clone this repo as the worker's `~/.claude`. It carries
      `CLAUDE.md`, `rules/`, `skills/`, `agents/`, `hooks/` and
      `settings.json` while ignoring all harness state, so the worker
      gets identical config to the operator's machine. Do not use
      `install-dev.sh`: that targets adopter projects and deliberately
      omits personal convention rules. Restore
      `git config core.hooksPath .githooks`, which clone does not carry,
      and prove the pre-push hook fires rather than assuming it.
- [ ] Clone a target project into `/opt/wallarm` with its sibling repos
      adjacent, then `npm ci` and run its declared gate. Adjacency is a
      hard requirement, not a convenience: `attack-checker`'s
      `package.json` names `"wallarm-api-js": "file:../wallarm-api-js"`,
      so `npm ci` fails outright if the sibling is absent - under this
      root that resolves to `/opt/wallarm/attack-checker` beside
      `/opt/wallarm/wallarm-api-js`. Running the project's own
      gate is the acceptance evidence - a host that cannot execute the
      gate cannot deliver a batch, and finding that out here is cheaper
      than finding it at a checkpoint.
- [ ] Place each project's `.claude/settings.local.json`. It is
      gitignored (`*.local.json`), so a fresh clone arrives with no
      allowlist at all - and that file is exactly what keeps a worker
      from stalling on a permission prompt. Provision it from a
      template carrying the auto-permissions rules plus the project's
      declared toolchain commands. The template is already
      path-parameterized - `companions/auto-permissions.template.json`
      uses `__PROJECT_DIR__` and `__HOME__` - so substitution yields
      `/opt/wallarm/<project>` paths with no hand-editing; a rule
      carrying a laptop path is the defect to watch for. Verify by
      running a command the allowlist covers and observing no prompt;
      an unprompted success is the only evidence that distinguishes a
      placed file from a missing one.
- [ ] `skills/worker-host/SKILL.md`, wrapping the sequence. States the
      order, which steps the script performs and which the operator
      must do in a browser (Tailscale, Claude Code), and the
      verification for each. Documents both session modes: `tmux` for
      interactive work, and a headless launch path beside it - with the
      limitation stated plainly, that a headless session is denied edits
      under any `.claude/` path, so tasks touching guarded config
      cannot be delivered headless. Note that the script is supervisor
      infrastructure and stays out of `install-dev.sh`'s payload.
- [ ] Mark `R040-T010` `[x]` in this R's `tasks.md`. The entry stays
      under `## Open`; the mark takes effect at merge.
- [ ] Complete the branch: `bash scripts/ci/run-all.sh` green, then mark
      this plan's remaining checkboxes `[x]` and commit. Closure is
      checkbox-only - no dated status prose. R040-T010 does not close
      R-040; T003 depends on it and remains open.
