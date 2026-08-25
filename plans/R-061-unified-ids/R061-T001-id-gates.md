task: R061-T001
type: mnt

# R061-T001 - Teach the gates the unified id shape

Branch `mnt/id-gates`. Each commit lands its test cases with the change
(`scripts/test/*.test.sh`), and every legacy fixture keeps passing.
Gate: `bash scripts/ci/run-all.sh`.

- [x] `check-plan-integrity.sh`: key initiatives by digits, not
      spelling - the ROADMAP set, the owning dir (`R-NNN-<slug>` or
      `RNNN-<slug>`, both globbed under `plans/` and `plans/archive/`)
      and a composite task id's `R` part all normalize to one key
      before comparison; messages print the id as it appears in the
      file. Tests: a new-shape tree (`R062:` entry, `R062-x/` dir,
      `R062-T001` tasks and plan) passes; a mixed tree of both shapes
      passes; a composite task misfiled under a new-shape dir is
      caught; the header comment names both shapes.
- [ ] `check-batch-tags.sh`: `judge` matches `R<NNN>-B<NNN>` beside
      `R<NNN>-B-<NNN>`, looks for the report as
      `R-?<NNN>-<slug>/batches/(B-<NNN>|R<NNN>-B<NNN>).report.md`, and
      resolves the initiative by digits; `want` strings and the header
      comment show the unified shape with the legacy one labelled.
      Tests: stale, live and unresolvable cases for `pre-R062-B001` and
      `batch/R062-B001`; the existing legacy cases unchanged.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
      release-plan entry.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
