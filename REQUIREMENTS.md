---
approved: 2026-06-11
---

# Environment requirements

## Vision

`~/.claude` is a portable, version-controlled Claude Code environment
configuration — the skills, rules, commands, hooks, and settings the DEV
workflow runs on. It is not a product project; it is the toolset itself,
self-managed by the same `/dev` discipline it provides, so it stays a
working reference implementation of its own conventions.

## Goals

- Simplify the Claude Code workflow.
- Improve its effectiveness and reduce the error rate.
- Reduce token/cost and increase the speed of the development process.
- Keep the configuration portable and reproducible across machines.

## Non-goals

- Shipping a user-facing product.
- Application code (lives in the projects that consume this config).

## Audience

- Primary: software engineers / developers using Claude Code through this
  configuration.
- Secondary: the agent itself, which reads these files as operating rules.

## Success criteria

- Production-ready tools — every skill/rule/command works as documented.
- Structure compliant with Anthropic's recommendations.
- No dead, unused, or broken skills.
- No logical dead-ends and no endless loops in any workflow.
- Changes flow through the full plan hierarchy (traceable).

## Constraints

- Self-hosting: foundational files live at the repo root (`~/.claude/`),
  which is itself the `.claude/` config directory. Claude Code's own
  project settings remain at `~/.claude/.claude/settings.local.json`.
- Must stay compatible with the Claude Code settings/skill/hook schemas.

## Open questions

- How to make success criteria measurable (lint pass rate, skill-usage
  audit, loop/dead-end detection).
