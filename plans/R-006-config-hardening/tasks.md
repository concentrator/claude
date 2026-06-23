# R-006 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` — format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-016 (R-006) [refactor]: TBD foundation — create
      `rules/git-workflow.md` (all git rules + the single "every change
      reaches `main` via CI-gated PR; never push to `main`" rule);
      rewrite `planning.md § Where plans live in git` (trunk model) and
      `branch-plan.md § Agentic execution` (batch = universal delivery
      unit, TBD lifecycle, closing flow, manual/auto delivery); repoint
      `CLAUDE.md` git refs; update `DESIGN.md` branching architecture.
      Keystone — the rest depend on it.
- [x] T-017 (R-006) [refactor]: CLAUDE.md compaction ≤400 (after T-016)
      — drop the extracted git prose, remove the `Temporary Files`
      duplication, rename `Structured Data / API parameters` + add the
      verify-before-stating rule, move the Agent-toolchain rule into
      `rules/claude-md.md`; record the rule-preservation mapping.
- [x] T-018 (R-006) [refactor]: dev/SKILL.md ≤300 + skills to TBD
      (after T-016) — DEV opener, drop `## Branching`, merge the
      `R`/`R-XXX` plan step, batch-aware manual mode; `finishing-a-branch`
      mode-aware PR-to-origin (no local `main` merge);
      `delegating-to-agents` checkpoint → PR to origin + TBD batch
      close; `writing-plans`, `starting-a-project`, `migrating-to-dev`;
      `release` → tag-on-trunk.
- [x] T-019 (R-006) [feat]: Enforcement layer (after T-016/017/018) —
      `maintenance.md` (Tier-2 AI review), `maintenance.json` (ledger),
      `.github/workflows/` (Tier-1 mechanical CI gate), pre-push hook;
      update `DESIGN.md` enforcement architecture.
