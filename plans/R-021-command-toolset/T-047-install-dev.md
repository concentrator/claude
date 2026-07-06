task: T-047
type: feat

# feat/install-dev - toolset installer (R-021)

T-047 of `plans/R-021-command-toolset/`. **Phase E.** `scripts/install-dev.sh`
installs the DEV toolset into a target `.claude` - a contributor's global
`~/.claude`, or a project's `.claude/` (for no-global contributors). This
is the distribution mechanism, and it unblocks the wallarm unwind.

## Design

- **Usage:** `install-dev.sh` → global (`~/.claude`); `install-dev.sh
  --project <path>` → `<path>/.claude`.
- **Copies:** `skills/dev/` (router + companions), the 5 bundled dependency
  skills (`test-driven-development`, `systematic-debugging`,
  `verification-before-completion`, `receiving-code-review`,
  `dispatching-parallel-agents`), and `hooks/dev-branch-guard.sh`.
- **Does NOT ship** the personal convention rules (`git-workflow`, `js`,
  `skills`, `claude-md`) - those are the user's, not the toolset.
- **Hook registration:** add the `PreToolUse` branch-guard to the target
  `settings.json` via `jq`, **idempotently** (merge - don't clobber
  existing settings/hooks; skip if already present). Hook path relative to
  the target (global → `~/.claude/hooks/…`; project → `.claude/hooks/…`,
  project-scoped enforcement).
- **Idempotent:** re-runnable - refreshes the toolset files, preserves
  adopter content; no duplicate hook entries.

- [x] Test first (TDD): `scripts/test/install-dev.test.sh` - install into a
  temp target; assert `skills/dev/` + the 5 bundled skills + the hook
  copied, and `settings.json` has the branch-guard `PreToolUse`
  registration; re-run → no duplication (idempotent); a pre-existing
  unrelated setting/hook survives. (red → implement → green)
- [x] Implement `scripts/install-dev.sh` per the design.
- [x] README: add an "Installing the toolset" section (global + project).
- [x] `DESIGN.md` tree-map: add `scripts/install-dev.sh` + `scripts/test/`.
- [x] Complete the branch: full gate green; close review (`/code-review`);
  mark plan complete.
