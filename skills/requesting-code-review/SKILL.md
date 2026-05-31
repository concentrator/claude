---
name: requesting-code-review
description: Use when completing major work or before merging.
---

# Requesting Code Review

Dispatch code-reviewer subagent to catch issues. The reviewer gets crafted context, never your session history — focused on the work product, preserves your own context.

**Core principle:** Review early, review often.

## When to Request Review

**Mandatory:** after each subagent-driven task; after a major feature; before merge to main.

**Optional but valuable:** when stuck (fresh perspective); before refactoring (baseline); after a complex bugfix.

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse HEAD~1)  # or origin/main
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Dispatch code-reviewer subagent:**

Use Task tool with code-reviewer type, fill template at `code-reviewer.md`

**Placeholders:**
- `{WHAT_WAS_IMPLEMENTED}` - What you just built
- `{PLAN_OR_REQUIREMENTS}` - What it should do
- `{BASE_SHA}` - Starting commit
- `{HEAD_SHA}` - Ending commit
- `{DESCRIPTION}` - Brief summary

**3. Act on feedback:**
- Fix Critical issues immediately
- Fix Important issues before proceeding
- Note Minor issues for later
- Push back if reviewer is wrong (with reasoning)

## Example

```
[After Task 2: verifyIndex() + repairIndex()]

BASE_SHA=$(git rev-parse HEAD~1); HEAD_SHA=$(git rev-parse HEAD)
[Dispatch code-reviewer subagent with placeholders filled]

Reviewer:
  Strengths: clean architecture, real tests
  Issues:
    Important: Missing progress indicators
    Minor: Magic number 100 for reporting interval
  Assessment: Ready to proceed

[Fix Important issue, continue to Task 3]
```

## Integration with Workflows

- **Subagent-Driven Development:** review after each task to catch issues before they compound.
- **Executing Plans:** review after each batch of ~3 tasks.
- **Ad-Hoc Development:** review before merge or when stuck.

## Red Flags

**Never:**
- Skip review because "it's simple"
- Ignore Critical issues
- Proceed with unfixed Important issues
- Argue with valid technical feedback

**If reviewer wrong:**
- Push back with technical reasoning
- Show code/tests that prove it works
- Request clarification

See template at: requesting-code-review/code-reviewer.md
