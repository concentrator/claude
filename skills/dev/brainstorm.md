# Brainstorming

Collaborative dialogue that turns an idea into an initiative - the one
act of `plan.md § Directory conventions`. The discovery method behind
`/dev plan R`.

## Process

1. **Context** - read `REQUIREMENTS.md`, `DESIGN.md`, roadmap, recent
   commits. Know what exists before asking.
2. **Scope check** - if the idea spans multiple independent initiatives,
   say so and split; brainstorm the first. If it is one task's worth,
   offer it as a small change (`plan.md § Planning rounds`); when the
   user picks it, settle the task's tag and slug (`write-plan.md`
   step 2) here, since they name the branch step 5 cuts.
3. **Clarify** - questions one at a time, multiple-choice through the
   AskUserQuestion tool when possible: purpose, constraints, success
   criteria. Stop when you could write the
   acceptance criteria.
4. **Approaches** - only when the user asks for options: 2–3 with
   trade-offs, recommendation first.
5. **Draft** - pick the next free `R<NNN>` id, create the branch
   (`plan.md § Where plans live in git`), then draft: requirements
   sections per `templates.md § Per-initiative`, `## Design` last: the
   standard followed (§ Rules) and the components changed. Present it
   section by section, confirming each. No task list
   (`plan.md § Planning rounds`).
6. **Self-check** - placeholders, contradictions, criteria readable two
   ways, scope creep. Fix inline before showing the file.
7. **User review** - user reads the committed-to-be file; iterate.
   Approval stamp + delivery: `plan.md § Approval and closure`,
   `§ Where plans live in git`.
8. **Next** - propose the detail round `/dev plan R<NNN>` for the task
   list and a branch plan per task (gate rules: `plan.md § Planning
   rounds`); a small change runs it now, in this session, on the same
   branch.

## Rules

- No code, no scaffolding, no implementation skill - regardless of
  perceived simplicity. A small idea still gets an initiative; its
  requirements can be short.
- Stay at requirement altitude: the goal, inputs and outputs, and
  outcomes in the user's words. Implementation detail enters only when
  the user supplies it; the planned architecture is the requirements'
  `## Design`, never `DESIGN.md`, which holds the present one; the task
  split belongs to the detail round, commit decomposition to branch
  planning.
- Outcomes state properties verifiable at close, never snapshot counts.
- Proportion the draft to the observed failure
  (`plan.md § Proportionality`): ask what can be deleted before adding.
- Anchor the design to the named, time-proven standard for the problem;
  surface it and the alternatives, map the needs onto it, deviate only
  with a stated reason. A draft growing custom branching, state
  machines, or protocols → ask "what's the production standard here?"
  and offer authoritative references before locking the decision.
