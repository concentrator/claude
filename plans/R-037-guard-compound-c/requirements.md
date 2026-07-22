---
approved: 2026-07-22
kind: bug
---

# R-037: Branch-guard compound detection - options before checkout

## Observed behavior

The Bash arm's branch-create exemption matches only a bare
`git checkout|switch`: global options between `git` and the verb defeat
it. `git -C <path> checkout -b x && git -C <path> commit -m y` is
unrecognized as a branch-create, falls through to the `-C` repo
judgment, and is denied when that repo is on a trunk - though the commit
lands on the new branch. Hit live: a branch-and-commit one-liner on this
repo was falsely denied.

## Expected behavior

The exemption tolerates global options (`-C <path>`, `-c key=val`)
between `git` and `checkout`/`switch` - the same option-skipping the
commit-detection regex already performs. Unchanged: a trunk-named
branch-create and echo-text fakes still deny; the exemption still
requires a command-head position.

## Reproduction steps

1. `cd` into a repo on `main`.
2. Pipe a Bash tool-call JSON with command
   `git -C <repo> checkout -b feat/x && git -C <repo> commit -m y` into
   the hook.
3. Observe a deny; expected: silence (allow).

## Impact

Every branch-and-commit one-liner using `git -C` (scripted flows,
multi-repo sessions) is falsely denied and must be split. Annoyance-level
severity; the deny is conservative, not unsafe.

## Acceptance criteria

- [ ] `git -C <repo> checkout -b <branch> && git -C <repo> commit` is
  allowed; the `-c key=val` form likewise.
- [ ] Still denied: creating a trunk-named branch, echo-text
  `checkout -b` fakes, and a plain `git -C <main-repo> commit`.
- [ ] All existing pins green; new pins for the exempted and adversarial
  `-C` shapes; suite + Tier-1 green.

## Constraints

- Bash arm only; mirror the existing commit-regex option group.
- TDD slice: pins and regex change in one commit.

## Open questions

- none

## References

- R-024 / T-058 (compound detection), R-036 (Write-arm target scope).
