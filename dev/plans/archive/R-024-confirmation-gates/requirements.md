---
approved: 2026-07-07
kind: feat
status: done 2026-07-08
---

# R-024: DEV confirmation and outcome gates

## Motivation

The DEV workflow leans on the agent's discretion for two interactive
boundaries it should enforce. After a plan is approved, nothing should
auto-start coding; and a branch should not merge without the close-review
outcome and a verify step presented. Both were glossed in practice: the
R-021 cut-over auto-chained plan into code, and the original regression
auto-opened a PR without the outcome or verify. Separately, the branch-guard
that enforces "no work on main" over-fires on three legitimate patterns,
forcing manual workarounds. R-024 enforces the boundaries in the workflow
docs and makes the guard precise.

## Goals

- plan->code gate: the plan round delivers, stops, and proposes `/dev code`;
  approving a plan (shape or detail) never authorizes or auto-starts coding.
  Enforced in `plan.md` and `SKILL.md`.
- branch-close verify gate: `finish` presents the outcome vs the task's
  acceptance criteria, then a distinct verify step (live test / results
  collection), then the merge options; the MR/PR opens only on explicit
  choice. Un-bundles the verify (currently one message with the options),
  the R-020 leftover.
- branch-guard precision: the hook stops false-blocking three patterns - a
  compound `git checkout -b ... && ... git commit` from main, a cross-repo
  `git -C <other> commit` while the cwd repo is on main, and a Write to a
  gitignored path on main. It resolves the real target repo/branch and skips
  gitignored paths; fail-open preserved; tested.

## Non-goals

- The ledger PR-conflict (`maintenance.jsonl` union-merge not honored by
  GitHub) - a separate CI-mechanism fix.
- Force-running the verify: it stays an always-presented offer plus explicit
  choice, not a mandatory execution.
- The explicit review checklist (R-025) and the planning hierarchy.

## User experience

- plan->code: after `/dev plan` delivers its PR, the workflow reports what is
  ready and proposes `/dev code <slug>`; it does not start coding. Approving
  requirements (the shape gate) authorizes planning downstream, not
  implementation.
- branch close: `finish` presents, as distinct steps before any merge, the
  outcome vs the ACs, then a live-test / results-collection offer (run the
  work product for data tasks), then the merge/keep/discard options. The PR
  opens only when the user picks it.
- branch-guard: the three patterns work without a workaround; the guard still
  blocks a real direct-main write or commit; it fails open on ambiguity.

## Acceptance criteria

- [x] `plan.md` + `SKILL.md` state that approving a plan does not authorize
  coding; the plan round stops and proposes `/dev code` (no auto-chain).
  *`plan.md § Planning rounds` ("Approval authorizes planning, not code") +
  `SKILL.md` surface ("each proposes `/dev code` next, never auto-starts it")
  (T-056).*
- [x] `finish.md § 2` presents the outcome, then a distinct verify step, then
  the merge options; the MR/PR opens only on explicit choice; the verify is
  not bundled or glossed.
  *`finish.md § 2` is three ordered steps (outcome / verify / options), the
  verify "present this and wait; do not roll it into the options"; MR/PR
  explicit-only preserved; `branch-plan.md` step 5 aligned (T-057).*
- [x] The branch-guard permits a compound `git checkout -b X && ... && git
  commit`, a `git -C <other-repo> commit` while cwd is on main, and a Write
  to a gitignored path on main, while still denying a real direct write or
  commit on the trunk; it fails open on error.
  *`hooks/dev-branch-guard.sh` judges the real target (gitignore exemption,
  target-repo resolution, compound branch-create); denies real direct-main
  and `git -c ... commit`; fails open (T-058).*
- [x] A new `scripts/test/dev-branch-guard.test.sh` covers the three
  previously-false-blocked patterns, the true-positive, and fail-open.
  *`dev-branch-guard.test.sh` (17 assertions) covers the three patterns, the
  true-positives, five adversarial regressions, and fail-open (T-058).*
- [x] Full Tier-1 gate green + Tier-2 ledger stamp.
  *Each of #137/#139/#141 merged on a green Tier-1 gate with a
  `concerns_clear` ledger stamp.*

## Constraints

- The branch-guard stays a PreToolUse hook (fail-open, jq/stdout deny)
  shipped by `install-dev.sh`; changes keep it byte-robust and fail-open.
- Self-hosting: changes the workflow this repo runs on itself.
- Trunk-based delivery (`git-workflow.md`).

## Open questions

- Verify-gate strictness: always-presented offer (default) vs mandatory-run
  before merge - settle in detail.
- Branch-guard cross-repo detection: parse `git -C <path>` to resolve the
  target repo's branch vs a simpler heuristic - settle in detail.

## References

- Absorbs the R-020 verify-gate leftover. Surfaced dogfooding R-021. The
  ledger-conflict friction is a separate fix. Relates R-025 (review
  checklist).
