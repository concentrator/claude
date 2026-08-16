# R040-T010 findings

- [ ] **Tailscale is not required for the worker to reach the GitLab.** The
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
      Needs the operator's decision: keep it installed for future use, or
      drop it from the worker's provisioning as unnecessary weight.

- [x] First contact with any new remote needs a retry, not a verdict. The
      first IAP connection after instance creation failed with exit 255
      while the OS Login key propagated; the immediate retry succeeded. The
      first `keys-verify` run produced no output while host keys were
      accepted; the second printed both identities. Both are the same shape,
      and `verify_iap` already retries three times for this reason - worth
      the same treatment anywhere a first connection gates a later step.
