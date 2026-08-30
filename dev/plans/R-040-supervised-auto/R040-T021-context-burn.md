---
task: R040-T021
type: doc
---

Branch: `doc/context-burn`.

A `/dev code` session burns ~6k tokens a minute into a window with
~85k of room after compaction, so compaction fires every ~14 minutes
(aikido session, 2026-08-28, `scripts/context-cost.py`). Two-thirds is
model output retained across the tool loop; the rest is tool I/O the
command shape chose: whole-file `cat`s of files already in context,
unfiltered `grep`, heredoc rewrites that resend the file as a command,
the pre-push hook's full test transcript on every push. The rebuilt
base is harness behaviour and out of scope.

## Terms used below

- **Setting check** - the Claude Code settings reference and hooks
  reference (`code.claude.com/docs/en/settings.md`, `hooks.md`), read
  for a setting that caps or truncates tool output, or a `PostToolUse`
  hook that rewrites a result. The verdict, with its source and read
  date, goes to `R040-T021-context-burn.findings.md`. A verified
  setting is a config change: reported with the verdict and adopted in
  `settings.json` only on approval, in which case the rule below
  shrinks to what it does not cover.
- **The rule** - a command prints only what the step needs: a status
  word, a count, the requested range (`grep -l`/`-c`, `sed -n`,
  `>/dev/null` on gates and pushes with the exit status echoed), never
  a file already in context; edits go through `Edit` on anchors, not
  heredoc rewrites.

## Commits

- [x] Setting check per § Terms, recorded in the findings file.
- [x] The rule, once, as a fourth point of `branch-plan.md § Commit
  cadence`; `companions/implementer-prompt.md` and
  `companions/supervisor-runbook.md` cite it in one line each.
  `branch-plan.md` stays under its word cap: the item includes the
  offsetting trim.
- [ ] Re-measure: at this branch's close, `scripts/context-cost.py
  --session <this session's transcript>` for the turns after the rule
  landed; tokens per minute and compaction interval against the
  baseline above, recorded in the findings file.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (prose row: `code-reviewer`), Tier-2 compliance review,
  `bash scripts/ci/run-all.sh` green, cleanup, mark plan complete,
  commit.
