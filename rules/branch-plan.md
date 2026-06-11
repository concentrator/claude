# Branch plan rules

A branch plan is `.claude/plans/R-XXX-<slug>/T-XXX-<slug>.md` (dir per
parent roadmap entry — `planning.md § Directory conventions`). One
branch = one task. The plan must be complete and committed to `main`
**before** the branch is created.

## Header

    task: T-014
    type: feat                      # required — inherited from task tag; determines branch prefix
    architecture-changing: true     # optional — triggers DESIGN.md update commit
    depends-on: T-012               # optional — blocks `/dev code` until merged
    agentic: approved 2026-06-10    # optional — eligible for auto mode; absent = manual-only

The `type:` value is inherited from the parent task's tag in `TASKS.md`
(e.g. `T-014 (R-001) [feat]:`). Branch prefix matches.

## Body

A checkbox list. Each `[ ]` = one commit. Each item names the change and
any documentation it touches.

## Per-commit rules

### Doc-before-commit

- Update related documentation **before** committing code that needs it.
- If the doc depends on a later commit, insert a placeholder + sub-task,
  and replace in the commit that completes the doc.

### No TODOs in code

Never write `TODO`, `FIXME`, or `XXX` comments in code. Every such item
routes to a plan artifact (branch-plan commit, `TASKS.md`, or `REQ-XXX`)
at discovery time. See "Scope discoveries" below.

## Mid-execution rules

### Scope discoveries

Anything you notice mid-execution that wasn't in the plan.

**Blocker** — proceeding would produce wrong, unsafe, or contradictory
code, the current task's premise is invalidated, a plan item can't be
interpreted unambiguously, or verification keeps failing after repeated
fixes:
- **Stop. Ask the user.** Resolution may require plan extension, new
  task, new REQ, or aborting the branch. Never inline-fix beyond a true
  typo in code you're currently writing.

**Non-blocker** — improvement, refactor idea, tangential test gap, code
smell, naming inconsistency:
- Append to the plan's sibling `T-XXX-<slug>.findings.md` as a
  checklist item (one line + brief context). Continue coding.
- Never silently expand scope.

Findings file format:

    - [ ] Logging in `auth/refresh.ts:42` missing trace ID (tangential)
    - [ ] `validateToken` lacks test for expired-but-recent case (test gap)

Triaged at branch close — see closing routine.

### Scope changes mid-branch

If additional changes are needed after the final commit:
- Update the plan (add new checkboxes).
- Add a new final commit at the end with the same closing structure.

## Closing routine

Triggered when the last non-final `[ ]` is marked `[x]`. Produces the
mandatory final commit, then hands off to merge/PR.

1. Auto-run `/simplify` (code review with fixes).
2. Validate `/simplify` findings against full project context.
3. Print report; request user approval before applying.
4. Apply approved fixes as additional commits if needed.
5. Request manual testing/verification; suggest automation where applicable.
6. **Triage `T-XXX-<slug>.findings.md`** — for each `[ ]` item, prompt user:
   - Promote to `T-XXX` (new entry in `TASKS.md`, committed to main now)
     — only under a fitting open `R-XXX`; none → use the REQ route
   - Promote to `REQ-XXX` (defer to next planning round)
   - Discard (mark `[x]` with reason: "won't fix")
7. **Mandatory final commit** — the last `[ ]`:

   > Complete the branch: re-review docs across all commits, cleanup
   > (stale/temp data), mark plan complete, commit.

   Includes the resolved findings file.
8. Invoke `finishing-a-branch` — present merge/PR/keep/discard
   options and execute.

## Architecture-changing branches

If header has `architecture-changing: true`, the plan must include a commit
that updates `DESIGN.md`. Routine branches do not modify `DESIGN.md`.

## Size cap

One task = one branch. Soft cap: warn at 15 planned commits, prompt to split
at 20. Override with stated reason in plan header.

## Agentic execution

Auto mode (`/dev auto`, engine: `delegating-to-agents`) runs whole
batches of branches via subagents, integrating them on a dedicated
batch branch `batch/B-XXX` — the default branch is never modified
during a run. Manual mode is the default; auto requires every gate
below.

### `agentic:` stamp

A plan becomes auto-eligible via a **readiness review** (run by
`/dev plan batch` for unstamped plans): each commit item must be
unambiguous, have a testable outcome, depend only on earlier items,
and need no design judgment beyond the plan's text. Items failing →
fix via `/dev plan <slug>` first. User approves → stamp
`agentic: approved YYYY-MM-DD`.

### Batches

`.claude/plans/batches/B-XXX.md` — ordered checklist, one `[ ]` per task:

    # B-001
    - [ ] T-014 (<slug>)
    - [ ] T-015 (<slug>)

Execution grouping, not a planning level: members must be open tasks
with agentic-approved plans; `depends-on` must resolve within batch
order or already-merged work. Soft cap ~25 planned commits total.
Manual mode may use an open batch as its task queue; auto mode
requires one. Checkbox closes at checkpoint validation.

### Rails

- Agents touch only code, plan checkboxes, and findings files —
  never plan content, never the closing decisions.
- Pre-flight creates `batch/B-XXX` off the default branch and sets the
  `pre-B-XXX` tag (belt-and-braces). Member branches merge into the
  batch branch only; the default branch is untouched until the batch
  MR merges.
- Agents never push. The only push in the flow is the checkpoint-accept
  push of the batch branch — never the default branch (mechanics:
  `delegating-to-agents` checkpoint).
- No commit on red tests/lint — no exceptions.
- Findings triage and push decisions always defer to the checkpoint.
- Branch refs are kept until the user validates the checkpoint.
  Reject = delete the batch branch; member refs preserved for salvage.

### Stop conditions

| Event | Action |
|---|---|
| Blocker (per § Scope discoveries) | Halt, report |
| NEEDS_CONTEXT unanswerable from REQ/design | Halt, report |
| Spec check rejects the same commit twice | Halt, report |
| Tests/lint not green after the implementer's fix attempt | Halt, report |
| Non-blocker discovery | `T-XXX-<slug>.findings.md`, continue |
| Batch complete | Close phase on `batch/B-XXX`, then checkpoint, wait for user |

Checkpoint accept is the only point where anything is pushed, and only
the batch branch (`delegating-to-agents` owns the mechanics).

## Releases

If the project uses releases, completed branches are listed in
`.claude/plans/release-<version>.md` with `[x]` only after merge to default.
