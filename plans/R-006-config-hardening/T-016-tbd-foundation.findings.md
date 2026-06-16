# T-016 tbd-foundation — findings

## R-006 follow-ups (fold in at T-017 / T-019 planning)

Surfaced mid-T-016 while authoring `git-workflow.md`: conversational
framing / rationale was leaking into rule files. Captured here, to be
incorporated when those tasks are planned.

- **T-017** — add a `## Verify before stating` rule to CLAUDE.md
  (absorbs the existing `Structured Data` section): "Before asserting a
  fact, confirm it against an authoritative source you can point to. No
  source → verify it, or say you're unsure; never present a guess as
  confirmed. Schemas, configs, API shapes: read the reference first."
- **T-017** — add an anti-rationale rule to `rules/claude-md.md` and
  `rules/skills.md`: operative instructions only; no rationale, framing,
  or transplanted conversational wording (the "why" goes in
  requirements/DESIGN).
- **T-017** — make the CLAUDE.md compaction criterion explicit: strip
  rationale/framing, operative-only — not merely `wc -w` ≤ 400.
- **T-019** — add a "prune dead prose" step to `maintenance.md`'s
  review. Three gates per sentence: (1) accurate and sensible in
  context? (2) valuable in any real scenario? (3) would behavior change
  if removed? Fail any → cut; propose the fix.

## DESIGN.md (T-016 commit 5)

Carry the TBD research provenance here (moved out of `git-workflow.md`,
where it was non-operative): trunkbaseddevelopment.com, dora.dev,
git-scm.com Pro Git (tagging), Fowler (feature-toggles /
branch-by-abstraction), GitHub Docs (branch protection / auto-merge).

## Rule relocation mapping (preservation invariant)

Git rules moved out of CLAUDE.md / planning.md into `git-workflow.md`,
none dropped except the one intentional removal:

| Was | Now |
|---|---|
| CLAUDE.md § Commit Messages | `git-workflow.md § Commit messages` (verbatim; trailing rationale trimmed) |
| CLAUDE.md § MR / PR Messages | `git-workflow.md § MR/PR messages` (verbatim; "Audience visibility below" → "`CLAUDE.md § Audience visibility`") |
| CLAUDE.md Session-Workflow branch discipline (`<prefix>/<slug>`, never-commit-to-default, merging is user's call) | `git-workflow.md § Trunk` (reframed to TBD: never push to main; all via PR) |
| CLAUDE.md "~/.claude commits to main directly" exception | **dropped** — intentional (no exceptions under TBD) |
| planning.md "plans commit directly to main" exception | reframed to PR model (commit 2) |

## Triage

_Pending — branch close._
