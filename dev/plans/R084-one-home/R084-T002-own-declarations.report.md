# R084-T002 report

## Implementer
### Divergences
- Item 1: `migrate.md § 5` now names both instruction files for the
  `--project` install's plan-text gate append. It is the only place in
  `migrate.md` that names the root file, and the approach lists
  `migrate.md`, so the prose moves in this commit and item 4 brings the
  installer in line with it.
- Item 1: generic `CLAUDE.md § <section>` citations in `agents/`,
  `run.md`, `handoff.md`, `git-workflow.md` and `seat-permissions.md`
  stay as they are. They do not say the root file, and both files are
  named `CLAUDE.md`. Script comments that say the root file go with
  items 2-4, which edit those scripts.
- Item 2: the header comments of `check-accretion`, `check-archival`,
  `check-batch-tags` and `check-plan-integrity` that named the root
  file now cite `companions/declarations.md`, in place of the
  `plan.md § Where things live` citation where the last two carried
  one. `check-stray` has no self-test and the `check-plan-text` one
  declares no tree, so neither gains a case.
- Item 3: the pre-flight reads a section, not a line, so "first line
  found" becomes the `## Agent toolchain` section of the first file
  holding one: the awk read runs over both files and stops when the
  section ends or its file does.
- Item 3: `worker-workspace.test.sh` had no case running
  `exclude_session_tree`, only the dry-run text, so its new case 48 runs
  `project-clone` against local fixture checkouts; `npm ci` fails there
  after the exclude is written, which is all the case reads.
- Item 3: `preflight-permissions.sh` stood at the code-size gate's 300
  lines, so the header comment of `toolchain_rules` is reworded one line
  shorter while it takes the second file; case 48 is kept to the lines
  `worker-workspace.test.sh` has left under the same cap.
- Item 4: the gate lands on the first `Test (fast):` line across the
  two files, then the first `Test:` line, so a fast-tier line in
  `.claude/CLAUDE.md` wins over a `Test:` line in the root file. The
  closing CI notice names the file holding the line, or both files
  when neither holds one.
- Item 4: `install-dev.sh` stood at the code-size gate's 300 lines, so
  the step 7 header comment is one line shorter and the temp-file
  write shares a line with its `awk`.
- Item 5: the new `.claude/CLAUDE.md` opens with a `# Project
  instructions` title above the three moved sections, so the file reads
  as an instruction file; the sections themselves carry no preamble.

## Review
