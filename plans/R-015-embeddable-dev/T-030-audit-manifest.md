task: T-030
type: refactor
architecture-changing: true

# refactor/audit-manifest — portable-core audit & manifest (R-015)

T-030 of `plans/R-015-embeddable-dev/requirements.md` (AC9). Foundational
task: classify the toolchain, make the source embed-ready, produce the
portable-core manifest, and record the embedding architecture in
`DESIGN.md`. Blocks T-031–T-034 (their branch plans are detailed once the
manifest exists).

**Sequencing principle.** Audit first (classification → manifest), then
the embed-readiness refactor it justifies, then the `DESIGN.md`
architecture record — so the manifest exists before any change relies on
it and `run-all` is green at every commit.

**Manifest location.** `plans/R-015-embeddable-dev/manifest.md` — an
initiative reference artifact, linked from `DESIGN.md`.

**Scope discipline.** Embed-readiness here means only normalizing
cross-references and lifting project-specifics into rules so skills stay
generic — not renaming or vendoring (that is T-031's transform, applied to
the copy). The global install is unchanged.

- [x] Audit and classify every **rule** (`rules/*.md`) as
  portable-generic / project-specific / global-only; record in
  `manifest.md` with the portable set and the exclusion reasons
  (ledger/maintenance/self-hosting → global-only).
- [x] Audit and classify every **skill** (`skills/*/`, incl. companion
  files) the same way; record in `manifest.md`. Flag any skill whose
  procedure carries project-specifics (candidate for lifting in a later
  commit).
- [x] Embed-readiness: normalize skill/rule cross-references so every
  `~/.claude/...` reference is uniform and mechanically rewritable (no
  relative or stale variants the transform would miss). (`rules/`,
  `skills/` as the audit surfaces)
- [x] Embed-readiness: lift project-specific fragments out of portable
  rules — `git-workflow.md:39` self-hosting clause → `CLAUDE.md § Agent
  toolchain`; trimmed `branch-plan.md:202` friction-log clause. (The
  `verification-policy.md` Models table is genericized at transform time
  per the manifest, not edited globally.)
- [ ] Record the embedding architecture in `DESIGN.md`: vendor transform,
  `dev-*` namespacing + embed-aware `dev` + marker, version stamp + drift,
  CI subset (no ledger), generic `CLAUDE.md` backbone — and link
  `manifest.md`. Confirm ≤1000-word inline cap (move detail to the
  manifest if needed).
- [ ] Complete the branch: re-review docs across all commits, confirm
  `manifest.md` covers every skill/rule with no gaps, cleanup, confirm
  `bash scripts/ci/run-all.sh` green, triage the findings file, mark the
  plan complete, commit.
