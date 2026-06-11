task: T-001
type: refactor
architecture-changing: true

# refactor/plans-layout — define the new planning layout (REQ-002)

Normative definition only: rules + skills describe the new layout.
File migrations are T-002 (this repo) and T-003 (wallarm-api-js).

- [ ] planning.md: new Where-things-live table + naming conventions —
      `roadmap.md`/`tasks.md` at `.claude/` root; `plans/R-XXX-<slug>/`
      dirs (created lazily by writing-plans on first child plan; slug
      fixed at creation, no rename on roadmap rewording);
      `T-XXX-<slug>.md` + `.findings.md` plan files; `plans/batches/`.
- [ ] branch-plan.md: plan, findings, and batch manifest paths updated
      to the new scheme; agentic-rails path references aligned.
- [ ] project-layout.md: canonical `.claude/` tree updated.
- [ ] writing-plans skill: output path `plans/R-XXX-<slug>/T-XXX-<slug>.md`,
      lazy R-dir creation step, bulk-mode paths.
- [ ] dev skill: batch path `plans/batches/B-XXX.md`, plan-path
      references in routing table.
- [ ] delegating-to-agents skill: batch manifest path, plan/findings
      paths in pre-flight and per-branch flow.
- [ ] finishing-a-branch, release, brainstorming skills: path updates
      (REQ stays `plans/REQ-XXX.md`, release plans stay `plans/`).
- [ ] starting-a-project + migrating-to-dev skills: scaffold and
      adoption produce the new layout (incl. indexes at `.claude/` root).
- [ ] design.md (§ Self-hosting layout + tree-map) and maintenance.md
      targets describe the new canonical layout; note that this repo's
      own file migration is T-002.
- [ ] Grep sweep: no remaining flat-layout path references in rules,
      skills, CLAUDE.md (REQ-002 acceptance criterion).
- [ ] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.
