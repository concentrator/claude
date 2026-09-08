# `CLAUDE.md` declarations

The keys a project declares in its `CLAUDE.md` - routine commands in
`§ Agent toolchain`, supervision in the `§ Supervision` that follows
it - and the exact form each takes. All apply everywhere - both modes,
every command. Push and MR/PR mechanics that consume them:
`toolchain.md`.

## Declared commands

A project's `CLAUDE.md` declares its routine commands in an `## Agent
toolchain` section - the VCS host (→ `gh`/`glab`) and the exact
change-request / merge / state-check / test / lint / build commands. It
is the single source the run reads:

- `/dev run` uses it for `permissions.allow` (the pre-flight gate in
  `toolchain.md § Permission carve-out for the checkpoint push`).
- `finish` runs the declared commands instead of probing the host.

The test declaration is tiered, and both tiers include lint.
`Test (fast)` - lint plus a scoped subset of the suite (the tests
covering the area a commit touches) - runs per commit; `Test (full)` -
lint plus the whole suite - runs once at branch close
(`finish.md § 1`), and CI on the MR/PR is the authority. A single
`Test:` declaration serves as both tiers; a project with no scoped
subset declares fast as lint only.

Declare it once; `migrate` backfills it if absent (absent-host fallback:
`finish § 3`).

## Supervisor bounds

A project delegating delivery to a supervisor declares who holds the
seat and its bounds in a `## Supervision` section directly after
`## Agent toolchain` - the single home for merge authority:

```
- Supervisor: AI
- Supervisor bounds: batch-scoped delivery; instructions: .claude/supervisor.md
```

`Supervisor: human` - the user's own interactive session holds the
seat: it dispatches the seats, and the user answers their questions,
clears what stops them and merges. `Supervisor: AI` - a supervising
session dispatches, answers and merges within the bounds below, and
the user gets the always-ask list only. That list reaches the user
under either. A block without the `Supervisor:` line, or no block at
all, halts the run at resolve, naming the missing line; the bounds
line alone grants nothing. The default grant, **batch-scoped
delivery**, carries
work as far as a green MR/PR and holds one decision class:

- deliver a `plan/` branch to a green MR/PR;
- deliver a batch or member branch whose checkpoint report verifies the
  task's acceptance criteria - the approved plan is the decision, the
  supervisor automates its delivery;
- deliver a task-scoped run's branch, where `finish.md § 1`'s verify
  set stands in for the checkpoint report, and its absence stops the
  delivery as a missing report does;
- implementation-level resolutions of worker questions and queued
  judgment calls, each recorded in the report's supervisor-decisions
  section and ledgered (`run.md § Ledger`).

**The grant includes the merge.** Within the declared bound the
supervisor's last act on a green in-class MR/PR is the merge, carrying
the supervision signature below; everything outside the bound - and
everything on the always-ask list - goes to the user. The
worker/supervisor seam stays: the doer never verifies its own
delivery.

The decision split: implementation-level is code shape, naming, test
details, finding triage within the plan's stated behavior;
design-level is component boundaries, schemas, API shapes,
`DESIGN.md`-level structure, plan content. A call the split cannot
classify escalates.

Always asked of the user, under any grant: releases; changes to
`CLAUDE.md`, `rules/`, or `skills/` - except a `CLAUDE.md` change
confined to the declaration lines this file defines (`§ Agent
toolchain`, `§ Supervision`); customer data or disclosure; off-plan
work; history rewrites; red gates; design and architectural
decisions.
Host gates (protected trunk, required checks) stay the hard floor for
every seat - no admin merges.

Operating instructions beyond authority - project quirks, escalation
additions, never-touch areas - live in the optional
`.claude/supervisor.md` the declaration references; authority never
moves there.

**Supervision signature.** Supervision is recorded as metadata in two
places and never as prose. Every merge of supervised work carries a
`supervised` label plus a merge comment naming the bound applied and the
seat that applied it. And
where a host exists to run supervised delivery, every commit made on it
carries the mode in its committer field: the author is the human whose
work it is, and `committer.name` says how it was applied. git honours
`committer.*` independently of `user.*`, so `git log --author`,
shortlog and blame keep answering about the human.

The label answers at the MR/PR, the committer at any commit reached
later from blame. No commit message, title or body mentions
supervision: `git-workflow.md § MR/PR messages` governs prose and is
unchanged by supervision.
