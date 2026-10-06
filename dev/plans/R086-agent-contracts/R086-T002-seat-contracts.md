---
task: R086-T002
type: mnt
mode: normal
---

- [x] `run.md § Seats` makes a seat's agent definition its one contract -
  `## Inputs`, `## Steps`, `## Outputs` - its dispatch passing only the
  values the inputs name, a rule another file owns cited, never restated.
  The implementer's comes first: each rule of its definition and template
  kept once, none naming what else is in its context. Approach: `run.md`,
  `dev-implementer.md`; delete `implementer-prompt.md`, repoint its citers.
- [x] The code-comments rule leaves the global instructions for a rule file
  path-scoped to code files, which a VIBE session writing code and the
  implementer both load; the implementer's contract and the code reviewer's
  maintainability check cite that file. The sections only the user's
  session applies stay global. Approach: `CLAUDE.md § Code Comments` into
  `rules/code-comments.md`, then the two `agents/` files.
- [x] The planner's definition is its contract, taking in `planner-prompt.md`,
  then deleted, and the steps `write-plan.md` gives the planner, whose
  numbered entries there then point to it; it drops the config paragraph, as
  it writes only the plan and its report, with the Read/Edit/Write tools.
  Approach: `agents/dev-planner.md`, then `write-plan.md`, `run.md § Seats`.
- [x] The doc writer's definition is its contract, taking in
  `doc-writer-prompt.md`, then deleted, and dropping the config paragraph, as
  it writes only docs, with the Read/Edit/Write tools; `LAYOUT.md` then lists
  no prompt templates under `companions/`. Approach:
  `agents/dev-doc-writer.md`, `run.md § Seats` and `§ Close` 3, `LAYOUT.md`.
- [x] The cold reader's, docs verifier's and code reviewer's definitions are
  contracts, each citing the checks it runs from their home; each drops the
  config paragraph, its read-only bar covering the config directory and the
  settings surface, so the implementer's definition is the paragraph's home.
  Approach: the three `agents/` files, then `verification-policy.md
  § Comprehension check` and `seat-permissions.md`.
- [x] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
