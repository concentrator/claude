task: T-040
type: refactor

# refactor/relocate-rules — DEV process rules → skills/dev/ companions (R-021)

T-040 of `plans/R-021-command-toolset/`, per `manifest.md`. Copy the five
DEV process rules into `skills/dev/` as inert **companion mode files**
(strip `paths:` frontmatter; rewrite cross-refs to the short companion
names), plus the hybrid `git-workflow` copy. Originals stay in `rules/`
until cut-over/removal (T-044/T-045); the companions are **dormant** — the
`dev` skill doesn't read them yet, so `/dev` is unchanged.

## Notes

- **Refs to stay-global rules:** if a copied companion references `js`,
  `skills`, or `claude-md` (which stay in `rules/`), inline the guidance it
  needs so the companion is self-contained for a no-global contributor (per
  manifest). Cross-refs among the moved rules use the short companion names
  (`plan`, `branch-plan`, `templates`, `layout`, `changelog`).
- **Gate:** companions live under `skills/dev/` (below the top level), so
  `check-stray` (top-level only) and `check-caps` (SKILL.md/CLAUDE/DESIGN
  only) don't flag them — no DESIGN change needed here. The full
  `skills/dev/` tree-map refresh happens at cut-over/cleanup, kept compact
  to respect the DESIGN cap.

- [ ] `skills/dev/plan.md` from `rules/planning.md` — strip `paths:`;
  rewrite refs (branch-plan, templates, layout).
- [ ] `skills/dev/branch-plan.md` from `rules/branch-plan.md` — strip
  `paths:`; rewrite refs.
- [ ] `skills/dev/templates.md` from `rules/planning-templates.md` — strip
  `paths:`; inline any stay-global ref (e.g. `claude-md`) it needs.
- [ ] `skills/dev/layout.md` from `rules/project-layout.md` — strip `paths:`.
- [ ] `skills/dev/changelog.md` from `rules/changelog.md` — strip `paths:`.
- [ ] `skills/dev/git-workflow.md` — copy of `rules/git-workflow.md` (hybrid
  toolset copy; the global rule stays).
- [ ] Complete the branch: re-review cross-refs across the companions, mark
  plan complete, commit.
