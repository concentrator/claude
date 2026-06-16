task: T-016
type: refactor
architecture-changing: true

# refactor/tbd-foundation — establish the trunk-based model in rules (R-006)

T-016 of `plans/R-006-config-hardening/requirements.md` — the keystone.
Defines the Trunk-Based Development model in the rule files the rest of
R-006 builds on: a consolidated `git-workflow.md`, the trunk/PR planning
model, and batch-as-universal-delivery-unit. Manual mode (refactor); no
agentic stamp.

Grounded in a research pass (2026-06-14; sources cited in
`git-workflow.md` References): canonical TBD
(trunkbaseddevelopment.com, dora.dev), tag-on-trunk releases (Pro Git),
host branch-protection / auto-merge mechanics (GitHub Docs), coherence
via feature flags / branch-by-abstraction (Fowler). The pass found zero
deviation from the standard.

Constraints carried from R-006:

- These rules describe the **target** model. Hard enforcement (branch
  protection + CI + pre-push hook) lands in T-019; R-006 itself executes
  under current direct-commit mechanics (bootstrap). Keep transition
  cruft out of the permanent rules — the bootstrap is R-006-operational
  only.
- CLAUDE.md compaction to ≤400 is T-017; here only the **git** prose is
  extracted + a pointer added.
- Global rules state the model generically; **host-specific** mechanics
  (GitHub branch-protection settings, auto-merge config) belong to
  T-019's infra, not these rules (adopters may be GitLab).

- [x] Create `rules/git-workflow.md` — consolidate ALL git rules into
      one file: branching (short-lived, single-owner, merge within a day
      / two days absolute max, `<prefix>/<slug>`); the single "every
      change reaches `main` via a CI-gated PR; never push to `main`"
      rule; commit + MR/PR message style (moved verbatim from CLAUDE.md);
      release = tag-on-trunk (annotated semver `git tag -a vX.Y.Z`,
      pushed explicitly; no release branch); coherence techniques
      (feature flag / branch-by-abstraction / small PRs); named
      anti-patterns (no code freezes, no unmerge, no fix-on-release-
      then-down-merge, no big-bang merges; integrate at least daily).
      References block with the research sources.
- [x] Rewrite `planning.md § Where plans live in git` — replace "plans
      commit directly to `main`" with the trunk/PR model (planning
      artifacts reach `main` via short-lived doc PRs; `requirements.md`
      vs `ROADMAP`/`TASKS` stay separate commits); point to
      `git-workflow.md` for the push rule.
- [x] Rewrite `branch-plan.md § Agentic execution` — batch = the
      universal delivery unit (1+ tasks → one CI-gated PR; lone task =
      degenerate batch, its branch is the PR); mode orthogonal (delivery
      uniform, verification differs); TBD batch lifecycle + closing flow
      (members → `batch/B-XXX` → PR to origin; bookkeeping on the batch
      branch; reject deletes the branch; `pre-B-XXX` deleted on accept);
      manual task = its own PR to origin.
- [ ] Extract git prose from `CLAUDE.md` → a single `git-workflow.md`
      pointer (removes the Session-Workflow branching lines, Commit
      Messages, MR/PR Messages, the main-push rule); record the git-rule
      relocation mapping (the R-006 preservation invariant).
- [ ] Update `DESIGN.md` — branching + delivery architecture for the TBD
      model (trunk, PR-only, batch-as-delivery-unit, tag-on-trunk).
- [ ] Complete the branch: re-review docs across all commits, verify the
      git-rule relocation mapping is complete (every moved rule →
      kept/relocated, none dropped silently), cleanup, mark plan
      complete, commit.
