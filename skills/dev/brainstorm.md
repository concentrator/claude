# Brainstorming

Collaborative dialogue that turns an idea into an initiative: ROADMAP
entry + `plans/R-XXX-<slug>/` dir + its `requirements.md`, one act.
The discovery method behind `/dev plan R`. Output is a spec, never
code — implementation comes later via the planning chain
(R → T → branch plan).

## Process

1. **Context** — read `REQUIREMENTS.md`, `DESIGN.md`, roadmap, recent
   commits. Know what exists before asking.
2. **Scope check** — if the idea spans multiple independent initiatives,
   say so and split; brainstorm the first.
3. **Clarify** — questions one at a time, multiple-choice when possible:
   purpose, constraints, success criteria. Stop when you could write the
   acceptance criteria. For genuinely visual questions (mockups,
   layouts), offer the companion per `companions/visual-companion.md` — own
   message, opt-in.
4. **Approaches** — propose 2–3 with trade-offs; lead with your
   recommendation. YAGNI ruthlessly.
5. **Draft** — next free `R-XXX` id; requirements sections per
   `templates.md § Per-initiative`. Present it section by
   section, confirming each. Then a draft task list (`tasks.md`, per
   `plan.md § Levels`) under the same approval gate — deferrable for a
   large/uncertain R.
6. **Self-check** — placeholders, contradictions, criteria readable two
   ways, scope creep. Fix inline before showing the file.
7. **User review** — user reads the committed-to-be file; iterate. On
   explicit approval set `approved: <today>` and deliver via a plan MR/PR
   (`plan.md § Where plans live in git`).
8. **Next** — tasks are drafted here (step 5); propose the detail round
   `/dev plan R-XXX` for branch plans. Never auto-execute.

## Rules

- One question per message.
- No code, no scaffolding, no implementation skill — regardless of
  perceived simplicity. A small idea still gets an initiative; its
  requirements can be short.
- Stay at requirement altitude: behavior, surfaces, edge cases,
  acceptance criteria. Architecture belongs in `DESIGN.md`; commit
  decomposition belongs to branch planning.
