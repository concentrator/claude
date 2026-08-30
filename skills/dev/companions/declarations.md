# `CLAUDE.md § Agent toolchain` declarations

The keys a project declares in its `CLAUDE.md § Agent toolchain` section,
and the exact form each takes. All four apply everywhere - both modes,
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

## Supervisor bounds

A project delegating delivery to a supervisor declares its
bounds in the same `## Agent toolchain` section - the single home for
merge authority:

```
- Supervisor bounds: batch-scoped delivery; instructions: .claude/supervisor.md
```

No declaration = a read-only supervisor: it reports and escalates and
answers nothing. The default grant, **batch-scoped delivery**, carries
work as far as a green MR/PR and holds one decision class:

- deliver a `plan/` branch to a green MR/PR;
- deliver a batch or member branch whose checkpoint report verifies the
  task's acceptance criteria - the approved plan is the decision, the
  supervisor automates its delivery;
- deliver a task branch from manual `/dev code` work, where
  `finish.md § 1`'s verify set stands in for the checkpoint report,
  and its absence stops the delivery as a missing report does;
- implementation-level resolutions of worker questions and queued
  judgment calls, each recorded in the report's supervisor-decisions
  section and ledgered (`supervise.md § Ledger`).

**No grant merges.** The supervisor's last act on a branch is the green
MR/PR and the evidence that verifies it; the operator reads that MR/PR
and decides (§ Operator modes): the seat that assembled the evidence
stays apart from the seat that accepts it.

The decision split: implementation-level is code shape, naming, test
details, finding triage within the plan's stated behavior;
design-level is component boundaries, schemas, API shapes,
`DESIGN.md`-level structure, plan content. A call the split cannot
classify escalates.

Always escalated, under any grant: releases; changes to `CLAUDE.md`,
`rules/`, or `skills/` - except a `CLAUDE.md` change confined to the
declaration lines this file defines, other than `Operator mode:`,
which is configuration the operator delivers, not a convention
change; red gates; off-plan work; design and architectural decisions.
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

## Operator modes

A supervised project declares who holds the merge the supervisor does
not, in the same `## Agent toolchain` section:

```
- Operator mode: AI operated | Human operated
```

**Human operated** - a person answers escalations and decides merges at
the keyboard. This is the default when the key is absent.

**AI operated** - a Claude session holds the merge decision. It reads
the MR/PR and decides on that evidence alone: approvals, resolved
discussions, gate results, and a report that verifies what the plan
asked for. It never implements, never edits plans, and never reopens a
question the supervisor already classified as design-level.

The declared bounds are how an AI-operated seat satisfies the global
`CLAUDE.md § Approval and persistence` and `§ Communication`: within
them it decides merges and rules on plan-fact corrections (a wrong
path or name the supervisor reports; the edit rides a `plan/` MR/PR
the supervisor delivers), and it runs `--permission-mode auto`
(`supervisor-runbook.md § Modes, and why each role gets one`). It
escalates to the human:

- anything the supervisor escalated as design-level or unclassifiable -
  the supervisor's classification stands and is not re-decided;
- anything § Supervisor bounds always escalates, the operator's own
  configuration included;
- a merge whose evidence is incomplete or contested - approvals
  missing, discussions unresolved, gates not green, or a report that
  does not verify the plan's acceptance criteria.

The fail-safe is a reading count: if classifying a decision takes more
than one reading of the evidence, it escalates. A second reading means
the categories do not cleanly hold, which is the condition escalation
exists for.

The deciding seat is visible in the artifact that already records the
decision - a supervisor resolution in the report's supervisor-decisions
section, an operator merge in the MR/PR merge comment, an escalation
answer in the thread that raised it. No seat gets a store of decisions
of its own; the supervisor's ledger is working memory
(`supervise.md § Ledger`).

One operator serves many projects, each with its own supervisor and its
own single worker. Nothing crosses project lines but the operator.
