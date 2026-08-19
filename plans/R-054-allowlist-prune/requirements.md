---
approved: 2026-08-19
kind: mnt
status: done 2026-08-19
---

# R-054: Prune the local permission allowlist

## Current state

`.claude/settings.local.json` carries just over two hundred allow
entries accumulated from per-session approvals (count at shaping,
2026-08-19). Most are one-shot literals: `perl -i` and `sed -i` edits
of specific plan files, `/tmp` scripts from finished sessions, paths
into dead session scratchpads. Several are arbitrary-execution
wildcards - `Bash(bash -c *)`, `Bash(cd *)`, `Bash(bash)`,
`Bash(claude *)`, and `docker run` wildcards - which allow any command
unprompted and reduce every narrower entry to decoration. The file
also carries its two deliberate residents: the batch-push deny
carve-out and the model override.

## Desired state

The allowlist holds durable classes only: recurring tool-class
entries (git and `gh` subcommands, read-only text tools, the gate and
test runners, `Edit`/`Read` path scopes). One-shot literals and
arbitrary-execution wildcards are gone; commands outside the durable
classes prompt again. The list will re-accumulate by design - the fix
is this prune and the retention rule it leaves behind, not machinery
to prevent regrowth.

## Invariants

- The deny block (default-branch and force pushes) is byte-identical
  before and after.
- The model override stays.
- No new check, hook, or script ships (R-053 proportionality: clutter
  is not a fired guard failure).
- The guard hooks are untouched; prompting is the only behavior that
  changes.

## Scope

`.claude/settings.local.json` only. The file is gitignored, so the
prune itself lands in no commit; the tracked deliverables are this
initiative's plan artifacts.

## Acceptance criteria

- [x] Every remaining allow entry names a recurring tool class or a
      path scope; none embeds a session-specific path (scratchpad,
      `/tmp` script) or a literal one-file edit command.
      Evidence: grep for scratchpad, `/tmp` scripts and in-place
      edit literals matches nothing (2026-08-19).
- [x] No allow entry grants arbitrary command execution (`bash`,
      `bash -c`, `cd`, `claude`, container-run wildcards, or an
      equivalent).
      Evidence: grep for `bash -c`, bare `bash`, `cd`, `claude`,
      `docker`, `node -e` matches nothing; `bash` survives only
      scoped to `scripts/ci/`, `scripts/test/`, `.githooks/pre-push`
      (2026-08-19).
- [x] The deny block and the model override are unchanged.
      Evidence: `jq` extraction of `.permissions.deny` and `.model`
      diffs empty against the pre-prune copy (2026-08-19).
- [x] The file is valid JSON and a session loads it without error.
      Evidence: `jq -e .` exits 0 on the applied file; the running
      session wrote it via allowed tools without a settings error
      (2026-08-19).

## Constraints

- Manual curation; no transcript-scanning tooling runs and none
  ships. Regrowth, when it warrants another prune, is a new
  maintenance pass of the same shape.
