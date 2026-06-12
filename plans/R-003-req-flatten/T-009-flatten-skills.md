task: T-009
type: refactor
depends-on: T-008

# refactor/flatten-skills — update skills to the R-rooted chain (REQ-005)

Skills only: rules are T-008; this repo's and wallarm-api-js's file
migrations are T-010/T-011. Constraints held throughout: word caps
(`wc -w` after every skill edit — `dev` must net words OUT vs its
current 379; `delegating-to-agents` sits at 399 of its 400 cap), and
every in-dir requirements reference is path-qualified as
`plans/R-XXX-<slug>/requirements.md` to stay unambiguous against root
`REQUIREMENTS.md`.

- [x] dev skill: collapse the `REQ`/`REQ-XXX`/`roadmap` routing rows
      into `R` (new initiative via `brainstorming`) and `R-XXX`
      (state-routed: requirements pending → shape/approve; approved →
      add tasks); `batch` target path →
      `plans/R-XXX-<slug>/batches/B-XXX.md`; verify net words out
      (`wc -w` < 379).
- [x] brainstorming skill: new initiative as one act — output is a
      ROADMAP entry + `plans/R-XXX-<slug>/` dir +
      `plans/R-XXX-<slug>/requirements.md` (`approved: pending`, same
      template, no own id), method behind `/dev plan R`; update
      frontmatter description, draft step (next free `R-XXX` id), and
      Next step (propose tasks via `/dev plan R-XXX`).
- [x] writing-plans skill: chain resolution `T → R →
      plans/R-XXX-<slug>/requirements.md` for acceptance criteria;
      drop the lazy R-dir creation step (dir exists from
      initiative time); update Out-of-scope target names.
- [x] finishing-a-branch skill: §4 R-closure — when the last open task
      under the R closes, verify acceptance criteria in
      `plans/R-XXX-<slug>/requirements.md`; all verified → stamp
      `status: done YYYY-MM-DD` in its frontmatter + mark `R-XXX`
      `[x]`; run-dependent criteria pending → R stays open, report;
      index paths → `plans/ROADMAP.md`/`plans/TASKS.md`.
- [x] finishing-a-branch skill: auto-mode bookkeeping relocation —
      batch + task checkbox marking happens in the batch close phase
      on `batch/B-XXX` (lands via the MR); only the R-closure check
      and release-plan marking remain post-merge.
- [x] delegating-to-agents SKILL.md: R-scoped paths
      (`plans/R-XXX-<slug>/batches/B-XXX.md`, report beside) +
      single-R batch scope; "REQ criteria"/"REQ/design" wording →
      acceptance criteria from the R's
      `plans/R-XXX-<slug>/requirements.md`; `wc -w` ≤ 400.
- [ ] delegating-to-agents SKILL.md: close phase commits batch +
      member-task checkbox marks on `batch/B-XXX` before the
      checkpoint (no post-merge closure commit on the default branch);
      checkpoint re-triggers acceptance-criteria verification for
      run-dependent criteria of the R awaiting validation.
- [ ] delegating-to-agents auxiliary files: report-template.md report
      path → `plans/R-XXX-<slug>/batches/B-XXX.report.md` + an
      R acceptance-criteria status section; sweep
      implementer/spec-reviewer prompts and toolchain.md for REQ
      wording or batch paths (none expected — confirm).
- [ ] starting-a-project + migrating-to-dev skills: scaffold/backfill
      create `ROADMAP.md`/`TASKS.md` under `.claude/plans/`; tech-debt
      backfill produces R stubs (entry + dir + path-qualified
      `requirements.md`) instead of `REQ-XXX.md`; Next steps →
      `/dev plan R`.
- [ ] release skill: roadmap-prune path → `.claude/plans/ROADMAP.md`.
- [ ] Grep sweep across all skills: no `/dev plan REQ`/`roadmap`
      targets, no `plans/REQ-XXX.md` or global `plans/batches/`
      references (REQ-005 grep-clean criteria); re-verify `wc -w` for
      every edited skill against its cap.
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
