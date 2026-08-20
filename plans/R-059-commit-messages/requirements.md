---
approved: 2026-08-21
kind: doc
---

# R-059: Relax the commit-message rule

## Current state

`git-workflow.md § Commit messages` mandates a single-line subject and
bans bodies, multi-line descriptions, and `Co-Authored-By` tags. The
ban's goal was low verbosity, but its effect is to push change context
out of git: a no-diff move or a decision that belongs with its commit
gets recorded in findings and plan files instead, against
`writing.md § One home per finding`, which names the commit/MR message
as an owning artifact for history. Agent harness defaults that append
a trailer conflict with the ban on every commit, and three files
restate the single-line form (`branch-plan.md § Commit cadence`,
`release.md` step 9, `companions/spec-reviewer-prompt.md`).

## Desired state

Git is the home for change history. The subject constraints stay:
imperative, ~50 chars, no semicolon-joined clauses, the WHAT not the
HOW. An optional compact body is allowed when the subject cannot carry
the what/why - a no-diff move, a decision, a constraint - written as
short prose with no boilerplate and no restating of the diff; a
routine commit still ships subject-only. Trailers stay banned. The
three restating files defer to the rule instead of restating its form.

## Invariants

- Subject format and examples keep their meaning; the good/bad
  examples stay subject-level.
- The trailer ban (`Co-Authored-By` and kin) is unchanged.
- `§ MR/PR messages` is untouched.
- No new gate, hook, or check ships (`plan.md § Proportionality`).

## Scope

`skills/dev/git-workflow.md § Commit messages`;
`skills/dev/branch-plan.md § Commit cadence` step 3;
`skills/dev/release.md` step 9;
`skills/dev/companions/spec-reviewer-prompt.md` commit-message check.

## Acceptance criteria

- [ ] `git-workflow.md § Commit messages` permits an optional compact
  body carrying the what/why, keeps every subject constraint, and
  keeps the trailer ban; at least one good body example shows the
  boundary.
- [ ] No tracked rule or skill text still states that a commit message
  must be single-line: the restating files cite the rule or use
  wording that permits a body (grep for the old form matches nothing
  outside `archive/`).
- [ ] `bash scripts/ci/run-all.sh` is green.

## Constraints

- Prose-only change; commit history is never rewritten to the new
  form.

## Open questions

None.

## References

R-056 (its close review surfaced the conflict);
`writing.md § One home per finding`.
