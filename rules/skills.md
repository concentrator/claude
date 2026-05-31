---
paths:
  - "**/skills/**/SKILL.md"
---

# SKILL.md maintenance rules

For the creation workflow see `skills/skill-creator/SKILL.md`; for pressure-tested
authoring see `skills/writing-skills/SKILL.md`. Rules below apply on every SKILL.md
read or edit.

## Frontmatter

- Required: `name` (matches directory), `description`.
- **Description: ≤12 words.** Start with "Use when/before/after..." — no workflow
  summary, no "this skill does X".

## Size

- **Body: ≤300 words** (general); **≤150 words** for skills loaded every session.
- **Reference skills** (lookup material, not a workflow): up to ~1500 words inline.
  Beyond that → companion `.md` files alongside `SKILL.md`.

## Naming and location

- Hyphenated, verb-first or gerund: `requesting-code-review`, `writing-plans`.
- Global: `~/.claude/skills/<name>/SKILL.md`
- Project: `<project>/.claude/skills/<name>/SKILL.md`

## Content

- **Imperative voice.** "Check coverage" not "you should check coverage".
- **Non-obvious procedure only.** Claude already knows languages, frameworks, and
  standard practice — skip generic guidance.
- **Concrete paths and commands.** No placeholders, no TBDs.
- **Every step earns its place.** If skipping a step wouldn't change outcomes,
  delete it.

## What doesn't work — avoid

Lessons from the 2026-04 maintenance experiment:

- **No multi-hop handoffs.** A skill invoking another skill that invokes another
  fails — each hop is a chance to forget. For "every turn" enforcement use a
  `Stop` hook, not a skill.
- **No write-only logs.** If a JSONL or state file isn't queried back, the skill
  writing it is dead weight.
- **No pure routers.** Skills that just dispatch to other skills (no state,
  no plan generation, no branch management) are dead weight. Orchestrators
  with real work — generating plans, managing branches, transitioning between
  phases — are fine.

## On edit

- Verify body still ≤ word limit (`wc -w SKILL.md`).
- If a renamed/removed file is referenced, grep other skills + `~/.claude/CLAUDE.md`
  for stale references.

## Approval

**Never auto-create or auto-edit a skill.** Propose changes; wait for explicit
approval before writing.
