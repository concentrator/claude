---
name: brainstorming
description: Use when shaping an idea into a REQ-XXX before planning.
---

# Brainstorming

Collaborative dialogue that turns an idea into a per-initiative
requirement (`.claude/plans/REQ-XXX.md`). The discovery method behind
`/dev plan REQ`. Output is a spec, never code — implementation comes
later via the planning chain (R → T → branch plan).

## Process

1. **Context** — read `requirements.md`, `design.md`, roadmap, recent
   commits. Know what exists before asking.
2. **Scope check** — if the idea spans multiple independent initiatives,
   say so and split: one REQ per initiative, brainstorm the first.
3. **Clarify** — questions one at a time, multiple-choice when possible:
   purpose, constraints, success criteria. Stop when you could write the
   acceptance criteria. For genuinely visual questions (mockups,
   layouts), offer the companion per `visual-companion.md` — own
   message, opt-in.
4. **Approaches** — propose 2–3 with trade-offs; lead with your
   recommendation. YAGNI ruthlessly.
5. **Draft REQ** — next free `REQ-XXX` id, `kind: feat | bug |
   refactor`, sections per `~/.claude/rules/planning.md § Templates`,
   frontmatter `approved: pending`. Present it section by section,
   confirming each.
6. **Self-check** — placeholders, contradictions, criteria readable two
   ways, scope creep. Fix inline before showing the file.
7. **User review** — user reads the committed-to-be file; iterate. On
   explicit approval set `approved: <today>` and commit to main
   (allowed exception).
8. **Next** — propose roadmap items under the new REQ (`/dev plan
   roadmap`). Never auto-execute.

## Rules

- One question per message.
- No code, no scaffolding, no implementation skill — regardless of
  perceived simplicity. A small idea still gets a REQ; it can be short.
- Stay at requirement altitude: behavior, surfaces, edge cases,
  acceptance criteria. Architecture belongs in `design.md`; commit
  decomposition belongs to branch planning.
