---
approved: 2026-06-30
kind: feat
---

# R-015: Embeddable self-contained DEV toolchain

## Motivation

The DEV workflow lives in each engineer's global `~/.claude/`, and its
skills/rules hardcode `~/.claude/...` cross-references (~35 across 13
files). A contributor who doesn't want the toolchain in their personal
global config can't run `/dev` conventions on a shared project. Teams
need to embed a self-contained copy of the DEV toolchain into a project's
`.claude/`, committed to the repo, so anyone can follow the workflow
without installing or mixing global config. (`DESIGN.md
§ Self-enforcement` already defers "adopter infra" to a later
initiative — this is it.)

## Goals

- A portable, self-contained DEV toolchain living in `<project>/.claude/`,
  committed to the project repo.
- A contributor with no global DEV toolchain can run the full `/dev`
  workflow from the project alone.
- The project's embedded conventions take precedence over an engineer's
  global toolchain when both are present.
- Keep an embedded copy in sync with the canonical toolchain (drift
  detection + re-vendor).
- Offer embedding as an opt-in on both new (`starting-a-project`) and
  existing (`migrating-to-dev`) projects.

## Non-goals

- Replacing the global-install model (embedding is opt-in; global stays
  the default).
- Plugin distribution (plugins can't carry always-on rules/CLAUDE.md
  context).
- Embedding the self-hosting layer (Tier-2 ledger/`maintenance.jsonl`,
  `MAINTENANCE.md`, memory, repo-specific/Wallarm skills).
- A package registry / publish pipeline for the toolchain.

## User experience

- Opt-in option at scaffold (`starting-a-project`) and adoption
  (`migrating-to-dev`): "embed a self-contained DEV toolchain."
- Vendoring copies the portable core into `<project>/.claude/` (skills,
  rules, a generic DEV `CLAUDE.md` backbone wired via `@`-imports, CI
  gate minus ledger), rewrites every `~/.claude/...` cross-ref to
  project-relative `.claude/...`, and writes a version stamp recording
  the source toolchain version.
- `/dev` is preserved. Embedded sub-skills are namespaced (`dev-*`) so
  they never collide with global skills; the **global** `dev` is
  embed-aware and routes into the embedded routine when it detects an
  embedded project. The project's rules + CLAUDE.md govern.
- Update: re-running the vendor against a newer source version refreshes
  the embedded copy in place; a drift check compares the embedded stamp
  to the source and warns when stale.
- Edge — contributor *with* a global toolchain: `/dev` runs their global
  (embed-aware) `dev`, which dispatches into the embedded `dev-*`
  sub-skills and follows the embedded rules/CLAUDE.md. A clone-time check
  warns if their global `dev` is missing or too old to be embed-aware.
- Edge — contributor *without* a global toolchain: `/dev` resolves to the
  embedded orchestrator (no collision); embedded skills run directly.

## Acceptance criteria

- [ ] A fresh clone of an embedded-toolchain project, opened by a
  contributor with **no** global DEV skills/rules, exposes the full
  `/dev` surface and completes a plan→code→finish cycle using only
  project files. — **NOT met** (reopened): the adopter's `.claude/*`
  gitignore allowlist excludes the vendored `skills/`/`scripts/`/backbone/
  stamp, so they are untracked — a fresh clone lacks them (the earlier
  no-global check read local untracked files, not a clone). Fixed by
  T-038; re-verify against a real `git clone`.
- [x] No `~/.claude/...` reference remains in the embedded copy; every
  cross-reference resolves inside `<project>/.claude/`. — vendor rewrite
  (T-031); `vendor-toolchain.test` "no residual ~/.claude refs" + live run
  (0 residual).
- [x] The embedded core excludes the self-hosting layer (no
  `maintenance.jsonl`, `MAINTENANCE.md`, ledger check, memory,
  repo-specific skills). — manifest exclusions + tracked-only copy (T-031);
  tests confirm `js.md`/`wallarm-*` absent.
- [x] The embedded CI gate runs the portable checks — caps +
  plan-integrity + references (`.claude/`-rooted via `CLAUDE_ROOT`) — and
  passes; it excludes the ledger and the self-hosting / repo-scoped
  `stray` and `todos` checks. — T-035; `embedded-ci.test` runs the gate
  green.
- [ ] In an embedded project, the project's DEV rules and CLAUDE.md take
  precedence over an engineer's global equivalents (verified with an
  engineer who has a global toolchain), and `/dev` routes into the
  embedded routine. — **NOT met** (reopened): namespacing renamed dirs +
  dispatch but left each SKILL.md `name:` unprefixed, so embedded skills
  collide with the global set by name (shadowed; user > project) and
  dispatch breaks (dir ≠ `name:`). Fixed by T-037; re-verify.
- [x] The vendor writes a version stamp; a drift check reports "stale"
  when the embedded version lags the pinned source. — T-033;
  `dev-drift-check.test` + live demo (up-to-date/stale/unknown).
- [x] Re-running the vendor against a newer source version updates the
  embedded copy in place. — T-033 `--update`; `vendor-update.test`
  (preserves adopter content, no double-prefix).
- [x] Embedding is offered as opt-in from both `starting-a-project` and
  `migrating-to-dev`; default behavior is unchanged when not opted in. —
  T-034 (opt-in bullets, default off).
- [x] The audit task classifies every skill and rule as
  portable-generic / project-specific / global-only, and records the
  manifest of the portable core. — T-030; `manifest.md`.

## Constraints

- Pinned-source model: the canonical toolchain is identified by a git
  tag/SHA at vendor time, recorded in the stamp; drift is measured
  against the source's current version. No publish pipeline required.
- Claude Code precedence is fixed: personal (global) skills override
  same-named project skills as a complete override; rules + CLAUDE.md
  load with project precedence (project loads last). The design must work
  within this — namespace embedded skills, keep `/dev` via an embed-aware
  global orchestrator — not against it.
- Must stay compatible with Claude Code settings/skill/hook schemas.

## Open questions

- Skill-collision strategy: namespace embedded sub-skills `dev-*` (never
  collide, always win) + make the **global** `dev` embed-aware so `/dev`
  routes into the embedded routine; a clone-time check verifies and warns
  on a missing or stale global `dev`. Preserves the `/dev` command. The
  design task settles the marker format and the embed-aware dispatch.
- Whether any embedded skill genuinely must diverge per-project beyond
  the namespacing — the audit answers this.

## References

- `DESIGN.md § Self-enforcement` ("adopter infra is a later initiative")
- `REQUIREMENTS.md § Vision` (portable, version-controlled configuration)
- `rules/project-layout.md` (project `.claude/` layout; skills/rules as
  project overrides)
