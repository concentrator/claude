---
task: R086-T004
type: mnt
mode: normal
---

- [x] The plan-text gate fails a checkbox, `[ ]` or `[x]` after any list
  marker at any indent, in an initiative's `requirements.md` where the
  file's base copy lacks it, the mark ignored: a new file's box and a box
  added to an older file fail, an older box checked off passes. The gate's
  header comment is unchanged. Approach: `scan` in `req` mode of
  `scripts/ci/check-plan-text.sh`, with cases in its test.
- [ ] The per-initiative `requirements.md` template bars checkboxes beside
  links, dates, PR refs and measured values, citing the gate; its outcomes
  stay numbered.
  Approach: the paragraph on what the goal and outcomes carry, in
  `skills/dev/templates.md § Per-initiative`.
- [ ] A `--project` git install appends the code-size gate to the fast-tier
  line after the plan-text gate, each gate only where no line names it, so
  a re-install adds the missing one; the no-line notice names both. This
  repo's fast tier is unchanged. Approach: the append in
  `scripts/install-dev.sh`, near the size cap; cases in
  `install-dev-fast-tier.test.sh`; then `start.md` and `migrate.md`.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)
