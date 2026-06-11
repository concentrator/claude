task: T-004
type: refactor
architecture-changing: true

# refactor/uppercase-docs — uppercase foundational docs (REQ-002 A1)

References first, then the case-only `git mv` (macOS: always git mv,
never Finder). Manual mode (renames live index files). History is not
rewritten: closed plans and historical REQ narrative keep lowercase
mentions; the grep-clean target covers rules, skills, agents, root
docs, and open-REQ normative references.

- [ ] rules/planning.md: all five names incl. the foundational/REQ
      template headings.
- [ ] rules/project-layout.md + rules/branch-plan.md: tree, creation
      policy, design-doc references.
- [ ] CLAUDE.md (§ Temporary Files) + README.md (contents table, prose).
- [ ] Skills batch 1: writing-plans, brainstorming, starting-a-project,
      migrating-to-dev, dev (if any).
- [ ] Skills batch 2: delegating-to-agents + both prompts,
      finishing-a-branch, release, adding-a-feature, fixing-a-bug,
      doing-a-refactor, agents/code-reviewer.md.
- [ ] Self-references inside the five docs themselves (design.md
      tree-map + components, maintenance.md cross-refs,
      requirements.md constraints).
- [ ] `git mv` the five files: requirements.md→REQUIREMENTS.md,
      design.md→DESIGN.md, maintenance.md→MAINTENANCE.md,
      roadmap.md→ROADMAP.md, tasks.md→TASKS.md.
- [ ] Open-REQ normative refs (REQ-001, REQ-003): design/roadmap/tasks
      mentions updated; REQ-002 historical narrative left as-is.
- [ ] Grep sweep: no lowercase forms outside closed plans/historical
      narrative; `git ls-files` confirms case-only renames registered.
- [ ] Complete the branch: re-review docs across all commits, cleanup,
      mark plan complete, commit.
