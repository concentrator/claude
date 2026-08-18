# R051-T003 findings

Decision evidence for this branch.

## The vendoring path needed no change

`install-dev.sh` copies the two shipped self-tests with a plain `cp`. Only
`ci/check-accretion.sh` is rewritten on the way, and only its `MARKERS`
line, so an adopter's tuning survives a re-install. No test body is
filtered or rewritten, so T001's scrub reaches adopters through the
existing update path with no change to the installer.

That is why this task ships an assertion rather than a fix: the content is
already correct, and what was missing was anything that notices if a later
edit vendors the scrub away.

## Both assertions were proved against an unscrubbed vendor

Stripping the scrub from `scripts/test/check-batch-tags.test.sh` and
re-running the installer test failed both new cases: the whole-line grep
named the file, and the dynamic case caught the copied test committing and
tagging in the stand-in adopter repo. The static case alone would pass a
scrub quoted in a comment, and the dynamic case alone would not say which
file lost it, so both are kept.

## The negative proof wrote into the repository

The dynamic case runs a vendored copy under a leaked git environment,
which is the point of it. An unscrubbed copy then does what R-051
describes, and one consequence is not a host mutation at all:
`check-batch-tags.test.sh` builds fixtures with `d=$(mkrepo)`, and under
a leak `mkrepo`'s `git commit` finds nothing to commit and prints
`On branch main / nothing to commit` to stdout. That output becomes `$d`,
and `mkdir -p "$d/plans/..."` creates it as a directory relative to
wherever the test was invoked. Proving the assertion bites therefore left
a directory of fixtures at this repository's root, named after git's own
message.

So the case now runs from a throwaway cwd. The leak still reaches the
stand-in adopter repo, which is what the assertion measures, but a
misplaced relative write lands in a directory that is discarded.

Two things this exposes, neither owned by this branch:

- `scripts/ci/check-stray.sh` reported OK with that directory present, so
  a stray directory at the repository root is not covered by the gate
  that exists to catch strays.
- Capturing a path from a function whose body can print to stdout is the
  underlying fragility. Every `d=$(mkrepo)` in the suite shares it, and a
  scrubbed environment only hides it.

## Host state is checked before exit status

The dynamic case asserts three things in order, because the order decides
whether either failure branch is reachable. A leaking copy both mutates
the host and exits nonzero, so testing the exit status first would report
every real leak as "did not run" and leave the mutation branch with no
case that reaches it. Host state is the definitive evidence and is
checked first; only a clean host has to prove the run happened, which is
what stops an early exit - an older git rejecting `init -b`, a failed
`mktemp`, a botched copy - from reading as isolation.

Both branches were exercised: an unscrubbed vendored copy reports the
mutation, and a copy made to exit immediately with its scrub intact
reports that it never ran.

Both shipped tests now run through the harness. The static grep matches
its line anywhere in a file, so it cannot see a git call placed above the
scrub; running each vendored test is what covers that, and the pair costs
a few seconds.
