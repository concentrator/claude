# `CLAUDE.md § Agent toolchain` declarations

The keys a project declares in its `CLAUDE.md § Agent toolchain` section,
and the exact form each takes. All three apply everywhere - both modes,
every command. Push and MR/PR mechanics that consume them:
`toolchain.md`.

## Declared commands

A project's `CLAUDE.md` declares its routine commands in an `## Agent
toolchain` section - the VCS host (→ `gh`/`glab`) and the exact
change-request / merge / state-check / test / lint / build commands. It
is the single source both modes read:

- `/dev auto` uses it for `permissions.allow` (the pre-flight gate in
  `toolchain.md § Permission carve-out for the checkpoint push`).
- Manual `finish` runs the declared commands instead of probing the host.

Declare it once; `migrate` backfills it if absent (absent-host fallback:
`finish § 3`).

## Artifacts root

The same section declares where DEV artifacts live, as a
repo-relative directory on its own line, in exactly this form (a
near-miss line - indented, or missing the dash - is ignored and the
default applies):

```
- DEV artifacts root: <dir>/
```

Resolution, including the absent-declaration default, lives in
`plan.md § Where things live`; `layout.md` draws the config and
artifacts trees.

## Supervisor bounds

A project delegating delivery to a supervisor (R-040) declares its
bounds in the same `## Agent toolchain` section - the single home for
merge authority:

```
- Supervisor bounds: batch-scoped delivery; instructions: .claude/supervisor.md
```

No declaration = a read-only supervisor: it reports and escalates,
answers nothing, merges nothing. The default grant, **batch-scoped
delivery**, allows two merge classes and one decision class:

- green `plan/` MR/PRs;
- green batch/member MR/PRs whose checkpoint report verifies the
  task's acceptance criteria - the approved plan is the decision, the
  supervisor automates its delivery;
- implementation-level resolutions of worker questions and queued
  judgment calls, each ledgered in the report's supervisor-decisions
  section.

The decision split: implementation-level is code shape, naming, test
details, finding triage within the plan's stated behavior;
design-level is component boundaries, schemas, API shapes,
`DESIGN.md`-level structure, plan content. A call the split cannot
classify escalates.

Always escalated, under any grant: releases; changes to `CLAUDE.md`,
`rules/`, or `skills/`; red gates; off-plan work; design and
architectural decisions. Host gates
(protected trunk, required checks) stay the hard floor - no admin
merges.

Operating instructions beyond authority - project quirks, escalation
additions, never-touch areas - live in the optional
`.claude/supervisor.md` the declaration references; authority never
moves there.

**Merge signature.** Every supervisor merge carries a `supervised`
label plus a merge comment naming the bound applied - host metadata
only, never commit or MR/PR prose (`git-workflow.md § MR/PR messages`
governs prose and is unchanged by supervision).
