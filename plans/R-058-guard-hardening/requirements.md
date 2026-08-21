---
approved: 2026-08-21
kind: feat
---

# R-058: Guard hardening

## Motivation

The `acceptEdits` session default (R-056) made three guards
load-bearing, and each has a verified gap. The push deny rules are
prefix matches, so equivalent spellings (`push origin HEAD:main`,
`+main`, `-f`, a trailing `--force`) fall through to the global
`Bash(git:*)` allow; server-side protection backstops `main` only,
leaving non-main force pushes unguarded. The secrets guard is a fixed
regex heuristic whose miss-backstop was the interactive edit prompt,
and no Tier-1 check scans for secrets. The branch guard's `is_trunk()`
recognizes only branches literally named `main`/`master`. None of
these gaps has fired; hardening them is approved by this initiative's
gate (`plan.md § Proportionality`).

## Goals

- A force push or a default-branch-targeting push is denied by the
  branch guard in any spelling, not only the two the settings deny
  encodes; task-branch pushes stay unprompted.
- A secret that reaches a tracked file fails Tier-1 (CI and pre-push),
  not only the write-time hook.
- The branch guard protects the repo's actual default branch, whatever
  its name.

## Non-goals

- Guarding out-of-repo writes (the branch guard owns trunk discipline,
  not the filesystem).
- Adopting an external scanner (gitleaks and kin); checks stay
  self-contained bash.
- Changing server-side protection or the MR/PR flow.

## User experience

- `git push -u origin <prefix>/*` behaves as today. A push carrying
  `-f`/`--force` in any position, a `+refspec`, or a refspec targeting
  the default branch is denied by the PreToolUse hook with a message
  naming the rule; the settings deny pair stays as a second layer.
- `bash scripts/ci/run-all.sh` gains a `check-secrets` step; a seeded
  secret in a tracked file fails it naming the file and pattern class.
- In a repo whose trunk is named neither `main` nor `master`, writes
  and commits on the trunk are denied exactly as on `main` here;
  detection failure fails open, as every guard does.

## Acceptance criteria

- [ ] Each named bypass spelling is denied by `dev-branch-guard.sh`
  and a task-branch push is allowed, one test per class in
  `dev-branch-guard.test.sh`.
- [ ] `check-secrets` runs in the Tier-1 suite, fails on a seeded
  secret of each pattern class in a tracked file, passes on the clean
  tree, and shares its pattern list with `dev-secrets-guard.sh` from
  one home (no duplicated regex list).
- [ ] `is_trunk()` resolves the default branch (`origin/HEAD`, then
  `init.defaultBranch`, then `main`/`master`), verified by a test
  repo whose trunk is named neither; unresolvable detection fails
  open.
- [ ] `bash scripts/ci/run-all.sh` and `bash scripts/test/run-all.sh`
  are green.

## Constraints

- One fix and one test per gap (`plan.md § Proportionality`); the
  deeper proof classes stay reserved to the two guards as already
  written.
- Guards keep their fail-open posture; no new prompt is introduced.

## Open questions

None.

## References

R-056 (made the guards load-bearing; its close reviews surfaced the
gaps); `companions/toolchain.md § Permission carve-out`;
`MAINTENANCE.md § Tier-2 AI review` (doc-sync pairs for new `ci/`
checks and hooks).
