---
approved: 2026-06-16
kind: feat
status: done 2026-06-17
---

# R-009: Adopter-project TBD migration

## Motivation

The TBD model (R-006) is global in the rules, but projects built under the
pre-TBD model don't conform - and nothing migrates them. `wallarm-api-js` is
the live example: a full DEV project (R/T/batch hierarchy) that still
(1) merges branches **locally** into `main` and commits **directly to `main`**
(planning, closes, even code); (2) has `.claude/` file-organization drift from
`project-layout.md` (a non-canonical `source-spec.md` in an R-dir; no
`MAINTENANCE.md`); (3) closes batches/releases the old way - direct-commit
closes and a **fork-release-branch** release, not tag-on-trunk.
`migrating-to-dev` today only handles **non-DEV code → DEV**; nothing migrates
an **already-DEV, pre-TBD** project. Long-lived branches are *not* an issue in
these repos and are out of scope.

## Goals

- `migrating-to-dev` gains **mode detection**: "fresh" (non-DEV → DEV, current
  behavior) vs "already-DEV, pre-TBD" (run the TBD migration below).
- **Delivery:** detect local-merge / direct-to-`main` habits; establish
  PR-only delivery + the host PR gate going forward. History migrated forward,
  never rewritten.
- **Structure:** reconcile `.claude/` to `project-layout.md` - flag
  misplaced/non-canonical and missing files; propose moves.
- **Close/release:** closes ride PRs; releases become tag-on-trunk; retire the
  fork-release-branch habit, archive superseded release plans.
- `starting-a-project` establishes a protected trunk + PR gate from day one.
- Host-neutral (GitHub / GitLab).

## Non-goals

- Long-lived-branch retirement - not a real problem here.
- The portable per-repo enforcement layer (checks + ledger) - later R.
- Rewriting `main` history - forward-only.
- Auto-performing irreversible/host actions (deletes, moves, protection) -
  the user executes those.
- Changing the global TBD rules (`git-workflow.md` unchanged beyond the
  `plan/` prefix already added).

## User experience

`migrating-to-dev` detects state and routes:

- **Fresh (non-DEV):** unchanged - reverse-engineer REQUIREMENTS/DESIGN,
  backfill plans.
- **Already-DEV, pre-TBD:** a TBD-migration report over three areas:
  1. **Delivery** - scan recent `main` history for local-merge commits
     (`Merge branch … into '<default>'`) and direct-to-`main` non-scaffold
     commits; report the pattern; state the go-forward CI-gated-PR rule + host
     gate to enable. No history rewrite.
  2. **Structure** - diff tracked `.claude/` against `project-layout.md`; list
     non-canonical files (e.g. `source-spec.md` → `references/` or a recorded
     exception), missing expected files (`MAINTENANCE.md`), strays; propose
     moves.
  3. **Close/release** - confirm closes ride PRs going forward; convert the
     release flow to tag-on-trunk; flag fork-release leftovers, archive
     superseded release plans.
- The user executes all irreversible / host steps; the skill plans and reports,
  never deletes/moves/changes-host itself.

`starting-a-project`: after scaffolding, establish `main` as the protected
trunk + instruct the PR gate (host-neutral) - TBD-shaped from commit one.

## Acceptance criteria

- [x] `migrating-to-dev` detects "fresh" vs "already-DEV, pre-TBD" and routes;
      fresh behavior unchanged.
- [x] Delivery audit reports local-merge and direct-to-`main` non-scaffold
      commits, and states the go-forward CI-gated-PR rule + host gate; no
      `main` history rewritten.
- [x] Structure audit diffs `.claude/` against `project-layout.md` and lists
      non-canonical files, missing expected files, and strays, with proposed
      moves.
- [x] Close/release guidance: closes ride PRs; release flow converted to
      tag-on-trunk; superseded fork-release plans flagged for archive.
- [x] The skill performs no irreversible or host action itself; the user
      executes them.
- [x] An already-TBD-conformant project yields a no-op confirmation.
- [x] `starting-a-project` establishes a protected trunk + PR gate from day one
      (host-neutral).
- [x] Host-neutral; the global TBD rules unchanged beyond the `plan/` prefix.
- [x] Skill word caps hold (`migrating-to-dev`, `starting-a-project`).

## Constraints

- Host-neutral: GitHub + GitLab; name the concept, point to `gh`/`glab`.
- Forward-only: never rewrite `main` history.
- Advisory: the skill plans/reports; the user executes irreversible + host
  steps ("never silently delete/move").
- Skill word caps (`migrating-to-dev` 239w, `starting-a-project` 285w of 300 -
  tight); may require trimming `starting-a-project`.
- Out of scope: long-lived branches, the enforcement template (later R).

## Open questions

- Where do non-canonical specs like `source-spec.md` belong - `references/`,
  or a recorded `project-layout.md` exception?
- "Already-DEV" detection signal - presence of `.claude/plans/ROADMAP.md`? an
  `approved:` marker?

## References

- R-006 (the TBD model; "adopter infra is a later initiative").
- `skills/migrating-to-dev/SKILL.md`, `skills/starting-a-project/SKILL.md`.
- `rules/project-layout.md` (canonical `.claude/` layout - the structure target).
- `rules/git-workflow.md § Trunk`, `§ Enforcement`, `§ Releases - tag-on-trunk`.
- `wallarm-api-js` (grounding: local merges, direct-to-main, `source-spec.md`
  drift, fork-release-branch).

## Closure verification (2026-06-17)

One-line evidence per criterion (T-020, T-021 merged):

1. `migrating-to-dev/SKILL.md` Mode section detects `.claude/plans/ROADMAP.md`
   → already-DEV vs fresh; fresh sections unchanged. [T-020]
2. `tbd-migration.md § 1 Delivery` scans `--merges` / `--no-merges
   --first-parent`; states go-forward CI-gated-PR + host gate; no history
   rewrite. [T-020]
3. `tbd-migration.md § 2 Structure` diffs `.claude/` vs `project-layout.md`;
   non-canonical → `references/` or exception; missing/strays; proposes moves.
   [T-020]
4. `tbd-migration.md § 3 Close/release`: closes ride PRs; tag-on-trunk; archive
   superseded release plans. [T-020]
5. Advisory framing in the SKILL Mode bullet + companion header (skill
   plans/reports; user executes irreversible/host steps). [T-020]
6. SKILL Mode: already-TBD-conformant → "report conformant, no changes". [T-020]
7. `starting-a-project § 4` establishes a protected trunk + PR gate from day
   one, host-neutral. [T-021]
8. Host-neutral (`gh`/`glab`); global TBD rules unchanged (the `plan/` prefix
   landed separately). [T-020/T-021]
9. Caps hold: `migrating-to-dev` 297w, `starting-a-project` 296w (≤300). [T-020/T-021]
