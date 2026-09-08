---
task: R080-T005
type: mnt
depends-on: R080-T007
---

# R080-T005: pilot under the seats

Branch: `mnt/seat-pilot`. Requirements:
`dev/plans/R080-seat-model/requirements.md § Acceptance criteria`.

One real task runs end to end under the seats, in this repo, with the
user in the supervisor seat. What the pilot finds wrong in the flow is
fixed on this branch; the pilot's own subject ships on its own branch
under the flow.

- [ ] Pick the subject: an open task in this repo with no dependency
  on R080 (recorded here when chosen); a planner dispatch writes or
  re-reads its plan, the cold read passes, and both are ledgered.
- [ ] Run the pre-flight on the subject's scope: every adjustment it
  applies and every gap it reports ledgered; a gap is fixed in the
  declared set and the pre-flight re-run until it reports none.
- [ ] Run the subject through `run.md`: implementer dispatches per
  item, spec check, the doc-writer pass, close review, supervised
  merge; every dispatch text and report path ledgered; the implementer
  dispatch names no doc target; a prompt outside the declared set is
  ledgered as a pre-flight defect and fixed under the next item; a
  plan change the run needs goes through a planner re-dispatch, also
  ledgered.
- [ ] Fix what the pilot surfaced in the flow files and prompts, one
  commit per finding, each naming the ledger entry that motivated it.
- [ ] Verify R080's acceptance criteria with one-line evidence each in
  `requirements.md`: the grep for the retired declarations, the
  ledgered cold read and doc-writer report, the three prompts read
  against § Desired state 4, `git ls-files dev/docs` empty and the
  `dev/docs` grep, the duties table read against § Desired state 6,
  the pre-flight report and the ledger's absent prompt-cleared entry.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine`, `bash scripts/ci/run-all.sh` green, mark the task in
  `tasks.md`, R080 closure check per `plan.md § Approval and closure`
  (ROADMAP `[x]`, archival in the closing delivery, on the user's
  confirmation), cleanup, commit.
