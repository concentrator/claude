---
approved: 2026-08-06
kind: chore
status: done 2026-08-06
---

# R-041: Docs reconcile (this repo)

## Motivation

This repo authored the docs-lifecycle conventions (`plan.md § Archival`,
`writing.md § State the present`, composite task ids) without applying
them to itself: nearly all initiatives were closed yet every R-dir sat
in `plans/`, `ROADMAP.md` entries carried supersession markers and
dated status suffixes, and the corpus every `/dev` session grepped was
mostly closed work. Mirrors the adopter-side reconcile (attack-checker
R-020), scoped to what this repo has - no `.claude/docs/` layer.

## Goals

- **Archive the stock**: create `plans/archive/`; move every closed
  initiative's directory whole, and closed tasks' artifacts out of the
  open initiatives; promote first any fact a living doc still cites.
- **Gate compatibility**: `check-plan-integrity` verified (and extended
  if needed) to resolve archived paths, so the move cannot break CI.
- **Compaction pass**: `ROADMAP.md` and the open initiatives'
  `requirements.md`/`tasks.md` state the present - closed entries
  compressed, supersession markers and dated amendment notes removed
  (git history carries them).
- **Accretion gate**: the Tier-1 suite fails on supersession/amendment
  markers in living plan artifacts; `archive/` exempt.

## Non-goals

- Renumbering legacy `T-XXX` ids - valid, frozen, drained by archival.
- Rules/skills content changes - this initiative touches the plans
  corpus and the CI gate only.

## Acceptance criteria

- [x] `plans/` holds only open work: closed initiatives' directories and
  closed tasks' artifacts sit under `plans/archive/`; no living doc
  cites `archive/` for operative content. Verified: PR #227 (33 dirs
  moved, zero living citations found pre-move).
- [x] Tier-1 (`check-plan-integrity` included) green after the move.
  Verified: PR #227/#228/#230 pipelines - the check extended for
  archived paths and composite ids.
- [x] `ROADMAP.md` and open plan artifacts carry no supersession markers
  or dated amendment notes. Verified: PR #231 grep proof +
  `check-accretion` green on the compacted corpus.
- [x] The accretion check runs in the Tier-1 suite and is green.
  Verified: wired into `scripts/ci/run-all.sh`; self-test
  `scripts/test/check-accretion.test.sh` covers five cases.

## References

`plan.md § Archival`, `writing.md § State the present`,
`scripts/ci/check-plan-integrity.sh`, the attack-checker R-020 shape.
