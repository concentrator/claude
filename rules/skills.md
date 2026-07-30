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
- **Description: ≤12 words.** Start with "Use when/before/after..." - no workflow
  summary, no "this skill does X".

## Size

- **Body: ≤300 words** (general); **≤150 words** for skills loaded every
  session; **≤400 words** for orchestrators with command/routing tables
  (e.g. `dev`) - tables inflate raw word counts.
- **Reference skills** (lookup material, not a workflow): up to ~1500 words inline.
  Beyond that → companion `.md` files alongside `SKILL.md`.

## Naming and location

- Hyphenated, verb-first or gerund: `receiving-code-review`, `systematic-debugging`.
- Global: `~/.claude/skills/<name>/SKILL.md`
- Project: `<project>/.claude/skills/<name>/SKILL.md`

## Content

- **Imperative voice.** "Check coverage" not "you should check coverage".
- **Concrete paths and commands.** No placeholders, no TBDs.
- Content tests per `rules/claude-md.md § Content` (non-obvious only,
  earns its place, operative WHAT).

## What doesn't work - avoid

- **No multi-hop handoffs.** A skill invoking another skill that invokes
  another fails. For "every turn" enforcement use a `Stop` hook, not a
  skill.
- **No write-only logs.** If a JSONL or state file isn't queried back, the skill
  writing it is dead weight.
- **No pure routers.** Dispatch-only skills are dead weight;
  orchestrators with real work (plans, branches, phase transitions) are
  fine.

## On edit

- Verify body still ≤ word limit (`wc -w SKILL.md`).
- If a renamed/removed file is referenced, grep other skills + `~/.claude/CLAUDE.md`
  for stale references.

## Approval

**Never auto-create or auto-edit a skill.** Propose changes; wait for explicit
approval before writing.
