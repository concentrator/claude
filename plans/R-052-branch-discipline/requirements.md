---
approved: 2026-08-18
kind: bug
---

# R-052: Branch discipline and commit target resolution

## Observed behavior

The branch guard denies a tool call in nearly every session, from two
unrelated causes.

**Writes on the trunk.** The DEV planning flow reaches its first artifact
write before it creates a branch. The denied targets are planning
artifacts - initiative requirements, branch plans, batch manifests, the
supervisor portfolio - in this repo and in adopter projects. Nothing
tells a session its branch unprompted, so the obligation is recalled
only after the guard refuses.

**Commits into throwaway fixtures.** A test or probe that builds a
disposable repo under the session scratchpad and commits inside it is
refused as a commit on the trunk. `hooks/dev-branch-guard.sh` resolves a
commit's repo from `git -C` when present and the session cwd otherwise,
so a `cd` into the fixture is invisible and the commit is attributed to
the session repo. That same fixture's `Write` calls are allowed, because
R-036 moved the write path onto the target's owning repo and left the
commit path on the cwd fallback.

Shaping-time evidence: a scan of the local session transcripts found 58
denials across 22 sessions, split roughly half to each cause, the
remainder commits into sibling repos reached by `cd`.

## Expected behavior

- A session knows its current branch and working-tree state without
  asking, in DEV and VIBE alike.
- The guard refuses a commit only where that commit can land on a trunk
  that matters. A commit into a repo built for a test, under an
  ephemeral path, is not project work and is allowed - matching what the
  write path already does.
- Denials stay informative, because they fire only on real trunk
  mutations.

## Reproduction steps

Defect A: from `main` in a DEV project, run `/dev plan R` and let the
flow reach its first artifact write.

Defect B:

    D=$(mktemp -d) && cd "$D" && git init -q . \
      && git commit -q --allow-empty -m probe

Denied, naming the session repo's branch, though the commit targets the
fresh repo in `$D`. `git init` puts that repo's own HEAD on `main`, so
resolving the effective cwd would not clear the denial either - the
fixture is on a trunk by construction.

## Impact

Each affected call costs a turn and a retry. The larger cost is
desensitisation: a guard that refuses legitimate work teaches the
session to read its refusals as noise, weakening the one hard stop
protecting the trunk. Defect B also ships - `install-dev.sh` installs
this hook, so adopters inherit the fixture denials.

## Acceptance criteria

- [ ] A commit into a repo that is not project work is allowed, proved
      by cases in `scripts/test/dev-branch-guard.test.sh` that fail
      against the pre-fix hook.
- [ ] A commit that would land on a real project's trunk is still denied
      from any cwd, proved by the existing trunk cases continuing to
      pass.
- [ ] Current branch and working-tree state reach the session unprompted
      in both modes, proved by a run that fails when the mechanism is
      removed.
- [ ] The hook's header states the commit path's actual resolution rule
      (`MAINTENANCE.md § Doc-sync pairs`).
- [ ] `bash scripts/ci/run-all.sh` green.

## Constraints

- The guard stays a best-effort local tripwire, not a security boundary;
  host protection plus CI is the real gate
  (`skills/dev/git-workflow.md § Enforcement`), so an unresolvable
  target fails open rather than denying.
- The non-project signal must be readable from the tool call alone,
  without executing the command.
- No new rule for VIBE to remember; its only hard stop stays the guard.
- Hook changes ship via `install-dev.sh`, so the test ships with them.
- Must stay compatible with the Claude Code hook schema.

## Open questions

- Which signal marks a repo as non-project work: an ephemeral path
  prefix, a repo created within the same command, or both. R052-T001
  settles it against the command shapes that actually occur.
- Whether the branch-state injection belongs on `UserPromptSubmit` or
  `SessionStart` plus a refresh, given that per-turn context bears on
  R-050's budget.

## References

- R-034, R-036, R-037 - the prior guard-scope fixes; R-036 owns the
  write-path rule this extends to commits.
- R-050 - context budget; the injection adds per-turn context and must
  be sized against it.
- R-051 - the sibling defect: tooling resolving the wrong repository
  from leaked environment (`GIT_DIR` there, session cwd here).
- Standard: the shell git prompt (`__git_ps1`, git's
  `contrib/completion/git-prompt.sh`) - the time-proven answer to "which
  branch am I on" is ambient display, not a remembered check.
