---
task: R040-T008
type: doc
---

Branch: `doc/beyond-auto`.

Three symptoms of one assumption: the supervisor's texts describe a
worker running the `/dev auto` engine on a stamped batch, and say
nothing about the manual `/dev code` task branches that made up most of
the pilot's real delivery.

The pilot supervised four manual task branches to merge - attack-checker
R023-T002 through T004 and its closure - none of which carried a batch
report or a `plan/` prefix. Each was merged under the grant's stated
rationale with that reading written into the MR comment, because the
alternative was stalling delivery over a class the text neither names
nor excludes. That is a supervisor reasoning its way past written bounds
once per merge, which is the shape the bounds exist to prevent.

- [ ] `supervise.md § Dispatch`: state what a supervisor does when the
      scoped work is not a batch. Either name the manual task-branch
      class and say how it is supervised, or exclude it and say the
      supervisor reports rather than delivers it. Do not leave the
      reader to infer from the auto-engine description.
- [ ] `companions/declarations.md § Supervisor bounds`: the merge
      classes name green `plan/` MR/PRs and green batch/member MR/PRs
      whose report verifies the criteria. A manual task branch is
      neither. Add the class or exclude it explicitly - and if added,
      say what stands in for the checkpoint report, since that report is
      what the batch class relies on.
- [ ] `companions/toolchain.md`: the push carve-out narrows the deny to
      `git push -u origin batch/*`, so a manual task branch stalls at
      push time. Cover the task-branch prefixes a project actually uses
      (`doc/`, `feat/`, `fix/`, `refactor/`, `mnt/`, `test/`, `plan/`),
      keeping the deny on default-branch and force pushes untouched.
      This was pre-flighted by hand mid-pilot after it stalled a worker;
      the template should not need that.
- [ ] Complete the branch: `bash scripts/ci/run-all.sh` green, then mark
      this plan's checkboxes and commit. Closure is checkbox-only.
      R040-T008 does not close R-040.
