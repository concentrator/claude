---
task: R040-T007
type: fix
---

Branch: `fix/worktree-discipline`.

Two fixes in `supervise.md`, from one stage-2 incident.

**What happened.** The supervisor created a plan branch with a bare
`git switch -c` inside the worker's working tree while the member branch
was checked out, so the new branch took that branch tip as its base
rather than `main`. Merging the resulting plan MR carried fourteen
unreviewed member commits onto `main`, ahead of the per-branch close
review, the batch full-diff review, the per-claim verification gate and
the report. That verification gate then found 29 false claims and 12
provenance overstatements which eight passing spec checks and every
green project gate had missed - two operator-facing, one of which
misroutes a query to a hard-coded client id. Separately, switching the
same tree's branch while eight verifier subagents were reading files
from it could have had them verify content other than what they
reported on; it did not, but only because the two branches happened to
hold identical bytes.

**Why the text did not prevent it.** `supervise.md` says the supervisor
never implements and never edits plans, and says nothing at all about
the working tree - while the local transport puts supervisor and worker
in the same checkout by default.

- [ ] State the worktree rule as an absolute, not a caution. The
      supervisor performs read-only inspection through explicit refs
      (`git -C <repo> show <ref>:<path>`, `git -C <repo> log`) and never
      runs a command that moves HEAD, creates a branch, stages, stashes
      or checks out in a worker's tree. Where it must author plan
      artifacts in an adopter repo, it takes its own worktree or waits
      for the worker to report idle - and cuts branches as
      `git switch -c <name> origin/main`, never the bare form, which
      inherits whatever HEAD happens to be. Say why in one line: a
      caution did not stop this, and the failure is silent at the time
      it happens.
- [ ] Add the batch-ref check to `§ Boundary verification`. A
      `batch/R<NNN>-B-XXX` still pointing at its `pre-R<NNN>-B-XXX`
      anchor while the member work is complete means the member branch
      never merged into it, so delivery went somewhere else. That was
      true throughout stage 2 and nobody looked. It costs one
      `git log -1` and it catches the failure above, so it belongs
      beside the report and gate checks rather than in prose.
- [ ] Complete the branch: `bash scripts/ci/run-all.sh` green, then mark
      this plan's checkboxes and commit. Closure is checkbox-only.
      R040-T007 does not close R-040.
