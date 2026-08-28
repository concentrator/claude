---
approved: 2026-06-11
---

# Environment requirements

## Vision

`~/.claude` is a portable, version-controlled Claude Code environment
configuration - the skills, rules, agents, hooks, and settings the DEV
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

## Planning discipline

DEV-mode work flows through a traceable hierarchy - **initiative
(R<NNN>) → task (R<NNN>-T<NNN>) → branch plan → commits** - so every
change traces back to a motivating requirement. The environment must:

- Keep one directory per initiative (`dev/plans/R<NNN>-<slug>/`) holding
  its `requirements.md`, task index (`tasks.md`), branch plans
  (`<task-id>-<slug>.md`), findings, and batch manifests; the
  cross-initiative index (`ROADMAP.md`) lives at `dev/plans/`;
  foundational docs at the repo root.
- Name branch-plan files by task id (sortable, instant file→task
  mapping), the id scoped to its initiative so it routes to the
  artifacts; git branches stay `<prefix>/<slug>` with no id.
- Gate every initiative on explicit approval (`approved:` in its
  requirements frontmatter) before any downstream work begins.
- Close an initiative at a single point: all child tasks `[x]` **and**
  every acceptance criterion verified with evidence, stamped
  `status: done`. Criteria only a later event can confirm (e.g. a batch
  checkpoint) keep the initiative open until that event re-triggers
  verification.
- Route work lacking a fitting open initiative into a new R stub rather
  than orphaning it.

Mechanics: `skills/dev/plan.md`, `skills/dev/branch-plan.md`,
`skills/dev/layout.md`.

## Agentic execution

`/dev auto` runs a batch of approved branches through subagents without
touching the default branch:

- A batch integration branch `batch/R<NNN>-B<NNN>` is cut off the
  default branch at pre-flight; member branches merge into it; the
  default branch advances only when the batch MR merges.
- The batch close phase reviews the full batch diff on the most capable
  model, applies fixes on the batch branch, re-runs tests + lint, and
  checks docs coherence.
- A written checkpoint report (`R<NNN>-B<NNN>.report.md` - per-branch + batch
  sections, cost and defect outcomes) is mandatory; accept is invalid
  without it.
- Accept pushes only the batch branch and opens an MR. Pushing the
  default branch is never automated; deferring the push is an explicit
  user choice; subagents never push.
- Verification depth is tuned for cost without dropping the safety
  floor: mechanical commits may skip the per-commit spec check (the
  close review is the net), small branches fold their review into the
  batch review, and models route per role.

Mechanics: `skills/dev/branch-plan.md § Agentic execution`,
`skills/dispatching-parallel-agents/`.

## Audience

- Primary: software engineers / developers using Claude Code through this
  configuration.
- Secondary: the agent itself, which reads these files as operating rules.

## Success criteria

- Production-ready tools - every skill/rule/command works as documented.
- Structure compliant with Anthropic's recommendations.
- No dead, unused, or broken skills.
- No logical dead-ends and no endless loops in any workflow.
- Changes flow through the full plan hierarchy (traceable).

## Constraints

- Self-hosting: foundational files live at the repo root (`~/.claude/`),
  which is itself the `.claude/` config directory. Claude Code's own
  project settings live at `~/.claude/.claude/settings.json`, tracked.
- Must stay compatible with the Claude Code settings/skill/hook schemas.

## Open questions

- How to make success criteria measurable (lint pass rate, skill-usage
  audit, loop/dead-end detection).
