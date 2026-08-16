# R040-T010 findings

- [x] **Tailscale is not required for the worker to reach the GitLab.** The
      plan installed it on the stated premise that it provides egress to an
      internal GitLab. Measured on the VM once the tunnel was authenticated:
      with the tailnet **up**, `gl.wallarm.com` resolves to `34.39.72.42` and
      port 22 answers; with `tailscale down`, it still resolves and **both**
      22 and 443 still answer. So the clone step has no dependency on the
      tailnet, and neither does anything else this task installs.
      This is the test the plan deferred through three attempts to answer it
      from a workstation, where it could not be settled: a laptop cannot
      report its own tunnel state reliably from a shell, so a successful
      reachability check there attributes to the public internet what may
      have travelled the tunnel. Running it on the VM, where the tunnel can
      be taken down and restored, answered it in one pass.
      Not a reason to remove Tailscale - it may be wanted for other internal
      services, or for a future project whose host is genuinely private. It
      is a reason to stop describing it as the GitLab's access path, which
      `supervise.md` and this task's own preamble both do.
      Operator decision: removed. Purged from the host and dropped from the
      provisioning script, and `gl.wallarm.com` still answers on 22 with the
      package gone - so the result holds under removal, not merely under
      `tailscale down`. If a future project's host is genuinely private, this
      comes back as its own item rather than as an assumption.

- [x] First contact with any new remote needs a retry, not a verdict. The
      first IAP connection after instance creation failed with exit 255
      while the OS Login key propagated; the immediate retry succeeded. The
      first `keys-verify` run produced no output while host keys were
      accepted; the second printed both identities. Both are the same shape,
      and `verify_iap` already retries three times for this reason - worth
      the same treatment anywhere a first connection gates a later step.

- [ ] **`settings.local.json` contributes less than the plan assumed, and its
      acceptance test could not be made to discriminate.** The plan calls it
      "exactly what keeps a worker from stalling". On this host it mostly is
      not: the config repo's own `~/.claude/settings.json`, which arrives with
      the config clone, already grants `Bash(git:*)`, `grep`, `sed`, `jq`,
      `mkdir` and more, and the project's tracked `.claude/settings.json` adds
      npm, node and glab. Three attempts to prove the local file was doing
      work all failed: `npm run lint` is granted by the project's own
      settings; an `Edit` in the repo is refused by the branch guard because
      the checkout sits on `main`, denied identically with and without the
      file; and `git switch -c` succeeds either way under the global
      `Bash(git:*)`.
      What the local file does add here is the **deny** pair - it narrows the
      template's blanket `Bash(git push:*)` deny to default-branch and force
      pushes - plus project-scoped `Read`/`Edit` paths. Deny beats allow
      across tiers, so those rules are load-bearing even where the allows are
      redundant. A test proving that would have to attempt a push to `main`,
      which is not worth staging on a live repo to satisfy a check.
      Two things follow. The item's stated acceptance - "run a command the
      allowlist covers and observe no prompt" - cannot distinguish a placed
      file from a missing one on a host whose global config is this broad, so
      it is not the evidence it claims to be. And the global grant deserves
      review on its own: `Bash(git:*)` in the shared config is wider than the
      per-project templates assume, which is why the narrower local deny
      matters more than any allow.

- [x] **An untrusted workspace silently drops allow entries.** Running Claude
      in the freshly cloned project printed "Ignoring 8 permissions.allow
      entries from .claude/settings.json: this workspace has not been
      trusted". Those entries are dropped, not queued - on an unattended
      worker that reads as a permission failure nobody can answer. The flag
      lives in `~/.claude.json` under `projects[<dir>].hasTrustDialogAccepted`,
      outside the project, so it arrives with neither the clone nor the
      settings file. `settings` now sets it, and the warning is gone on
      re-run. This one did discriminate: the message was present before and
      absent after.

- [x] **`glab auth status` is the wrong unit to verify with.** It checks every
      configured GitLab instance and fails if any one does, so on this worker
      it reported "could not authenticate to one or more of the configured
      GitLab instances" while real calls to `gl.wallarm.com` succeeded - a
      false negative that cost a debugging round. Replaced with
      `glab api user --hostname gl.wallarm.com`, which is scoped to the
      instance in question and returns the identity, so it also catches a
      token that authenticates as the wrong account. Same shape as every
      other unit mismatch this initiative has produced: the check answered a
      broader question than the one asked.

- [x] **An item marked done without being run was the one that did not work.**
      `forge-cli` was written, tested against fakes, and marked `[x]` on the
      strength of that, because `.env` was not yet on the host. Neither CLI
      was installed. It was the only item in this task not executed against
      the real host, and the only one that turned out to be broken - the
      function also refused to install anything when `.env` was absent,
      conflating installation with authentication, so it would never have
      worked on a fresh box. Caught by the operator, not by the plan.
