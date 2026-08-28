task: R064-T002
type: refactor
depends-on: R064-T001

# The configurable artifacts root leaves the DEV system

With every project, this repository included, on `dev/`, the
machinery that carried one non-default value is removed: the
resolver, the declaration, the permission placeholder, and the
`<root>/` notation. Paths are written `dev/plans/`, `dev/docs/`,
`dev/session/` in every file. A declaration left behind in an
adopter's `CLAUDE.md` fails the Tier-1 gate with one line naming the
move, so the change is learned from the gate, never from a silently
ignored setting.

## Terms used below

- **Fixed path** - a literal `dev/...` path, repository-relative,
  wherever a file resolved, substituted, or abbreviated one before:
  `ROOT=dev` in the checks, `dev/plans/**` in the permission template,
  `dev/plans/visual-artifacts/` in the server scripts, `dev/session`
  in the PreCompact hook.
- **Declaration failure** - `scripts/ci/check-plan-integrity.sh`
  fails when `CLAUDE.md` carries a line starting `- DEV artifacts
  root:`, printing one line: the home is fixed at `dev/`, move the
  named directory there and drop the line. The gate is Tier-1, so an
  adopter sees it on the first push after re-installing the checks.
- **Removed** - `scripts/ci/resolve-root.sh` and its copy in
  `install-dev.sh`'s check set; `companions/declarations.md
  § Artifacts root`; `__ARTIFACTS_ROOT__` and `WORKER_ARTIFACTS_ROOT`
  in `scripts/worker-workspace.sh`; the resolver-copy seam and the
  declared-root cases in the check tests; the root paragraph of
  `plan.md § Where things live`, whose table then lists fixed paths.
- **Sweep evidence** - at close, `git grep -l` over tracked files
  outside `dev/plans/archive/` for `resolve-root`,
  `__ARTIFACTS_ROOT__`, `DEV artifacts root` and `<root>` returns
  nothing (the R's acceptance criterion); the R's other criteria are
  verified in the closure commit below.

## Commits

- [ ] Checks: the resolver callers under `scripts/ci/`
  (`check-plan-integrity.sh`, `check-accretion.sh`) use the fixed
  path, and `check-batch-tags.sh` scopes the trunk's listing to
  `dev/plans/` instead of any `plans/` segment (R064-T001 widened it
  for the move); `check-plan-integrity.sh` adds the declaration failure;
  `resolve-root.sh` deleted; `check-plan-integrity.test.sh`,
  `check-accretion.test.sh`, `check-batch-tags.test.sh` drop the
  resolver seam and declared-root cases and assert the declaration
  failure's one line; `install-dev.sh` stops copying the resolver and
  writes `/dev/session/` literally (`install-dev.test.sh` follows).
- [ ] Hooks and scripts: `hooks/dev-precompact-state.sh` writes under
  `dev/session` (`dev-precompact-state.test.sh` follows);
  `scripts/worker-workspace.sh` drops the placeholder substitution and
  `WORKER_ARTIFACTS_ROOT` (`worker-workspace.test.sh` follows);
  `companions/auto-permissions.template.json` rules carry
  `dev/plans/**`; `companions/scripts/start-server.sh` and
  `stop-server.sh` use the fixed path with no declaration lookup.
- [ ] Mode files: `plan.md § Where things live` reduced to the fixed
  table; `layout.md` trees; `start.md`, `migrate.md`, `handoff.md`,
  `write-plan.md`, `branch-plan.md`, `finish.md`, `release.md`,
  `templates.md`, `auto.md § Pre-flight` (placeholder sentence gone)
  spell `dev/plans/`, `dev/docs/`, `dev/session/`; `<root>/` gone.
- [ ] Companions and root docs: `declarations.md § Artifacts root`
  removed; `root-migration.md` moves a `.claude/`-layout project onto
  `dev/` with no resolution step; `toolchain.md`,
  `untracked-claude.md`, `visual-companion.md`, `gitignore.template`
  (comment) spell fixed paths; `README.md`, `DESIGN.md`
  (§ Self-enforcement, tree-map: resolver gone), `REQUIREMENTS.md`
  where they describe the declaration.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: close review per `branch-plan.md § Closing
  routine` (code and prose rows: `code-reviewer`), Tier-2 compliance
  review, `bash scripts/ci/run-all.sh` green, cleanup; R064 closure
  check per `plan.md § Approval and closure` - each acceptance
  criterion verified with one-line evidence, `status: done` stamped in
  `requirements.md`, the R `[x]` in `ROADMAP.md`; mark plan complete,
  commit. Archival rides a `plan/r064-close` PR after the merge.
