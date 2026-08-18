---
task: R051-T002
type: test
depends-on: R051-T001
---

# R051-T002 - assert the host is untouched

Branch: `test/host-untouched`.

T001 scrubs the tests that exist. This guards the ones that do not yet:
a whole-suite assertion that catches a future fixture which forgets, which
is how this defect arrived in the first place.

The suite under test runs in a throwaway clone, never the live repository.
Running the live suite from inside a test would recurse, and would put the
thing being protected in the blast radius of the test protecting it.

- [ ] `scripts/test/host-untouched.test.sh`: clone the repository to a
      throwaway, snapshot the clone's refs, config and index, run that
      clone's `scripts/test/run-all.sh` with an absolute `GIT_DIR`
      exported, and compare. Bound the nesting so the cloned suite cannot
      invoke this case again - the clone's copy of this test is skipped or
      excluded, and the plan for how is part of the commit.
- [ ] Prove it bites: strip the scrub from the clone and confirm the
      comparison fails, naming what changed
      (`companions/verification-policy.md § Verification modality`). A
      comparison that cannot fail is a demonstration, not a check.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
