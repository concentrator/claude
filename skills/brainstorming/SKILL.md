---
name: brainstorming
description: Use when shaping an idea into an initiative before planning.
---

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
   layouts), offer the companion per `visual-companion.md` — own
   message, opt-in.
4. **Approaches** — propose 2–3 with trade-offs; lead with your
   recommendation. YAGNI ruthlessly.
5. **Draft** — next free `R-XXX` id; requirements sections per
   `~/.claude/rules/planning-templates.md § Per-initiative`. Present it section by
   section, confirming each.
6. **Self-check** — placeholders, contradictions, criteria readable two
   ways, scope creep. Fix inline before showing the file.
7. **User review** — user reads the committed-to-be file; iterate. On
   explicit approval set `approved: <today>` and commit to main
   (allowed exception).
8. **Next** — propose tasks under the new R (`/dev plan R-XXX`).
   Never auto-execute.

## Rules

- One question per message.
- No code, no scaffolding, no implementation skill — regardless of
  perceived simplicity. A small idea still gets an initiative; its
  requirements can be short.
- Stay at requirement altitude: behavior, surfaces, edge cases,
  acceptance criteria. Architecture belongs in `DESIGN.md`; commit
  decomposition belongs to branch planning.
