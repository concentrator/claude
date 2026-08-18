# R051-T001 findings

Decision evidence for this branch.

## The enumeration and the scan's predicate

`context-cost.test.sh` is the only test in the directory that builds no
git fixture, which is why an enumeration of fixture-creating tests
omitted it. It still needs the scrub: it resolves its subject through
`git rev-parse --show-toplevel`, so a leak of `GIT_DIR` together with
`GIT_WORK_TREE` points it at another repository's script. Seven other
tests resolve their subject the same way. `GIT_DIR` alone does not
redirect them - with no work tree named, git regards the current
directory as the top of the work tree.

So the predicate that matches what the coverage scan enforces is "each
test that uses git", and the plan and the acceptance criterion state it
that way.

## The runner reports a pass only if it ran

`run-all.sh` resolves its root from `BASH_SOURCE`, not from
`git rev-parse --show-toplevel`, and fails when the glob matched nothing.
Discovery writes nothing to stdout when it fails; `cd ""` then succeeds
without moving and `nullglob` empties the loop, so a git-resolved root
turns a run from outside any repository into `test/run-all: ALL OK` at
exit zero. A suite that passes without running is the failure class
R-051 exists to close, so the runner cannot depend on the environment it
is scrubbing.

That resolution is also what keeps the mutant case honest. The case
asserts `present|changed`: an unscrubbed runner must reach the probe and
damage the host. `absent|same` would mean the probe never ran, proving
nothing - which is what a git-resolved root produces under this
fixture's three-variable leak, because the toplevel moves to the
repository the variables name and the glob finds no tests there.

## The coverage match is broad in selection, exact in verification

Selection is broad: any test that mentions git must scrub, including one
that only names it in prose. Over-inclusion costs a redundant `unset`,
under-inclusion costs a leak, and a list of fixture-building idioms is
something a new test can sidestep.

Verification is whole-line: the scrub must be its own line. An
unanchored match accepts the scrub quoted in a comment, and this file
quotes it in its own header, so the scan could call itself clean with
its scrub deleted. The suite carries both cases - a decorative mention
and a missing line.

## Every snap component carries its own leak

`snap()` reads refs, config, HEAD, the index and the git-dir listing. The
probe pairs move refs; an index-only case (`git rm --cached` under a
leaked `GIT_DIR`) moves nothing else; and a scrub that forgets
`GIT_INDEX_FILE` shows up only in the git-dir listing. A component with
no case of its own is decoration, and would let the leak it was added
for pass unnoticed.

## Per-test dynamic proof, measured once and not kept

Each of the ten tests was run directly with an absolute `GIT_DIR`
exported at a throwaway host repository. All ten left its refs, local
config and HEAD unchanged and exited zero, in 29.7s.

That loop is not kept as a gate. It roughly doubles suite time, and
R051-T002's whole-suite assertion covers the same property in one extra
run rather than ten. The repeatable gates this branch ships are the
probe pairs, the component cases, and the coverage scan.
