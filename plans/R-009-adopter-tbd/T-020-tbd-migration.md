task: T-020
type: feat

# feat/tbd-migration — already-DEV TBD-migration mode for migrating-to-dev (R-009)

T-020 of `plans/R-009-adopter-tbd/requirements.md`. Adds an "already-DEV,
pre-TBD" migration mode to `migrating-to-dev`: detect (`.claude/plans/ROADMAP.md`
present) and route; the migration path produces a TBD-migration report over
delivery / structure / close-release, with detail in a companion file
(SKILL.md is near its 300w cap). Advisory throughout — the skill plans and
reports; the user executes all irreversible/host steps; no `main` history
rewrite. Fresh-mode behavior is unchanged.

Settled decisions: already-DEV signal = `.claude/plans/ROADMAP.md` present;
non-canonical files → propose `references/` + allow a recorded exception.
Not architecture-changing — the `DESIGN.md` tree-map entry for the new
companion is routine bookkeeping, folded into the final commit (per the
`/dev plan all` review).

- [x] Add mode detection + routing to `migrating-to-dev/SKILL.md`: detect
      already-DEV (`.claude/plans/ROADMAP.md` present) → TBD-migration mode,
      else fresh (existing sections unchanged); an already-conformant project
      yields a no-op confirmation. Re-check `wc -w` ≤ 300. Touches: SKILL.md.
- [x] Create `skills/migrating-to-dev/tbd-migration.md` + the **Delivery**
      area: scan recent `main` for local-merge (`Merge branch … into
      '<default>'`) and direct-to-`main` non-scaffold commits; report the
      pattern; state the go-forward CI-gated-PR rule + host gate by reference
      to `git-workflow.md § Trunk`/`§ Enforcement`; no history rewrite.
- [x] Add the **Structure** area to the companion: diff tracked `.claude/`
      vs `project-layout.md`; non-canonical files (e.g. `source-spec.md`) →
      propose move to `references/` or a recorded exception; flag missing
      expected files (`MAINTENANCE.md`) and strays; propose moves (advisory).
- [x] Add the **Close/release** area to the companion: closes ride PRs;
      convert the release flow to tag-on-trunk (ref `git-workflow.md
      § Releases — tag-on-trunk`); flag fork-release leftovers; archive
      superseded release plans (`planning.md § Archival`).
- [x] Wire `SKILL.md` → companion: in the migration-mode branch add the brief
      pointer to `tbd-migration.md`; confirm advisory framing (skill plans/
      reports; user executes irreversible/host steps; no `main` rewrite).
      Re-check `wc -w` ≤ 300. Touches: SKILL.md.
- [ ] Complete the branch: re-review docs across all commits; add the
      `tbd-migration.md` line to the `DESIGN.md` tree-map (under
      `migrating-to-dev/`); `bash scripts/ci/run-all.sh` green; triage
      `T-020-tbd-migration.findings.md`; mark plan complete; commit.
