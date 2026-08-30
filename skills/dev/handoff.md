# Hand-off note

The session file carries the two halves of the state a compaction
loses: the tree's, which `hooks/dev-precompact-state.sh` appends as a
`tree` block just before compaction, and the session's intent, which
only the session can write - this note. `/dev handoff` writes one on
demand; the boundary rules in `branch-plan.md § Session boundary` and
`supervise.md § Monitor` write one without being asked.

## The file

`dev/session/<session_id>.md`, gitignored. Its path is
the `session-state:` field the `branch-state:` prompt line ends with -
read it from there, never derive it. One file per `claude` process:
under the supervisor runbook the supervisor, worker and operator each
have their own; under `/dev auto` or a worker spawned as a subagent,
hooks fire with the parent's `session_id`, so the run has one file and
only the orchestrating session writes hand-offs to it (a member's
state is its checkpoint report).

**Header** - the first writer creates the file with
`# <role> session <session_id>`; the hook, which knows no role, writes
`# session <session_id>`, and the next hand-off rewrites that line with
the role. Roles: `worker` (dispatched by a supervisor), `supervisor`
(`/dev supervise`; re-briefed from this note and its ledger,
`dev/supervisor/<scope>.md`), `operator` (the AI operator seat),
`solo` (no other seat).

**Blocks** - `## <kind> <UTC timestamp>` followed by `- key: value`
lines, appended in time order; the last block of each kind is current.
Kinds: `tree` (the hook's) and `hand-off` (this note).

## Writing the note

Append one `hand-off` block with these five keys, each one line;
`none` when empty:

    ## hand-off 2026-08-29T10:15:00Z
    - done: R063-T003 merged (#416); R040-T021 planned (#417)
    - next: /dev code R040-T019, item 3 (handoff.md)
    - branch: feat/precompact-state, 2 commits ahead of main
    - open: none
    - rulings: plan/ merges on green without a second ask; keep the 405 note

`done` and `next` name work by durable ids (`rules/writing-artifacts.md § Name
things
by their durable id`); `open` lists MR/PR numbers awaiting a decision;
`rulings` lists the user's decisions still in force for the unit. The
note is intent, so the tree never overrides it and it never restates
the tree: branch state comes from the `tree` block and `git status`.

Write it at each unit boundary - an initiative closed, a dispatch sent,
a ruling received, a task branch opened - and before any step the
session expects to outlive its context. Under a tenth of context left,
a worker commits locally first, so the tree block records commits, not
an uncommitted checkbox.

## Reading it back

After compaction the next prompt line names the file. Re-brief from
the file and the tree - the last `hand-off` block for intent, the last
`tree` block and a fresh `git status` for state - never from the
summary alone. Then delete the file: a re-brief that leaves it behind
is read again by the next compaction as current. `MAINTENANCE.md
§ Routine` sweeps files whose session is gone.
