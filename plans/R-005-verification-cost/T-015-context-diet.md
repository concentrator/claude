task: T-015
type: refactor
architecture-changing: true

# refactor/context-diet — extract templates, path-scope planning rules (R-005)

Lever 5 and acceptance criterion 5 of
`plans/R-005-verification-cost/requirements.md`: every dispatch pays a
~28k fixed baseline, ~7.7k of it always-loaded rules, while
`planning.md § Templates` (362 of 1080 words) is consumed only at
requirements-drafting time. Manual mode only (no agentic stamp): the
branch needs fresh-session `/context` runs and load-behavior checks
performed with the user.

Ground truths this plan relies on (grep/read 2026-06-12):

- Actual `§ Templates` consumers: `brainstorming` (step 5),
  `starting-a-project` (§ 1 Requirements), `migrating-to-dev`
  (requirements step), plus planning.md's own internal pointer.
  `writing-plans` references only `branch-plan.md` — nothing to
  repoint there.
- A path-scoped rule stays readable on demand, so plain path
  references (`CLAUDE.md § Temporary Files`, `dev`, the execution
  skills) remain valid without edits — verified, not assumed, in the
  sweep below.
- Glob precedent: `rules/skills.md` (`**/skills/**/SKILL.md`) fires on
  `~/.claude/skills/...` reads, so `**/` crosses the `.claude`
  dot-segment. Self-hosting: this repo's plans live at root `plans/`.
  Required trigger set per rule: any project's `.claude/plans/**`,
  this repo's `plans/**`, and the rule's own file.

- [x] Baseline measurement, before any rule edit: with the user, open
      a fresh session in this repo and run `/context` before touching
      any file; record in a new
      `plans/R-005-verification-cost/T-015-context-diet.findings.md`
      § Measurements — total context tokens, the memory-files/rules
      contribution, and `wc -w` of the three targets (planning.md
      1080, branch-plan.md 1075, project-layout.md 353). Commit the
      findings file only.
- [x] Extract `## Templates` from `rules/planning.md` into new
      `rules/planning-templates.md` (`# Planning templates`;
      subsections promoted one heading level, content verbatim) with
      `paths:` frontmatter scoped to the files the templates
      instantiate — `**/REQUIREMENTS.md`,
      `**/plans/R-*/requirements.md`, `**/plans/release-v*.md`,
      `**/rules/planning-templates.md` — so implementer dispatches
      (plan checkboxes, findings) never match it. Replace planning.md's
      internal `(template: § Templates)` with a `planning-templates.md`
      pointer; repoint the three consumers (brainstorming step 5 →
      `§ Per-initiative`; starting-a-project § 1 and migrating-to-dev
      requirements step → `§ Foundational`), verifying `wc -w` caps on
      each edited SKILL.md; finish with a repo-wide grep for
      `§ Templates` — zero references against planning.md remain.
- [x] Path-scope the three rules — add `paths:` frontmatter, bodies
      untouched: each gets `**/plans/**` plus its own file
      (`**/rules/planning.md`, `**/rules/branch-plan.md`,
      `**/rules/project-layout.md`). The single `**/plans/**` covers
      both `.claude/plans/**` in projects and this repo's root
      `plans/**` per the glob precedent above; if the next item's
      verification shows a gap, add the explicit
      `**/.claude/plans/**` / `plans/**` pair rather than widening
      further.
- [x] Load-behavior verification (gates everything after) — fresh
      sessions with the user: (a) read a file under this repo's
      `plans/` → all three rules load; (b) same under
      `wallarm-api-js/.claude/plans/` → same; (c) a session touching
      only non-planning files (e.g. a `.js` in that project) loads
      none of the three; (d) `Read ~/.claude/rules/planning.md` by
      path still works mid-session. Record per-case evidence in the
      findings file. If (a) or (b) fails after one pattern adjustment,
      that is a blocker — stop per branch-plan.md § Scope discoveries;
      scoping planning rules out of the very sessions that need them
      is the regression this branch must not ship.
- [ ] Docs + inbound sweep: DESIGN.md — `rules/` component line and
      tree-map (`always-loaded rule files` → path-scoped; add
      `planning-templates.md`; planning.md comment drops "templates");
      README.md `rules/` row likewise; then grep
      `rules/(planning|branch-plan|project-layout).md` repo-wide and
      confirm every referenced section survives the extraction
      (CLAUDE.md § Temporary Files → `§ Where things live` intact;
      `dev`, `finishing-a-branch`, execution skills → branch-plan
      sections intact), fixing any straggler. (This is the DESIGN.md
      commit required by the `architecture-changing` header.)
- [ ] After measurement: rule loading follows working-tree state, so
      with all rule edits in place this equals the post-final-commit
      baseline — rerun the exact baseline protocol (fresh session in
      this repo, `/context` before touching any file) and record the
      after numbers plus delta vs baseline in findings § Measurements:
      the evidence for criterion 5 ("per-dispatch fixed baseline
      measurably reduced; planning rules load only in sessions that
      touch planning artifacts").
- [ ] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), triage and resolve the findings file, mark
      plan complete, commit.
