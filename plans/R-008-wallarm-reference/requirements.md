---
approved: pending
kind: feat
---

# R-008: Wallarm reference skill

> Stub — seed captured from a design discussion; shape via
> `/dev plan R-008`.

## Motivation

Wallarm domain knowledge (API references + conventions) is fragmented
across separate skills (`wallarm-api-tf-rules`, `wallarm-tf-usage`) and
isn't structured for multi-project, on-demand reuse. Multiple Wallarm
projects each need *different parts* of it (e.g. hits, sessions, rules)
without paying for the whole thing in context.

## Goals

- A single global reference skill `~/.claude/skills/wallarm/` as the one
  source of truth: a thin `SKILL.md` index/router + companion files per
  domain part (`hits.md`, `sessions.md`, `rules.md`, …).
- **On-demand, lazy loading** — only the `SKILL.md` description sits in
  context; the model reads the relevant companion per task, so a project
  pulls only the part it needs (low context cost, R-005 ethos).
- Global placement → automatically shared across all local Wallarm
  projects, zero per-project setup.
- Consolidate the existing `wallarm-api-tf-rules` / `wallarm-tf-usage`
  skills into this structure so knowledge isn't fragmented.
- **Split by load mechanism:** pure reference (hits, sessions) →
  skill companions (looked up on demand); enforced conventions that
  must auto-apply when editing Wallarm code → a **path-scoped memory
  rule** (`~/.claude/rules/wallarm.md`, `paths:` matching Wallarm
  repos), not the skill.

## Non-goals

- Cross-machine / teammate distribution (plugin + marketplace) — defer
  unless a non-local consumer appears.
- Runtime tooling; this is reference + conventions only.

## User experience

```
~/.claude/skills/wallarm/
  SKILL.md      # index: "Use when working with Wallarm APIs; load the
                #   relevant part: hits.md / sessions.md / rules.md"
  hits.md
  sessions.md
  rules.md
```
`SKILL.md`'s `description` is specific enough to trigger on Wallarm work
and routes to the parts.

## Acceptance criteria

- [ ] A single `wallarm` reference skill exists with a thin index +
      companion files per part; loads parts on demand (verified: a
      part-specific task pulls only its companion).
- [ ] `wallarm-api-tf-rules` and `wallarm-tf-usage` are folded in (or
      deprecated with pointers); no fragmented Wallarm skills remain.
- [ ] Enforced Wallarm conventions live in a path-scoped rule, not the
      skill (auto-apply when editing Wallarm code).
- [ ] Skill word caps respected (`SKILL.md` thin; companions per the
      reference-skill allowance).

## Constraints

- Domain accuracy: Wallarm API/schema content must come from the
  authoritative reference, never approximated (per `CLAUDE.md
  § Structured Data`).
- Companion sizing per `rules/skills.md` (reference skills: larger
  inline allowance; beyond that → split files).

## Open questions

- Which parts/domains to seed first (hits, sessions, rules — others?).
- Exact migration of the two existing TF skills (merge vs deprecate +
  redirect).
- Plugin packaging if/when a non-local consumer appears.

## References

- Existing skills `wallarm-api-tf-rules`, `wallarm-tf-usage`.
- `rules/skills.md` (reference-skill + companion-file pattern).
- R-005 (path-scoping mechanism for the conventions part).
- This session's design discussion (skill vs rule split, lazy parts).
