task: T-001
type: refactor
architecture-changing: true

# refactor/plans-layout - define the new planning layout (REQ-002)

Normative definition only: rules + skills describe the new layout.
File migrations are T-002 (this repo) and T-003 (wallarm-api-js).

- [x] planning.md: new Where-things-live table + naming conventions -
      `roadmap.md`/`tasks.md` at `.claude/` root; `plans/R-XXX-<slug>/`
      dirs (created lazily by writing-plans on first child plan; slug
      fixed at creation, no rename on roadmap rewording);
      `T-XXX-<slug>.md` + `.findings.md` plan files; `plans/batches/`.
      Include transition clause: files predating migration may sit at
      legacy flat paths; resolve both until the migration tasks close
      (clause removed by T-002).
- [x] branch-plan.md: plan, findings, and batch manifest paths updated
      to the new scheme; agentic-rails path references aligned.
- [x] project-layout.md: canonical `.claude/` tree updated.
- [x] writing-plans skill: output path `plans/R-XXX-<slug>/T-XXX-<slug>.md`,
      lazy R-dir creation step, bulk-mode paths.
- [x] dev skill: batch path `plans/batches/B-XXX.md`, plan-path
      references in routing table.
- [x] delegating-to-agents skill: batch manifest path, plan/findings
      paths in pre-flight and per-branch flow.
- [x] finishing-a-branch, release, brainstorming skills: path updates
      (REQ stays `plans/REQ-XXX.md`, release plans stay `plans/`);
      brainstorming needed no change - REQ path unchanged.
- [x] starting-a-project + migrating-to-dev skills: scaffold and
      adoption produce the new layout (incl. indexes at `.claude/` root).
- [x] design.md (§ Self-hosting layout + tree-map) and maintenance.md
      targets describe the new canonical layout; note that this repo's
      own file migration is T-002.
- [x] Grep sweep: no remaining flat-layout path references in rules,
      skills, CLAUDE.md (REQ-002 acceptance criterion); caught and
      fixed three execution skills missed by the plan's enumeration.
- [x] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.
