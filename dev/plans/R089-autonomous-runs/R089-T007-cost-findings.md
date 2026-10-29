---
task: R089-T007
type: mnt
mode: normal
---

- [ ] `context-cost.py --cost-block` prints the report template's token line
  for the sessions given: their subagents' billed context in total and as
  implementer (`dev-implementer`), reviews (`code-reviewer`,
  `dev-docs-verifier`) and other, a subagent lacking a `.meta.json`
  `agentType` counted as other. Approach: `context-cost.py`, within
  `check-code-size.sh`'s 300 lines; a case in `context-cost.test.sh`.
- [ ] The cost block adds the seat prompt size line: the implementer's
  definition words, from the `agents/` file the session resolved, plus the
  median words of its dispatches, each the first user record of its
  subagent transcript. Approach: the same two files, the fixture's
  definition under a throwaway `CLAUDE_CONFIG_DIR`.
- [ ] An install ships `scripts/context-cost.py` with its self-test, the test
  finding the tool beside itself rather than at the git top level.
  Approach: `install-dev.sh` § 4 beside the permission pre-flight, then the
  copied-set assertions of `install-dev.test.sh` and
  `install-dev-minimal.test.sh` (`MAINTENANCE.md`'s install doc-sync row).
- [ ] `report-template.md § Cost` takes its token and prompt size lines from
  `<config>/scripts/context-cost.py --cost-block` over the runner's own
  transcript, every session of a resumed run named, and its defect line
  from the members' `## Review` entries; the prompt line keeps one measured
  figure beside its baseline. Approach: that section alone.
- [ ] Code contradicting a written decision, one a home of
  `rules/writing-artifacts.md § One home per finding` records, is a finding
  with `Evidence: contract <the decision>`, shown by reading or by an input
  the reviewer built. Approach: the evidence sentence of `dev-instructions.md
  § Scope`, then `agents/code-reviewer.md § Evidence` citing it for its
  hypothetical clause.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 3 (source): A full install ships `scripts/context-cost.py`, the
  session context-cost reporter, with its self-test.

## Proven

- none
