# Branch plan rules

A branch plan is `dev/plans/R<NNN>-<slug>/<task-id>-<slug>.md`
(`plan.md § Directory conventions`). One
branch = one task. The plan is complete and committed to `main`
**before** the branch is created.

## Header

    task: R008-T002
    type: feat                      # required - task tag; sets branch prefix
    architecture-changing: true     # optional - triggers DESIGN.md
                                    #   update commit
    depends-on: R008-T001           # optional - blocks `/dev code` until merged
    agentic: approved 2026-06-10    # optional - auto-eligible;
                                    #   absent = manual-only

## Body

A checkbox list: each `[ ]` = one commit, naming the change and any
documentation it touches. Marks record what happened, never intent -
a commit that didn't land stays `[ ]`.

## Doc-before-commit

A doc depending on a later commit gets a placeholder + sub-task,
replaced by the commit completing it; everything else updates in its
code's commit.

## Commit cadence (all types)

Every pass ends the same way; `feat`/`fix`/`refactor` add their mode
file's loop, `doc`/`test`/`mnt` run this alone:

1. **Verify** - project test + lint commands green.
2. **Docs** - per project `CLAUDE.md § Conventions`, in *this* commit:
   `release-routine: yes` → CHANGELOG `## [Unreleased]` entry
   (`changelog.md`); new public
   surface → `README.md`; `extended-docs: yes` → per conventions
   (feature `dev/docs/` docs reconcile at close).
3. **Commit** (`git-workflow.md § Commit messages`); mark the plan
   `[x]` immediately.
4. **Output** - throughout the pass a command prints only what the
   step needs: a status, a count, a range (`grep -c`, `sed -n`, a gate
   or push silenced with its exit status echoed), never a file already
   in context; an edit replaces one anchored span (`Edit`, or `sed` or
   a script asserting a single match), never a heredoc rewrite of the
   file.

Open `[ ]` items → next pass; last non-final `[x]` → § Closing routine.

## No TODOs in code

Never write `TODO`/`FIXME`/`XXX` in code. Route each to a plan artifact
(branch-plan commit, the R's `tasks.md`, or an R stub) at discovery
(§ Scope discoveries).

## Scope discoveries

Noticed mid-execution, not in the plan.

**Blocker** - proceeding would produce wrong, unsafe, or contradictory
code, the task's premise is invalidated, a plan item is ambiguous, or
verification keeps failing after repeated fixes:
- **Stop. Ask the user.** Resolution may require plan extension, new
  task, new R, or aborting the branch. Never inline-fix beyond a true
  typo in code you're writing.

**Non-blocker** - improvement, refactor idea, tangential test gap, code
smell, naming inconsistency:
- In this branch's scope → fix here as a commit, never deferred to a
  finding.
- Another component's → append to the plan's sibling
  `<task-id>-<slug>.findings.md`, continue coding, triage at close.
- Never silently expand scope.

## Scope changes mid-branch

Changes needed after the final commit → adjust the plan via
`/dev plan <slug>` (`plan.md § Adjusting existing plans`): new
checkboxes plus a new final commit.

## Closing routine

Runs when the last non-final `[ ]` turns `[x]`; ends in the final
commit and the hand-off (`finish`).

1. **Close review, scaled to the branch**:

   | The diff changes | Review |
   |---|---|
   | code, behavior preserved | `/simplify` |
   | code, behavior added or fixed | `code-reviewer` agent |
   | prose, rules, docs, plans | `code-reviewer` agent |
   | data or config | `code-reviewer` agent |
   | more than one row | both |

   Cap: one pre-authorised dispatch by the session itself
   (`agents/code-reviewer.md` bounds it), plus a verifier only on a
   Critical finding (`companions/verification-policy.md § Verifier
   isolation`);
   `/code-review` is a manual escalation - suggest, never run.
   Bookkeeping (plan marks, CHANGELOG) keys no row. Size governor:
   mixed-purpose (more than one task tag) or >9
   commits → both. Also the **Tier-2 compliance review**: every concern in
   `MAINTENANCE.md § Tier-2 AI review`, over the diff.
2. Validate findings against full project context.
3. Report; request user approval before applying.
4. Apply approved fixes as commits.
5. Capture the branch outcome: a summary against the task's acceptance
   criteria; surface manual-testing/automation needs (`finish § 2`).
6. **Triage `<task-id>-<slug>.findings.md`** - in-scope findings
   resolve here as commits, not deferrals (§ Scope discoveries).
   For each remaining `[ ]`, prompt user:
   - Promote to a task or an R stub (`plan.md § Referential
     integrity` owns the routing)
   - Discard (mark `[x]` with reason: "won't fix")
7. **Reconcile the feature doc** - write or update the `dev/docs/` doc
   to the shipped code, then take every doc the branch ships
   (re-review edits included) through the verification gate
   (`companions/documentation.md § Verification gate`) before delivery. Then
   the **mandatory final two items** of every plan:

   > Mark and commit the task `[x]` in the R's `tasks.md`, plus any
   > release-plan entry. (Auto-mode members: § Batches.)
   >
   > Complete the branch: re-review docs across all commits, cleanup
   > (stale/temp data), mark plan complete, commit.

   The commit includes the resolved findings file and the reconciled
   doc; closing the R's last open task → the closure check
   (`plan.md § Approval and closure`); verified → ROADMAP `[x]`. Marks
   land with the merge; a rejected branch discards them.
8. Invoke `finish` - present the delivery options and execute.

## Architecture-changing branches

Header `architecture-changing: true` → the plan includes a commit
updating `DESIGN.md`. Other branches touch `DESIGN.md` only for
tree-map upkeep (adding a new file to `DESIGN.md § Tree-map`), foldable into
the final commit without the flag.

## Size cap

A branch runs ~20 commits: warn past 20, prompt to split
past 30; a batch's planned commits split past 30 - subordinate to
the short-lived governor
(`git-workflow.md § Delivery cadence`). Override with stated
reason in plan header.

## Session boundary

A session ends with its delivery unit: a session outliving its unit
re-bills the finished work on every later call.

| Mode | Unit |
|---|---|
| `/dev code` | the task, or the branch where larger |
| `/dev auto`; a supervised worker | the batch |
| `/dev supervise` | the scope |

Doc loading keys to the boundary: one load phase at the unit's
start; sectional reads, not whole files; no re-reads within the
unit; outputs (reports, findings files) wait for triage.
Each role clears at the boundary and re-briefs from `handoff.md`, a
supervisor from its ledger too (`supervise.md § Ledger`).

## Agentic execution

The **batch** - one or more coupled tasks shipped as one CI-gated
MR/PR - is the unit of delivery to `main` in both modes; a lone task
is a batch of one, its branch the MR/PR. Auto mode (`/dev auto`)
runs members via subagents on a `batch/R<NNN>-B<NNN>` branch;
manual mode (`/dev code`) implements them by hand. Only
verification differs: auto runs the checkpoint below, manual uses
§ Closing routine + `finish`.

### `agentic:` stamp

A plan becomes auto-eligible via a **readiness review** (run by
`/dev plan batch` for unstamped plans): each commit item must be
unambiguous, testable, dependent only on earlier items, and free of
design judgment beyond the plan's text - backed by a
cold-reader check (`companions/verification-policy.md § Comprehension
check`). Items failing → fix via `/dev plan <slug>` first. User approves → stamp
`agentic: approved YYYY-MM-DD`.

### Batches

`dev/plans/R<NNN>-<slug>/batches/R<NNN>-B<NNN>.md` - ordered member list:

    # R062-B001
    - R062-T001 (<slug>)
    - R062-T002 (<slug>)

Composition only (members, order, mode), never status - task state's
home is the R's `tasks.md`. Open iff a member is `[ ]` there and no
`R<NNN>-B<NNN>.report.md` exists. Composition is a planning write
(`plan.md § Where plans live in git`).

Delivery grouping, not a planning level: a batch is scoped to the R
whose dir holds it - its open, coupled tasks (not independently
shippable). `depends-on` resolves within batch order or merged work;
a cross-initiative need becomes its own R. The checkpoint validates
that R's acceptance criteria. The § Size cap governor bounds the
batch. Auto mode requires a stamped batch.

Batch-close bookkeeping: the close phase marks member-task
checkboxes as commits on `batch/R<NNN>-B<NNN>` before the MR/PR -
marks land per § Closing routine; reject: § Rails. The R-closure
check and release marking ride a close-out plan MR/PR
(`plan/r<NNN>-close`) after the batch MR/PR merges.

Per-branch close in auto mode: the close review runs only above the
close-folding threshold (`verification-policy.md § Close folding`).
The mandatory final commit and green tests/lint
before merging into the batch branch hold regardless of size.

### Rails

- Agents touch only code, plan checkboxes, and findings files -
  never plan content, never the closing decisions.
- Pre-flight creates `batch/R<NNN>-B<NNN>` off latest `main` and sets the
  `pre-R<NNN>-B<NNN>` tag (rollback anchor). Member branches merge into the
  batch branch only; `main` is untouched until the batch MR/PR merges.
- Agents never push; the only delivery is the checkpoint-accept
  **CI-gated MR/PR** of the batch branch to origin (`auto`
  checkpoint).
- No commit on red tests/lint - no exceptions.
- Findings triage and push decisions defer to the checkpoint.
- Branch refs stay until the user validates the checkpoint.
  Accept = delete the `pre-R<NNN>-B<NNN>` tag and member refs;
  post-merge cleanup deletes the batch branch, local and origin.
  Reject = delete the batch branch; tag and member refs stay for
  salvage.

### Stop conditions

| Event | Action |
|---|---|
| Blocker (§ Scope discoveries) | Halt, report |
| NEEDS_CONTEXT unanswerable from the R's `requirements.md`/design | Halt, report |
| Spec check rejects the same commit twice | Halt, report |
| Tests/lint not green after the implementer's fix attempt | Halt, report |
| Batch-close review finds a folded-branch defect beyond batch-branch fixup | Halt, report |
| Non-blocker discovery | `<task-id>-<slug>.findings.md`, continue |
| Batch complete | Close phase on `batch/R<NNN>-B<NNN>`, then checkpoint (accept opens the MR/PR), wait for user |
