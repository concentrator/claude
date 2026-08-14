---
task: R044-T002
type: feat
---

# R044-T002 - batch-tag gate

Branch: `feat/batch-tag-gate`.

- [x] Stale-anchor detection: `scripts/ci/check-batch-tags.sh` fails on
      a `pre-R<NNN>-B-<MMM>` tag whose `B-<MMM>.report.md` exists under
      the initiative's `batches/` (in `plans/` or `plans/archive/`),
      naming tag, initiative, and report; live anchors and tag-free
      trees pass. Registered in the `run-all.sh` loop; self-test
      (`scripts/test/check-batch-tags.test.sh`, throwaway repo) covers
      fail, archived-report fail, live pass, clean pass; wired into
      `scripts/test/run-all.sh`.
- [x] CI skip: `$CI` set or shallow clone → `check-batch-tags: SKIP
      (tags not visible)`, exit 0 - never a silent OK; test asserts the
      skip line both ways.
- [x] Legacy form: any flat `pre-B-*` tag fails as unresolvable (no
      initiative to check a report against); test asserts.
- [x] Doc sync: `DESIGN.md § Self-enforcement` and tree-map entries for
      the check and its test.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
