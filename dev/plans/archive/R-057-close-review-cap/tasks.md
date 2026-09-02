# R-057 tasks - Cap the close review

This initiative's task index. The tag sets the branch prefix; a
checkbox closes only when the task's branch merges. Task ids are
composite (`R057-T###`, counter scoped to this initiative).

## Open

- [x] **R057-T001 [mnt]**: switch the routed close review to the
  capped `code-reviewer` agent - repoint the table rows, state the
  cap (one reviewer, a verifier only on Critical) and the manual-only
  `/code-review` escalation, pin `model: fable` plus an effort key
  and reviewer conduct rules in `agents/code-reviewer.md` - no
  subagents, and read-only toward the repo: no writes, no branch
  switching (a dispatched reviewer ran `git checkout main` and
  switched the session working tree) - and replace the
  `delegation.md` close-review bullet with the subagent prohibition,
  and update `verification-policy.md § Effort mechanics`.

- [x] **R057-T002 [mnt]**: superseded by R072-T001 - the review
  dimensions became checklist lines inside the one
  `agents/code-reviewer.md` rubric; no targeted reviewer set is
  defined.
