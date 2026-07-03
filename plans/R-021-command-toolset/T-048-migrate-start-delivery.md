task: T-048
type: fix

# fix/migrate-start-delivery — adoption via branch + PR (R-021)

T-048 of `plans/R-021-command-toolset/`. The R-021 branch-guard hook
forbids writes on `main`, but the `migrate`/`start` companions still cite
the "bootstrap exception" and instruct commit-to-`main` — a live
contradiction (surfaced dogfooding `/dev migrate`: the hook refused the
`REQUIREMENTS.md` write on `main`). The bootstrap exception is void (user
decision); make the companions coherent with the hook.

## Scope

- `skills/dev/migrate.md` and `skills/dev/start.md` only (the go-forward
  companions). The standalone originals are removed at T-045.
- The broader cleanup — removing the bootstrap exception from the
  `git-workflow` rule and reordering `start` (scaffold-then-protect) — is
  **R-018**, not this fix.

- [ ] `skills/dev/migrate.md` § 7 — replace "commit to the default branch
  (bootstrap exception)" with "deliver adoption artifacts via a short-lived
  branch + PR (`git-workflow.md`)"; `main` already exists, so no exception.
- [ ] `skills/dev/start.md` — narrow the greenfield wording: the **initial**
  commit creates `main` (hook fails-open on an unborn `main`), then protect
  `main`, then all further work via branches + PRs. Drop the broad
  "commits on the default branch — exception" claim.
- [ ] Complete the branch: grep-verify no "bootstrap exception" /
  commit-to-`main` language remains in the two companions; mark plan
  complete, commit.
