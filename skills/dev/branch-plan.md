# Branch plan rules

A branch plan is `plans/R-XXX-<slug>/<task-id>-<slug>.md` (root-relative;
dir per roadmap entry - `plan.md § Directory conventions`). One
branch = one task. The plan must be complete and committed to `main`
**before** the branch is created.

## Header

    task: R008-T002
    type: feat                      # required - from task tag; sets branch prefix
    architecture-changing: true     # optional - triggers DESIGN.md update commit
    depends-on: R008-T001           # optional - blocks `/dev code` until merged
    agentic: approved 2026-06-10    # optional - auto-eligible; absent = manual-only

## Body

A checkbox list. Each `[ ]` = one commit. Each item names the change and
any documentation it touches. Marks record what happened, never
intent - a commit that didn't land stays `[ ]`.

## Per-commit rules

### Doc-before-commit

A doc that depends on a later commit gets a placeholder + sub-task,
replaced in the commit that completes it; everything else updates in
the same commit as its code (§ Commit cadence).

### Commit cadence (all types)

Every execution pass ends the same way; `feat`/`fix`/`refactor` add
their mode file's loop, `doc`/`test`/`mnt` run this alone:

1. **Verify** - project test + lint commands green.
2. **Docs** - per project `CLAUDE.md § Conventions`, in *this* commit:
   `release-routine: yes` → CHANGELOG `## [Unreleased]` entry
   (`changelog.md`); new public
   surface → `README.md`; `extended-docs: yes` → per conventions
   (feature `docs/` docs reconcile at close).
3. **Commit** - single-line message; mark the plan `[x]` immediately.

Open `[ ]` items → next pass; last non-final `[x]` → § Closing routine.

### No TODOs in code

Never write `TODO`/`FIXME`/`XXX` in code. Route each to a plan artifact
(branch-plan commit, the R's `tasks.md`, or an R stub) at discovery
(§ Scope discoveries).

## Mid-execution rules

### Scope discoveries

Noticed mid-execution, not in the plan.

**Blocker** - proceeding would produce wrong, unsafe, or contradictory
code, the current task's premise is invalidated, a plan item can't be
interpreted unambiguously, or verification keeps failing after repeated
fixes:
- **Stop. Ask the user.** Resolution may require plan extension, new
  task, new R, or aborting the branch. Never inline-fix beyond a true
  typo in code you're writing.

**Non-blocker** - improvement, refactor idea, tangential test gap, code
smell, naming inconsistency:
- Within this branch's scope → fix it here as a commit; don't defer
  in-scope work to a finding.
- Belongs to a different component → append to the plan's
  sibling `<task-id>-<slug>.findings.md` (one line + brief context), continue
  coding, and triage at close.
- Never silently expand scope.

### Scope changes mid-branch

Changes needed after the final commit → adjust the plan via
`/dev plan <slug>` (`plan.md § Adjusting existing plans`): new
checkboxes plus a new final commit.

## Closing routine

Runs when the last non-final `[ ]` turns `[x]`; ends in the final
commit and the hand-off (`finish`).

1. **Close review, scaled to the branch** (`small` = ≤9 commits):

   | The diff changes | Review |
   |---|---|
   | code, behavior preserved | `/simplify` |
   | code, behavior added or fixed | `/code-review` |
   | prose, rules, docs, plans | `/code-review` |
   | data or config | `/code-review` |
   | more than one row | both |

   Bookkeeping (plan marks, CHANGELOG) keys no row. The size governor
   overrides: mixed-purpose (more than one task tag) or >9
   commits → both. Also run the **Tier-2 compliance review**: confirm
   every concern listed in `MAINTENANCE.md § Tier-2 AI review` over the
   diff.
2. Validate the review's findings against full project context.
3. Print report; request user approval before applying.
4. Apply approved fixes as additional commits if needed.
5. Capture the branch outcome: a summary against the task's acceptance
   criteria; surface manual-testing/automation needs (verify per diff
   content: `finish § 2`).
6. **Triage `<task-id>-<slug>.findings.md`** - in-scope findings are resolved
   in this branch (as commits), not deferred (routing:
   § Scope discoveries). For each remaining `[ ]`, prompt user:
   - Promote to a task or an R stub (`plan.md § Referential
     integrity` owns the routing)
   - Discard (mark `[x]` with reason: "won't fix")
7. **Reconcile the feature doc** - write or update the `docs/` doc
   to match the shipped code, then
   complete it - and every doc the branch ships, re-review edits
   included - through the verification gate
   (`companions/documentation.md § Verification gate`) before delivery. Then
   the **mandatory final two items** of every plan:

   > Mark and commit the task `[x]` in the R's `tasks.md`, plus any
   > release-plan entry. (Auto-mode members: § Batches.)
   >
   > Complete the branch: re-review docs across all commits, cleanup
   > (stale/temp data), mark plan complete, commit.

   The commit includes the resolved findings file and the reconciled
   doc; closing the R's last open task → run the closure check
   (`plan.md § Approval and closure`); verified → ROADMAP `[x]`. Marks
   land with the merge; a rejected branch discards them.
8. Invoke `finish` - present the delivery options and execute.

## Architecture-changing branches

If header has `architecture-changing: true`, the plan must include a commit
that updates `DESIGN.md`. Routine branches do not modify `DESIGN.md` -
except routine tree-map upkeep (adding a new file to `DESIGN.md § Tree-map`),
which any branch may fold into its final commit without the flag.

## Size cap

A branch runs ~20 commits (medium): warn past 20, prompt to
split past 30 - subordinate to the short-lived governor
(`git-workflow.md § Delivery cadence`). Override with stated
reason in plan header.

## Agentic execution

The **batch** - one or more coupled tasks shipped as a single CI-gated
MR/PR - is the unit of delivery to `main` in both modes. A lone task
is a batch of one - its own branch is the MR/PR. Auto mode (`/dev auto`)
runs the members via subagents on a `batch/B-XXX` branch;
manual mode (`/dev code`) implements them by hand. Only
verification differs: auto runs the checkpoint below, manual uses
§ Closing routine + `finish`.

### `agentic:` stamp

A plan becomes auto-eligible via a **readiness review** (run by
`/dev plan batch` for unstamped plans): each commit item must be
unambiguous, have a testable outcome, depend only on earlier items,
and need no design judgment beyond the plan's text - backed by a
cold-reader check (`companions/verification-policy.md § Comprehension
check`). Items failing → fix via `/dev plan <slug>` first. User approves → stamp
`agentic: approved YYYY-MM-DD`.

### Batches

`plans/R-XXX-<slug>/batches/B-XXX.md` - ordered member list:

    # B-001
    - R008-T001 (<slug>)
    - R008-T002 (<slug>)

Composition only (members, order, mode), never status - task state's
one home is the R's `tasks.md`. Open iff a member task is `[ ]` there
and no `B-XXX.report.md` exists.

Delivery grouping, not a planning level: a batch is scoped to the R
whose dir holds it - members are its open tasks (coupling: tasks not
independently shippable). `depends-on` must resolve within batch
order or already-merged work. A cross-initiative need becomes its own R. The
checkpoint validates that R's acceptance criteria. Soft cap
~30 planned commits total (§ Size cap governor). Auto mode requires a stamped
batch.

Batch-close bookkeeping: the close phase marks member-task
checkboxes as commits on `batch/B-XXX` before the MR/PR - marks land
per § Closing routine; reject: § Rails. The R-closure
check and release marking ride a close-out plan MR/PR
(`plan/r<NNN>-close`) opened after the batch MR/PR merges.

Per-branch close in auto mode: the close review (the `code-reviewer`
pass) runs only for branches above the small-branch threshold in
the `auto` verification policy - small branches
defer their first review to the batch-close full-diff pass. The
mandatory final commit and the tests/lint-green gate before merging
into `batch/B-XXX` hold for every branch regardless of size. The
manual-mode § Closing routine above is unchanged by this rule.

### Rails

- Agents touch only code, plan checkboxes, and findings files -
  never plan content, never the closing decisions.
- Pre-flight creates `batch/B-XXX` off latest `main` and sets the
  `pre-B-XXX` tag (rollback anchor). Member branches merge into the
  batch branch only; `main` is untouched until the batch MR/PR merges.
- Agents never push; the only delivery is the checkpoint-accept
  **CI-gated MR/PR** of the batch branch to origin (mechanics: `auto`
  checkpoint).
- No commit on red tests/lint - no exceptions.
- Findings triage and push decisions defer to the checkpoint.
- Branch refs are kept until the user validates the checkpoint.
  Accept = delete the `pre-B-XXX` tag and member branch refs.
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
| Non-blocker discovery | `<task-id>-<slug>.findings.md`, continue |
| Batch complete | Close phase on `batch/B-XXX`, then checkpoint (accept opens the MR/PR), wait for user |

## Releases

If the project uses releases, completed branches are listed in
`plans/release-vX.Y.Z.md`; the `[x]` is one of the closing
routine's marks (auto mode: § Batches). Releases are
tagged on the trunk (`git-workflow.md § Releases`).
