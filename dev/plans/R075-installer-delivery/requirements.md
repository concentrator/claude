---
approved: yes
kind: feat
---

# R075: Installer delivery guard

## Motivation

`install-dev.sh --project <repo>` writes the toolset into whatever
tree is checked out: run against a repo mid-task it leaves modified
settings and gitignore plus six untracked `.claude/` paths mixed into
another branch's work (observed in aikido 2026-09-07, untangled by
hand and delivered as its MR !215). The install is a config change
that should reach the target's trunk as a reviewable commit; the
installer's job is to refuse targets where that cannot happen cleanly.
Shaping rejected a committing `--deliver` mode: the script never
commits, switches branches, or otherwise moves git state - that stays
with the operator.

## Goals

- **Dirty-tree refusal**: `--project` into a git repository with
  uncommitted changes to tracked files (unstaged or staged) exits
  nonzero before writing anything, telling the operator to commit or
  stash first.
- **Default-branch refusal**: `--project` with `HEAD` on the
  repository's default branch exits nonzero before writing anything,
  telling the operator to switch to a new branch (the install reaches
  trunk via an MR/PR, never directly).
- **Override**: `--force` bypasses both refusals for setups where they
  do not apply (non-git-flow repos, throwaway targets).
- **Unchanged elsewhere**: a clean tree on a non-default branch, a
  non-git target directory, and the global install (no `--project`)
  behave exactly as today.

## Non-goals

- No worktree, commit, push, or MR/PR automation - rejected in
  shaping; the operator branches and commits.
- No stash automation and no untracked-file blocking: pre-existing
  untracked files neither block the install nor are touched by it.

## User experience

- Guided flow: `git switch -c mnt/dev-toolset`, run the installer into
  the clean tree, review the diff, commit and open the MR/PR.
- Against a dirty or trunk-checked-out repo: one error message naming
  the failed condition, the remedy, and `--force`; nothing written.
- `--force` prints nothing extra and installs as today.

## Acceptance criteria

- [ ] `--project` into a repo with a modified tracked file exits
  nonzero, leaves the target byte-identical, and the message names
  commit/stash and `--force` (install self-test).
- [ ] `--project` with a clean tree checked out on the default branch
  exits nonzero, leaves the target unchanged, and the message says to
  switch to a new branch (install self-test).
- [ ] `--force` installs in both refused situations (install
  self-test).
- [ ] A clean tree on a non-default branch installs; the existing
  non-git and global fixtures in `install-dev.test.sh` pass unchanged.
- [ ] Tier-1 gate green (`bash scripts/ci/run-all.sh`, script tests
  included).

## Constraints

- Both checks run before the first write - a refused install leaves no
  partial state.
- Refusal messages go to stderr with a nonzero exit; the checks are
  independent (a dirty tree on the default branch reports the dirty
  tree first).
- Default-branch detection follows the remote head, falling back to
  the local convention when there is no remote - the exact mechanism
  is branch-plan detail.

## Open questions

None.

## References

- R067 (archived) - toolset portability; owns `install-dev.sh`'s
  project-tier form.
- aikido MR !215 - the by-hand delivery this guard replaces.
- `scripts/test/install-dev.test.sh` - the self-test the criteria
  cite.
