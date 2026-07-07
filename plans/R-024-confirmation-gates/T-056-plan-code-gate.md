task: T-056
type: feat

# feat/plan-code-gate - enforce the plan->code boundary (R-024)

T-056 of `plans/R-024-confirmation-gates/`. Make explicit in the workflow
that approving a plan (shape or detail) does not authorize or auto-start
coding: the plan round delivers its PR, stops, and proposes `/dev code`.

Acceptance criteria: see `requirements.md` (plan.md + SKILL.md state
plan-approval does not authorize coding; the plan round stops and proposes
`/dev code`).

- [x] `plan.md`: add to § Planning rounds (or § Approval and closure) that approving a plan delivers the plan PR and stops - it does not authorize or start implementation; the round proposes `/dev code <slug>` next. Shape-approval authorizes planning downstream, not code.
- [x] `SKILL.md`: in the `/dev plan` surface, state that a plan round ends by proposing `/dev code` and never auto-starts it (reinforce "propose next; never auto-execute").
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
