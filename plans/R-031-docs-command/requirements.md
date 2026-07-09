---
approved: 2026-07-10
kind: feat
---

# R-031: Standalone /dev docs command

## Motivation

R-030 placed docs audit / build / correction in `migrate § 7`, reachable
only on migrate's Fresh route. Already-DEV and Legacy projects - the common
case for adopting or refreshing the docs layer - cannot invoke it. Add a
standalone `/dev docs` entry.

## Goals

- Extract the docs-adoption procedure into `companions/docs-adoption.md`;
  `migrate § 7` references it (DRY, one source of truth).
- Add `/dev docs`: runs audit -> user-prioritized build -> workflow
  correction on the current project, independent of migrate, re-runnable to
  refresh docs as code drifts.
- Audit existing docs for drift: where a doc is already present, the audit
  grades it doc-vs-code (WARN on mismatch) and offers a rebuild - the refresh
  path for an already-documented project.
- Ensure the docs conventions are recorded: workflow correction seeds the
  granularity model and the `.claude/docs/index.md` pointer in
  `CLAUDE.md § Conventions` if absent.

## Non-goals

- Changing the audit / build / correction logic itself (R-030).
- Per-doc editing or generation commands.
- Auto-running docs adoption - it stays user-invoked.

## User experience

- `/dev docs` on any project: audits current docs vs code, files issues as
  fixable tasks, builds or refreshes a user-prioritized subset, and keeps the
  index + workflow current.
- `migrate § 7` delegates to the same companion, so fresh adoption is
  unchanged.

## Acceptance criteria

- [ ] `companions/docs-adoption.md` holds the audit / build / correction
  procedure; `migrate § 7` is a pointer to it (fresh-adoption behavior
  unchanged).
- [ ] `/dev docs` is in `SKILL.md § Surface` + the router; a `docs.md` mode
  file runs the companion on the current project.
- [ ] `/dev docs` works on an already-DEV project (re-runnable refresh), not
  just fresh adoption.
- [ ] The audit grades existing docs doc-vs-code (WARN on drift) and offers a
  rebuild; workflow correction records the docs conventions (granularity +
  index pointer) in `CLAUDE.md § Conventions` if absent.
- [ ] Ships to adopters (`skills/dev/` files, already distributed).

## Constraints

- Self-hosting; `SKILL.md` stays within its <=400-word orchestrator cap.
- Trunk-based delivery (`git-workflow.md`).

## Open questions

- Scope argument: `/dev docs <feature>` to (re)build one doc vs whole-project
  only. Settle in detail.
- On-demand only vs suggested at branch close when docs drift. Settle in
  detail.

## References

- Extends R-030 (the `migrate § 7` docs-adoption step). Reuses the
  `dispatching-parallel-agents` fresh-agent spec-check.
