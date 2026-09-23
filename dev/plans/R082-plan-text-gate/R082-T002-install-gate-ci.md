---
task: R082-T002
type: mnt
mode: normal
depends-on: R082-T001
---

# R082-T002: install wires the gate into the fast tier

Branch: `mnt/install-gate-ci`. Requirements:
`dev/plans/R082-plan-text-gate/requirements.md § Outcomes` 2.

A project's fast tier is its `CLAUDE.md § Agent toolchain` `Test
(fast):` line, or the `Test:` line serving both tiers
(`companions/declarations.md § Declared commands`). The installer
already ships `check-plan-text.sh`; it now also names it on that line,
so every per-commit run in the project runs the gate. Project CI
config stays the project's. The gate this wires is the one R082-T001
delivers, and both tasks edit `scripts/install-dev.sh`.

- [x] A `--project` install into a git repo, full or `--minimal`, appends
  `, then` and `bash <path>/scripts/ci/check-plan-text.sh` (repo-relative
  path, its own backtick span) to the root `CLAUDE.md` `Test (fast):` line,
  else to its `Test:` line.
  Approach: a step beside step 7 of `scripts/install-dev.sh`, reading
  `CLAUDE.md` as step 7 reads `Session:`; test both lines, and `--minimal`.
- [x] A line already naming `check-plan-text.sh` stays as it is. With no
  such line or no `CLAUDE.md`, the install writes nothing and prints one
  line naming the line to add. A global or non-git install leaves every
  `CLAUDE.md` alone.
  Approach: `scripts/test/install-dev.test.sh` cases for re-install, absent
  line plus its notice, global install.
- [x] A `--project` install into a git repo prints one line saying the
  project's CI must run the fast tier; it edits no project CI config.
  Approach: the closing echo of `scripts/install-dev.sh`; assert the line
  in the item-1 cases.
- [x] The close review's two findings resolve, each marked `[x]` in the
  report: the gate append keeps the project CLAUDE.md's file mode with
  no added line; the item-2 divergence is a plain bullet.
- [ ] Docs (doc writer): `README.md § Installing the toolset elsewhere`
  (the "yours to wire" and "leaves the declaration" sentences),
  `skills/dev/start.md § 4` and `skills/dev/migrate.md § 5` state that the
  install wires the gate and prints the CI notice.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan
  complete, mark the task `[x]` in the R's `tasks.md` plus any
  release-plan entry, commit.
