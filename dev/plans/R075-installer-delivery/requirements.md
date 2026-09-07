---
approved: pending
kind: feat
---

# R075: Installer delivery mode

## Motivation

A plain `install-dev.sh --project <repo>` writes the toolset into the
target's working tree: on a repo mid-task it leaves modified settings
and gitignore plus six untracked `.claude/` paths on whatever branch
happens to be checked out (observed in aikido, 2026-09-07, resolved by
hand via a worktree and MR !215). The install is a config change that
should reach the target's trunk as a reviewable commit, not as
uncommitted state another session has to triage.

## Goals (to shape)

- `install-dev.sh --deliver <repo>`: install into a temporary worktree
  off the target's default branch, commit on `mnt/dev-toolset`, remove
  the worktree; push and MR/PR stay with the operator (printed as next
  steps).
- Plain `--project` into a git repo with uncommitted changes warns that
  it is writing into a dirty tree and names `--deliver`.
- Non-git targets and the global (no `--project`) path are unchanged.

## Open questions

Deferred to the shape round (`/dev plan R`).
