task: T-041
type: refactor

# refactor/relocate-subskills — DEV sub-skills → skills/dev/ companions (R-021)

T-041 of `plans/R-021-command-toolset/`, per `manifest.md`. Copy the 7 DEV
sub-skills into `skills/dev/` as inert companion mode files (short names;
SKILL frontmatter stripped), carrying their companions to
`skills/dev/companions/`. Originals stay in `skills/` until cut-over/removal
(T-044/T-045); **dormant** — the router doesn't read them yet, so `/dev` is
unchanged.

## Notes

- **Ref rewiring** in each companion:
  - refs to the moved rules → the T-040 companion names (`plan`,
    `branch-plan`, `templates`, `layout`, `changelog`, `git-workflow`);
  - refs to the other relocated sub-skills → the new short names (`feat`,
    `fix`, `refactor`, `write-plan`, `finish`, `release`, `auto`);
  - refs to the **bundled** skills (`test-driven-development`,
    `systematic-debugging`, `verification-before-completion`,
    `receiving-code-review`, `dispatching-parallel-agents`) stay as skill
    references.
- **Gate:** companions sit under `skills/dev/` and aren't `SKILL.md`, so
  caps/stray don't flag them (mode-file caps arrive in T-043).

- [ ] `skills/dev/feat.md` from `adding-a-feature` — rewire refs.
- [ ] `skills/dev/fix.md` from `fixing-a-bug` — rewire refs.
- [ ] `skills/dev/refactor.md` from `doing-a-refactor` — rewire refs.
- [ ] `skills/dev/write-plan.md` from `writing-plans` (+ `plan-document-reviewer-prompt` → `skills/dev/companions/`).
- [ ] `skills/dev/finish.md` from `finishing-a-branch` — rewire refs.
- [ ] `skills/dev/release.md` from `release` — rewire refs.
- [ ] `skills/dev/auto.md` from `delegating-to-agents` (+ companions: implementer-prompt, spec-reviewer-prompt, verification-policy, report-template, toolchain, auto-permissions.template.json → `skills/dev/companions/`).
- [ ] Complete the branch: re-review cross-refs, mark plan complete, commit.
