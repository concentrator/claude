---
task: R040-T018
type: doc
depends-on: R040-T008
---

Branch: `doc/supervised-stamp`.

`branch-plan.md § agentic: stamp` admits a plan only when a cold reader
can build it with no question, because a `/dev auto` subagent has no
one to ask. `supervise.md § Resolve` demands the same stamp, yet a
supervised worker has three receivers - supervisor for implementation
calls, operator for merges and plan-fact corrections, human for design.
The first supervised task of a fresh project spent three cold reads
stamping one doc plan, and its one real defect was caught by the worker
at pre-flight. Three changes, one PR.

## Terms used below

- **`supervised:` stamp** - `supervised: approved YYYY-MM-DD` in a
  branch plan header. It guarantees approved requirements, one commit
  per item, and no known design question open. Applied to every plan in
  the R when the human approves the planning round (`plan.md
  § Approval and closure`); a cold read under it is optional, its
  findings triaged by receiver, and only a human-level finding blocks.
- **Declaration carve-out** - a `CLAUDE.md` change confined to the
  declaration lines `companions/declarations.md` defines is
  configuration the operator delivers, not a convention change.

## Commits

- [x] `branch-plan.md`: § `agentic:` stamp becomes § Stamps, holding
  both stamps and what each admits (`agentic:` keeps its bar and its
  cold read, and stays what `/dev auto` needs); the header example
  gains the `supervised:` line. `plan.md § Approval and closure` states
  that detail-round approval stamps `supervised:` on the round's plans.
  `supervise.md § Resolve` admits `supervised:` alongside `agentic:`
  and names the receiver triage for an optional cold read. `auto.md` is
  untouched. `branch-plan.md` stays under its word cap: the item
  includes the offsetting trim.
- [x] `companions/declarations.md § Supervisor bounds`: the
  always-escalated list carves out the Declaration carve-out;
  `git-workflow.md § Merge policy`'s escalation list cites it instead
  of restating.
- [x] `companions/declarations.md § Operator modes`: an AI-operated seat
  satisfies the global `CLAUDE.md § Approval and persistence` and
  `§ Communication` by the declared bounds - it decides merges and
  plan-wording facts within them, runs `--permission-mode auto`, and
  halts only on the always-escalated classes, design-level questions
  and evidence gaps. `companions/supervisor-runbook.md` gains the
  operator session's launch line and briefing beside the supervisor's
  in both variants.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
