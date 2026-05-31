---
name: skill-creator
description: Use when creating a new skill from scratch.
---

# Skill Creator

Process for creating skills. Constraints in `~/.claude/rules/skills.md` auto-load on any SKILL.md edit.

## Structure

```
skill-name/
├── SKILL.md           # Required. Frontmatter (name + description) + instructions.
├── references/        # Optional. Heavy docs loaded on demand.
└── scripts/           # Optional. Reusable utilities.
```

Progressive disclosure: descriptions always loaded, body loaded on invoke, references loaded when needed.

## Creation process

### 1. Understand

Ask: what does the skill do? When should it trigger? Collect concrete usage examples.

### 2. Plan

Classify:
- **Standalone** — single SKILL.md
- **With references** — lean SKILL.md + detailed docs in `references/`

### 3. Write

- **Body**: imperative form ("Check coverage" not "You should check coverage"). Focus on non-obvious procedural knowledge.
- **References**: pointer in SKILL.md to each file so Claude knows they exist.

### 4. Validate

`~/.claude/rules/skills.md` is auto-loaded for any SKILL.md edit; verify against its constraints. Check all referenced files exist.

### 5. Iterate

Use the skill on a real task. Note failures or unclear steps. Fix and re-test. Stabilizes after 2-3 iterations.

## When to escalate to `writing-skills`

Use `writing-skills` (the superpowers methodology skill) instead when the skill must:

- Enforce discipline under pressure (TDD, verification, "no shortcuts")
- Resist rationalization — agents will try to skip steps
- Be pressure-tested with subagents (RED-GREEN-REFACTOR)
- Carry companion files / heavy reference (>100 lines)

For straightforward procedural skills, stay here.
