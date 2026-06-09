---
name: migrating-to-dev
description: Use when adopting an existing project into DEV mode.
---

# Migrating to DEV

Bring an existing codebase into DEV mode. Reverse-engineer requirements +
design from code, then layer on planning infrastructure.

## 1. Inventory

Check existing: `CLAUDE.md`, `README.md`, `CHANGELOG.md`, language/stack,
build/test/lint commands, CI config, open branches, `docs/`. Report
findings to the user.

## 2. Requirements

Read README + code. Ask user 3–5 clarifying questions (purpose, audience,
goals, non-goals, success criteria). Write `.claude/requirements.md` with
`approved: pending` per `~/.claude/rules/planning.md § Templates →
Foundational`. **Block on user approval** — then update `approved:` to
today.

## 3. Design

Document module boundaries, data/control flow, architectural decisions
evident from code. Write `.claude/design.md` (≤1000 words inline). User
approves.

## 4. CLAUDE.md alignment

Ensure project `CLAUDE.md` has `## Conventions` (release-routine,
publish-external, extended-docs) + stack, base branch, build/test/lint.
Propose deletion of any restated global rules.

## 5. Quality infrastructure

Check inventory against the baseline: lint configured + a passing smoke
test + CI workflow (default GitLab CI) running lint + tests on MR. Ask
before changing existing config. If user defers any item, record
`quality-deferred: true` in `CLAUDE.md § Conventions`.

## 6. Backfill plans

Create `.claude/plans/` with `roadmap.md`, `tasks.md`. Ask user about
ongoing work → roadmap items (R-XXX) and open tasks (T-XXX). Known bugs
or tech debt → new `REQ-XXX.md` per `~/.claude/rules/planning.md`.

## 7. Commit

Commit adoption artifacts to default branch (separate commits per
category for clarity).

## 8. Next

Propose: pick a `T-XXX` from `tasks.md` → `/dev plan T-XXX` to start a
branch plan.
