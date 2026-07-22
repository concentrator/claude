# Untracked .claude mode

A DEV project may keep all Claude-related files out of version control -
the whole `.claude/` tree plus the root `CLAUDE.md`, gitignored. This is a
valid configuration (e.g. a shared repo where DEV tooling stays personal).
Planning artifacts then live only in the working tree, so the plan-VCS
machinery is bypassed. Everything else in the workflow is unchanged.

## Detection

Active when `.claude/` is gitignored: `git check-ignore -q .claude`
exits 0. Check this at the start of `migrate` (§ 1 Inventory) and whenever
plan bookkeeping is about to open a `plan/` branch.

## Flag

Record `dev-artifacts: untracked` in `CLAUDE.md § Conventions`. The file
is local-only, but the agent reads it regardless of git status, so the
flag stays discoverable. Detection is the source of truth; the flag
documents the decision.

## What changes

The plan-artifact commit path collapses - gitignored files never enter
git, so a `plan/` branch and its MR/PR would carry nothing:

- **`plan/` branches - skipped.** Edit `REQUIREMENTS.md`, `DESIGN.md`,
  `ROADMAP.md`, `tasks.md`, task files, and branch plans directly in the
  working tree. No branch, no MR/PR for planning artifacts.
- **Bookkeeping marks - working tree, post-merge.** The final commit
  can't carry gitignored marks; once the branch merges (`finish § 4`),
  make the closing routine's marks (`branch-plan.md § Closing routine`)
  directly in the working tree.
- **`migrate.md § 8` / `start.md § 5` - written, not committed.**
  Adoption / scaffold artifacts land in the working tree only; the
  initial or adoption commit carries code and quality config, not the
  `.claude/` tree.
- **`.gitignore`** ignores all of `.claude/` and root `CLAUDE.md` (this
  inverts the `layout.md § Baseline` default, which ignores only `.env`
  and `.claude/settings.local.json`).
- **Contributor skill copy** (`start.md § 3`, `migrate.md § 5`) does not
  apply - nothing Claude-related is shipped in the repo.

The branch-guard already permits this: a `Write`/`Edit` to a gitignored
path is allowed even on the trunk (`hooks/dev-branch-guard.sh`), so plan
edits on `main` are not blocked.

## What stays the same

Code branches (`feat`/`fix`/`refactor`/`test`/`mnt`/`release`), their
CI-gated MR/PRs, the merge policy, the branch-guard for code, and the
delivery cadence all work exactly as in a tracked project.

## Tradeoff

Plans are purely local: no shared history, no team visibility, no review
of planning artifacts through the host. That is the accepted cost of
keeping DEV tooling out of the repo.
