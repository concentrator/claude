task: T-045
type: refactor

# refactor/remove-superseded — drop the relocated originals (R-021)

T-045 of `plans/R-021-command-toolset/`. **Phase C — where the isolation
takes effect.** The router now reads `skills/dev/` companions (T-044,
validated by a full migrate run), so remove the superseded originals.

**Remove:**
- Rules (relocated in T-040): `rules/{planning,branch-plan,planning-templates,project-layout,changelog}.md`.
- Skills (relocated in T-041/T-042): `skills/{adding-a-feature,fixing-a-bug,doing-a-refactor,writing-plans,finishing-a-branch,release,delegating-to-agents,brainstorming,migrating-to-dev,starting-a-project}/`.

**Keep:** `skills/dev/` (router + companions); the **bundled** skills
(`test-driven-development`, `systematic-debugging`,
`verification-before-completion`, `receiving-code-review`,
`dispatching-parallel-agents`); `skill-creator`, `writing-skills`,
`wallarm-*`; personal rules (`git-workflow`, `js`, `skills`, `claude-md`).

## Safety — scan for dangling refs BEFORE deleting

This is irreversible-ish (no instant fallback). Grep the **kept** files
(CLAUDE.md, kept rules, bundled skills, `skills/dev/` router + companions,
`scripts/ci/*`, DESIGN.md) for references to the removed rules/skills;
rewire to the `skills/dev/` companions (or inline) so nothing dangles. The
scan gates the deletion.

- [x] Scan + fix refs: grep kept files for the 5 rules + 10 skills; rewire/inline any reference so none dangle after removal.
- [x] Remove the 5 relocated rules from `rules/`.
- [x] Remove the 10 relocated skill dirs from `skills/`.
- [x] Update `DESIGN.md` tree-map: drop the deleted rules/skills; enumerate the `skills/dev/` companions (words freed by the deletions); stay ≤1000.
- [x] Update `CLAUDE.md` if it referenced any removed item.
- [x] Complete the branch: full gate green (references, plan-integrity, caps, stray); close review via `/code-review` (deletion — catch dangling refs, not `/simplify`); mark plan complete.
