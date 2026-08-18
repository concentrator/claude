# R051-T001 findings

Decision evidence for this branch.

## The plan's enumeration was one short

The direct-path item lists nine fixture-creating tests.
`context-cost.test.sh` is a tenth, with a different exposure: it resolves
its subject through `git rev-parse --show-toplevel`, so a leaked `GIT_DIR`
does not mutate the host repository, it makes the test measure another
repository's script. Scrubbed here rather than deferred, as in-scope work
(`branch-plan.md § Scope discoveries`).

## The runner mutant fails for a different reason than predicted

Removing the scrub from `run-all.sh` was expected to redirect
`--show-toplevel` at the repository `GIT_DIR` names, so the runner would
find no tests and touch nothing. It instead reported `present|changed`:
with `GIT_DIR` set and no `GIT_WORK_TREE`, git treats the current
directory as the top of the work tree, so the runner does invoke its
tests and the leak reaches the host through them. The marker assertion is
kept even though the host-state assertion now carries the proof, because
it stops the case passing vacuously if a later change does redirect the
toplevel.

## The runner reported a pass having run nothing

The close review found `run-all.sh` resolving its root through
`git rev-parse --show-toplevel`, which writes nothing to stdout when
discovery fails. `cd ""` then succeeds without moving and `nullglob`
empties the loop, so from a directory outside any repository the runner
printed `test/run-all: ALL OK` and exited zero having run no tests. The
defect predates this branch, but the scrub removed the variable that had
kept discovery alive in a leaked-environment invocation, and a suite that
reports a pass without running is the failure class R-051 exists to
close. The root is now resolved from `BASH_SOURCE`, and a zero-test run
fails.

## Per-test dynamic proof, measured once and not kept

Each of the ten tests was run directly with an absolute `GIT_DIR`
exported at a throwaway host repository. All ten left its refs, local
config and HEAD unchanged and exited zero, in 29.7s.

That loop is not kept as a gate. It roughly doubles suite time, and
R051-T002's whole-suite assertion covers the same property in one extra
run rather than ten. The repeatable gates this branch ships are the
scrubbed/bare probe pair, which proves the mechanism on both invocation
paths, and the coverage scan, which is keyed on what a test does rather
than on a list of names so a new fixture-creating test must scrub or the
suite goes red.

## The coverage match is loose on purpose

The scan requires the scrub of any test that mentions git, which catches
a prose mention as well as a command. Its own negative case exposed this:
a fixture written to contain no git call still matched on the word. The
loose form is kept, because over-inclusion costs one redundant `unset`
while under-inclusion costs a leak, and the alternative is a list of
fixture-building idioms that a new test can sidestep.
