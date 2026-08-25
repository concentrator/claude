# Brainstorming

Collaborative dialogue that turns an idea into an initiative - the one
act of `plan.md § Directory conventions`. The discovery method behind
`/dev plan R`.

## Process

1. **Context** - read `REQUIREMENTS.md`, `DESIGN.md`, roadmap, recent
   commits. Know what exists before asking.
2. **Scope check** - if the idea spans multiple independent initiatives,
   say so and split; brainstorm the first.
3. **Clarify** - questions one at a time, multiple-choice when possible:
   purpose, constraints, success criteria. Stop when you could write the
   acceptance criteria. For genuinely visual questions (mockups,
   layouts), offer the companion per `companions/visual-companion.md` - own
   message, opt-in.
4. **Approaches** - propose 2–3 with trade-offs; lead with your
   recommendation. YAGNI ruthlessly.
5. **Draft** - pick the next free `R<NNN>` id, create the plan branch
   (`git-workflow.md § Trunk`) before the first artifact write, then
   draft: requirements sections per `templates.md § Per-initiative`.
   Present it section by section, confirming each. Then the draft
   task list (`plan.md § Planning rounds`).
6. **Self-check** - placeholders, contradictions, criteria readable two
   ways, scope creep. Fix inline before showing the file.
7. **User review** - user reads the committed-to-be file; iterate.
   Approval stamp + delivery: `plan.md § Approval and closure`,
   `§ Where plans live in git`.
8. **Next** - propose the detail round `/dev plan R<NNN>` for branch
   plans (gate rules: `plan.md § Planning rounds`).

## Rules

- No code, no scaffolding, no implementation skill - regardless of
  perceived simplicity. A small idea still gets an initiative; its
  requirements can be short.
- Stay at requirement altitude: behavior, surfaces, edge cases,
  acceptance criteria. Architecture belongs in `DESIGN.md`; commit
  decomposition belongs to branch planning.
- Acceptance criteria state properties verifiable at close, never
  snapshot counts - the work changes the corpus the criteria measure.
  Enumerations are shaping-time evidence; the criterion cites the
  check that verifies the property.
- Proportion the draft to the observed failure
  (`plan.md § Proportionality`): ask what can be deleted before adding.
- Anchor the design to the named, time-proven standard for the problem;
  surface it and the alternatives, map the needs onto it, deviate only
  with a stated reason. A draft growing custom branching, state
  machines, or protocols → ask "what's the production standard here?"
  and offer authoritative references before locking the decision.
