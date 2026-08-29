---
approved: 2026-08-30
status: done 2026-08-30
kind: fix
---

# R067: Shipped toolset portability

Shaped from an adopter's push rejection: the self-tests that
`install-dev.sh --project` ships as tracked files must be acceptable to
any git host an adopter uses.

## Current state

`scripts/test/check-accretion.test.sh` case 16 spells its fixture
filename in Cyrillic, three times on two lines. The case tests that a filename git quotes
under default `core.quotePath` is still scanned, and that the same
name under `archive/` stays exempt; the script being Cyrillic is
incidental, since every non-ASCII name is quoted identically. The file
is shipped into adopter repositories as a tracked copy, so an adopter
whose git host rejects Cyrillic in file content cannot push the toolset
copy at all, and has no fix short of forking the copy from its source.
Observed on one such host: `PUSH REJECTED: Cyrillic characters are not
allowed`. fp-remedy is that adopter: its toolset refresh (its
R010-T001, branch `mnt/toolset-refresh`, six commits) rewrote the copy
from this source and has sat unpushed since the rejection, with no MR.

## Desired state

The fixture stays non-ASCII - `plán.md` - so case 16 tests exactly what
it tested, and no tracked file in the toolset carries a character in
the Cyrillic block. fp-remedy's copy is refreshed from the fixed source
on its refresh branch, and that branch reaches the host and merges.
Other gl.wallarm.com adopters are left as they are, by the user's
ruling.

## Invariants

- Case 16 keeps both assertions and its premise: the fixture name is
  one git quotes under default `core.quotePath`.
- The shipped self-test stays a byte-identical copy of its source
  (`scripts/test/install-dev.test.sh` asserts the copied set).

## Scope

- `scripts/test/check-accretion.test.sh` case 16, every occurrence.
- fp-remedy's `.claude/scripts/test/check-accretion.test.sh`, refreshed
  by `install-dev.sh --project` on its `mnt/toolset-refresh` branch and
  delivered by an fp-remedy MR.

## Acceptance criteria

- [x] No tracked file carries a Cyrillic character. Evidence:
  `git grep -l -P '[\x{0400}-\x{04FF}]'` on `main` after R067-T002
  prints nothing.
- [x] Case 16 still exercises a git-quoted filename. Evidence: the
  fixture is `plán.md` (`scripts/test/check-accretion.test.sh` case
  16) and the suite reports "quoted filename scanned" and "quoted
  archive filename exempt".
- [x] fp-remedy's copy matches the source and its refresh is on the
  host. Evidence: `cmp` of fp-remedy's copy against the source is
  silent; fp-remedy MR !38 merged.
