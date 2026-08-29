---
approved: 2026-08-30
kind: fix
---

# R067: Shipped toolset portability

Shaped from an adopter's push rejection: the self-tests that
`install-dev.sh --project` ships as tracked files must be acceptable to
any git host an adopter uses.

## Current state

`scripts/test/check-accretion.test.sh` case 16 builds its fixture as
`план.md`, in two places. The case tests that a filename git quotes
under default `core.quotePath` is still scanned, and that the same
name under `archive/` stays exempt; the script being Cyrillic is
incidental, since every non-ASCII name is quoted identically. The file
is shipped into adopter repositories as a tracked copy, so an adopter
whose git host rejects Cyrillic in file content cannot push the toolset
copy at all, and has no fix short of forking the copy from its source.
Observed on one such host: `PUSH REJECTED: Cyrillic characters are not
allowed`.

## Desired state

The fixture stays non-ASCII - `plán.md` - so case 16 tests exactly what
it tested, and no tracked file in the toolset carries a character in
the Cyrillic block.

## Invariants

- Case 16 keeps both assertions and its premise: the fixture name is
  one git quotes under default `core.quotePath`.
- The shipped self-test stays a byte-identical copy of its source
  (`scripts/test/install-dev.test.sh` asserts the copied set).

## Scope

- `scripts/test/check-accretion.test.sh` case 16, both occurrences.

## Acceptance criteria

- [ ] No tracked file carries a Cyrillic character. Evidence:
  `git ls-files -z | xargs -0 grep -ln -P '[\x{0400}-\x{04FF}]'`
  prints nothing.
- [ ] Case 16 still exercises a git-quoted filename. Evidence: the
  fixture name is non-ASCII and `bash
  scripts/test/check-accretion.test.sh` reports "quoted filename
  scanned" and "quoted archive filename exempt".
