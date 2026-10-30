---
task: R089-T002
type: mnt
depends-on: R089-T001
mode: normal
---

- [x] A full install ships `check-archival.sh`, the Tier-1 gate `plan.md
  § Archival`, `run.md § Close` 4 and `finish.md § 4` cite, with its
  self-test, which finds the check beside itself; unwired, as the other
  shipped checks are, and named in the install's summary line. Approach:
  `install-dev.sh` § 4, `check-archival.test.sh`'s `CHECK`, then the
  copied-set assertions of `install-dev.test.sh` and `-minimal.test.sh`.
- [x] `finish.md § 3` step 1 gates on the declared `Test (fast)` and
  `Test (full)` commands, which carry the gates an install appends, and
  names no `ci/run-all.sh`: that runner is this repository's own, calling
  checks no install ships. Approach: that step alone.
- [x] `rules/claude-md.md § Approval` stops saying the user tier's
  `permissions.ask` holds every `CLAUDE.md` edit, a rule no install writes:
  the edit needs explicit approval, which such a rule raises as a prompt
  where the user keeps one. Approach: that bullet alone.
- [x] The dogfood skill's preparation puts the cloud install in the run
  environment's setup script - a shallow clone outside `~/.claude`, then
  the global install - and brief step 1 checks the install, the `/dev`
  skill and `~/.claude/hooks/`, recording its absence, instead of running
  it. Approach: run the lines under a throwaway `HOME` first, then
  `skills/dogfooding/` preparation and brief.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- Item 1 (source): A full install ships `scripts/ci/check-archival.sh`, the
  gate failing a closed initiative left unarchived, with its self-test.
- Item 4 (source): A cloud session gets the toolset from its environment's
  setup script, which shallow-clones the toolset outside `~/.claude` and
  runs the global install, so no command of the session installs it.

## Proven

- Under `auto`, a session's `bash scripts/install-dev.sh` is refused as Code
  from External and a copy of its files by hand as Auto-Mode Bypass:
  `docs/reports/dev-dogfood-report.md`
