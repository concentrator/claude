# R056-T002 findings

All five are close-review findings about the flip's consequences; the
implementation itself was clean.

- [x] The decision record was silent on scope: `acceptEdits` is
  machine-wide and also auto-approves in-cwd filesystem commands.
  Resolved: recorded in `requirements.md § Desired state`.
- [x] `supervise.md` described the worker edit prompt as an active
  supervisor control; under `acceptEdits` no such prompt occurs.
  Resolved: doc synced here; the replacement gate decision is promoted
  to R040-T014.
- [x] The secrets guard is a regex heuristic and the interactive edit
  prompt was its backstop; no Tier-1 check scans for secrets.
  Resolved: promoted to the broadened R-058 (guard hardening).
- [x] The branch guard fails open on trunks not named `main`/`master`
  and on targets with no owning repo. Resolved: promoted to the
  broadened R-058.
