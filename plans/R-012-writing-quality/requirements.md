---
approved: 2026-06-23
kind: feat
---

# R-012: Writing quality — idiomatic terminology, no verbatim transplant

## Motivation

The agent transplants the user's verbatim phrasing (a non-native
speaker) into documentation, producing awkward or nonsensical sentences,
and coins idiosyncratic jargon ('cohort', 'drain', 'wired', 'owns it')
where established terms exist — e.g. "A set of operations wired by one
Controller … Operations don't know the sequence — the Controller owns
it." The existing anti-transplant bullet (`claude-md.md`/`skills.md`)
covers only rationale/wording in rules/skills, not terminology quality
across all output.

## Goals

- A global `## Writing` rule in CLAUDE.md: convey the user's intent, not
  their literal phrasing; write clear idiomatic English in the context's
  conventional terminology; prefer established terms over coined jargon.
- Applies to all output: docs, rules, skills, code comments, PR/commit
  text, plans.
- Consolidate: `§ Writing` owns the transplant + terminology principle;
  `claude-md.md`/`skills.md` keep only "rationale belongs in
  requirements/DESIGN" and point to `§ Writing` (no duplication).
- A Tier-2 review gate (`MAINTENANCE.md`) flags transplanted phrasing and
  idiosyncratic/coined terms, proposing the standard wording.

## Non-goals

- A full style guide or banned-word list beyond "use conventional terms,
  avoid coined jargon."
- Changing *what* is documented — only *how* it's phrased.
- Any delivery/enforcement change beyond the one review gate.

## User experience

- Writing any artifact, the agent expresses the meaning in standard
  terminology, not the user's verbatim words — e.g. "wired by a
  Controller / owns the sequence / don't know the sequence" → "a
  controller orchestrates the operations and determines their order; the
  operations are order-agnostic."
- The Tier-2 reviewer flags awkward transplanted phrasing and coined
  terms in a diff and proposes the conventional wording.

## Acceptance criteria

- [ ] CLAUDE.md has a `## Writing` rule (convey intent not verbatim
      phrasing; idiomatic, conventional terminology; established terms
      over coined jargon; applies to all output).
- [ ] `claude-md.md`/`skills.md` anti-transplant bullets consolidated —
      retain only "rationale belongs in requirements/DESIGN" and
      reference `CLAUDE.md § Writing` (no duplication).
- [ ] `MAINTENANCE.md` Tier-2 review gains a gate flagging transplanted
      phrasing + idiosyncratic/coined terms, proposing standard wording.
- [ ] CLAUDE.md ≤ 400w; skills within caps.

## Constraints

- Domain-neutral (name the principle, not a fixed term list).
- CLAUDE.md cap ≤ 400w (currently ~278); the `§ Writing` add must fit.
- No duplication (`claude-md.md § Size`).

## Open questions

- Should `§ Writing` carry a one-line before/after example (the
  Controller case) for clarity, or stay abstract to save words?

## References

- This session's wallarm docs ('wired/owns it/don't know the sequence',
  'cohort', 'drain') — grounding.
- `claude-md.md § Content`, `skills.md § Content` (existing rule).
- CLAUDE.md § Code Comments / § Audience visibility / § Verify before
  stating (the writing-rule family).
- `MAINTENANCE.md § Tier-2 AI review` (the gate).
