---
paths:
  - "**/plans/**/*.md"
  - "**/plans/*.md"
---

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

The `type:` value is inherited from the parent task's tag in its R's
`tasks.md` (e.g. `T-014 (R-001) [feat]:`). Branch prefix matches.

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
routes to a plan artifact (branch-plan commit, the R's `tasks.md`, or an
R stub) at discovery time. See "Scope discoveries" below.

## Mid-execution rules

### Scope discoveries

Anything you notice mid-execution that wasn't in the plan.

**Blocker** — proceeding would produce wrong, unsafe, or contradictory
code, the current task's premise is invalidated, a plan item can't be
interpreted unambiguously, or verification keeps failing after repeated
fixes:
- **Stop. Ask the user.** Resolution may require plan extension, new
  task, new R, or aborting the branch. Never inline-fix beyond a true
  typo in code you're currently writing.

**Non-blocker** — improvement, refactor idea, tangential test gap, code
smell, naming inconsistency:
- Within this branch's scope → fix it here as a commit; don't defer
  in-scope work to a finding.
- Belongs to a completely different component → append to the plan's
  sibling `T-XXX-<slug>.findings.md` (one line + brief context), continue
  coding, and triage at close.
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

1. **Close review, scaled to the branch** (`small` = ≤9 commits):
   refactor (no behavior change) → `/simplify`; single feature or single
   bugfix → `/code-review`; mixed-purpose (more than one task tag) or >9
   commits → both.
2. Validate the review's findings against full project context.
3. Print report; request user approval before applying.
4. Apply approved fixes as additional commits if needed.
5. Capture the branch outcome for the close report: a summary against
   the task's acceptance criteria, and — when the target is data
   collection or processing — run the work product and collect the
   results. Surface manual-testing/automation needs. This outcome is
   presented with the merge options at step 8 (`finishing-a-branch § 2`),
   never skipped.
6. **Triage `T-XXX-<slug>.findings.md`** — in-scope findings are resolved
   in this branch (as commits), not deferred; the file should hold only
   findings belonging to a **completely different component**. For each
   remaining `[ ]`, prompt user:
   - Promote to `T-XXX` (new entry in the parent R's `tasks.md`,
     committed to main now) — only under a fitting open `R-XXX`; none →
     use the R-stub route
   - Promote to an R stub (`planning.md § Directory conventions`; shaped
     in a later shape round)
   - Discard (mark `[x]` with reason: "won't fix")
7. **Mandatory final commit** — the last `[ ]`:

   > Complete the branch: re-review docs across all commits, cleanup
   > (stale/temp data), mark plan complete, commit.

   Includes the resolved findings file.
8. Invoke `finishing-a-branch` — present merge/PR/keep/discard
   options and execute.

## Architecture-changing branches

If header has `architecture-changing: true`, the plan must include a commit
that updates `DESIGN.md`. Routine branches do not modify `DESIGN.md` —
except routine tree-map upkeep (adding a new file to `DESIGN.md § Tree-map`),
which any branch may fold into its final commit without the flag.

## Size cap

One task = one branch, right-sized at ~20 commits (medium). Soft cap:
warn past 20, prompt to split past 30. The count is subordinate to the
short-lived governor — the branch must still merge within ~2 days (≤3
branches active; no big-bang merges — `git-workflow.md § Delivery
cadence`). Override with stated reason in plan header.

## Agentic execution

The **batch** is the unit of delivery to `main` in both modes: one or
more tasks that must land together, shipped as a single CI-gated PR
(`git-workflow.md`). A lone task is a batch of one — its
own branch is the PR. Auto mode (`/dev auto`, engine
`delegating-to-agents`) runs a batch's members via subagents on a
dedicated `batch/B-XXX` branch; manual mode (`/dev code`) implements
them by hand. Delivery is identical; only verification differs — auto
runs the checkpoint below, manual uses § Closing routine +
`finishing-a-branch`. `main` is never touched mid-run; auto requires
every gate below.

### `agentic:` stamp

A plan becomes auto-eligible via a **readiness review** (run by
`/dev plan batch` for unstamped plans): each commit item must be
unambiguous, have a testable outcome, depend only on earlier items,
and need no design judgment beyond the plan's text. Items failing →
fix via `/dev plan <slug>` first. User approves → stamp
`agentic: approved YYYY-MM-DD`.

### Batches

`.claude/plans/R-XXX-<slug>/batches/B-XXX.md` — ordered checklist,
one `[ ]` per task:

    # B-001
    - [ ] T-014 (<slug>)
    - [ ] T-015 (<slug>)

Delivery grouping, not a planning level: a batch is scoped to the R
whose dir holds it — members are open tasks of that R; coupled tasks
(`depends-on`, or any not independently shippable) belong in one batch. `depends-on` must resolve within batch order
or already-merged work. A cross-initiative need becomes its own R. The
checkpoint validates exactly that R's acceptance criteria. Soft cap
~25 planned commits total. Auto mode requires a stamped batch; manual
mode groups coupled tasks into a batch, or ships a lone task as its
own PR.

Batch-close bookkeeping: the close phase marks batch and member-task
checkboxes as commits on `batch/B-XXX`, **before** the PR — the `[x]`
reaches `main` atomically with the merge; reject discards the marks
with the branch (§ Rails). The R-closure check and release-plan
marking ride a separate close-out PR.

Per-branch close in auto mode: the close review (the `code-reviewer`
pass) runs only for branches above the small-branch threshold defined
in the `delegating-to-agents` verification policy — small branches
defer their first review to the batch-close full-diff pass. The
mandatory final commit and the tests/lint-green gate before merging
into `batch/B-XXX` hold for every branch regardless of size. The
manual-mode § Closing routine above is unchanged by this rule.

### Rails

- Agents touch only code, plan checkboxes, and findings files —
  never plan content, never the closing decisions.
- Pre-flight creates `batch/B-XXX` off latest `main` and sets the
  `pre-B-XXX` tag (rollback anchor). Member branches merge into the
  batch branch only; `main` is untouched until the batch PR merges.
- Agents never push. The only delivery is the checkpoint-accept
  **CI-gated PR** of the batch branch to origin (`batch/B-XXX →
  origin/main`) — never a push to `main` (mechanics:
  `delegating-to-agents` checkpoint, `git-workflow.md`).
- No commit on red tests/lint — no exceptions.
- Findings triage and push decisions always defer to the checkpoint.
- Branch refs are kept until the user validates the checkpoint.
  Accept = delete the batch's `pre-B-XXX` tag (rollback no longer
  needed, and lingering tags keep the friction-log hook armed).
  Reject = delete the batch branch; the `pre-B-XXX` tag and member refs
  are preserved for salvage.

### Stop conditions

| Event | Action |
|---|---|
| Blocker (per § Scope discoveries) | Halt, report |
| NEEDS_CONTEXT unanswerable from the R's `requirements.md`/design | Halt, report |
| Spec check rejects the same commit twice | Halt, report |
| Tests/lint not green after the implementer's fix attempt | Halt, report |
| Batch-close review finds a folded-branch defect beyond batch-branch fixup | Halt, report |
| Non-blocker discovery | `T-XXX-<slug>.findings.md`, continue |
| Batch complete | Close phase on `batch/B-XXX`, then checkpoint (accept opens the PR), wait for user |

Checkpoint accept is the only delivery — a CI-gated PR of the batch
branch to origin, never a push to `main` (`delegating-to-agents` owns
the mechanics).

## Releases

If the project uses releases, completed branches are listed in
`.claude/plans/release-<version>.md` with `[x]` only after they reach
`main` via a merged PR. Releases are tagged on the trunk
(`git-workflow.md § Releases`).
