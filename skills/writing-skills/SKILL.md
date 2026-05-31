---
name: writing-skills
description: Use when a skill must resist rationalization under pressure.
---

# Writing Skills

## Overview

**Writing skills IS Test-Driven Development applied to process documentation.**

Write test cases (pressure scenarios with subagents), watch them fail
(baseline behavior), write the skill (documentation), watch tests pass
(agents comply), and refactor (close loopholes).

**Core principle:** If you didn't watch an agent fail without the skill,
you don't know if the skill teaches the right thing.

**REQUIRED BACKGROUND:** You MUST understand `test-driven-development`
before using this skill. That skill defines the fundamental RED-GREEN-REFACTOR
cycle. This skill adapts TDD to documentation.

## TDD Mapping for Skills

| TDD Concept | Skill Creation |
|-------------|----------------|
| **Test case** | Pressure scenario with subagent |
| **Production code** | Skill document (SKILL.md) |
| **Test fails (RED)** | Agent violates rule without skill (baseline) |
| **Test passes (GREEN)** | Agent complies with skill present |
| **Refactor** | Close loopholes while maintaining compliance |
| **Write test first** | Run baseline scenario BEFORE writing skill |
| **Watch it fail** | Document exact rationalizations agent uses |
| **Minimal code** | Write skill addressing those specific violations |
| **Watch it pass** | Verify agent now complies |
| **Refactor cycle** | Find new rationalizations → plug → re-verify |

The entire skill creation process follows RED-GREEN-REFACTOR.

## The Iron Law

```
NO SKILL WITHOUT A FAILING TEST FIRST
```

Applies to NEW skills AND EDITS to existing skills.

Write skill before testing? Delete it. Start over.
Edit skill without testing? Same violation.

**No exceptions:** not for "simple additions", not for "just one section",
not for "documentation updates". Don't keep untested changes as reference.
Don't adapt while running tests. Delete means delete.

## RED-GREEN-REFACTOR

**RED — watch it fail.** Run pressure scenario with subagent WITHOUT the
skill. Document choices and rationalizations verbatim.

**GREEN — make it pass.** Write skill addressing those specific
rationalizations. Don't pre-emptively cover hypotheticals. Re-run scenarios
WITH skill; agent should now comply.

**REFACTOR — close loopholes.** Agent found a new rationalization?
Add explicit counter. Re-test until bulletproof.

Full methodology — scenario design, pressure types, rationalization tables,
meta-testing — in `testing-skills-with-subagents.md`.

## When to use writing-skills vs skill-creator

Use **`skill-creator`** for straightforward procedural skills — clear inputs,
clear outputs, no pressure to skip steps.

Use **this skill** when the new skill must:
- Enforce discipline under pressure (TDD, verification, "no shortcuts")
- Resist rationalization — agents will try to skip steps
- Be pressure-tested with subagents (RED-GREEN-REFACTOR)
- Carry companion files / heavy reference (>100 lines)

## Companions

- `testing-skills-with-subagents.md` — full testing methodology
- `persuasion-principles.md` — why specific phrasings increase compliance
- `anthropic-best-practices.md` — official Anthropic authoring docs
- `~/.claude/rules/skills.md` — size/naming/content constraints (auto-loads on SKILL.md edits)
