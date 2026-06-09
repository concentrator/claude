# Branch plan rules

A branch plan is `.claude/plans/<slug>.md`. One branch = one task. The plan
must be complete and committed to `main` **before** the branch is created.

## Header

    task: T-014
    type: feat                      # required — inherited from task tag; determines branch prefix
    architecture-changing: true     # optional — triggers design.md update commit
    depends-on: T-012               # optional — blocks `/dev code` until merged

The `type:` value is inherited from the parent task's tag in `tasks.md`
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
routes to a plan artifact (branch-plan commit, `tasks.md`, or `REQ-XXX`)
at discovery time. See "Scope discoveries" below.

## Mid-execution rules

### Scope discoveries

Anything you notice mid-execution that wasn't in the plan.

**Blocker** — proceeding would produce wrong, unsafe, or contradictory
code, or the current task's premise is invalidated:
- **Stop. Ask the user.** Resolution may require plan extension, new
  task, new REQ, or aborting the branch. Never inline-fix beyond a true
  typo in code you're currently writing.

**Non-blocker** — improvement, refactor idea, tangential test gap, code
smell, naming inconsistency:
- Append to `.claude/plans/<slug>.findings.md` as a checklist item
  (one line + brief context). Continue coding.
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
6. **Triage `<slug>.findings.md`** — for each `[ ]` item, prompt user:
   - Promote to `T-XXX` (new entry in `tasks.md`, committed to main now)
   - Promote to `REQ-XXX` (defer to next planning round)
   - Discard (mark `[x]` with reason: "won't fix")
7. **Mandatory final commit** — the last `[ ]`:

   > Complete the branch: re-review docs across all commits, cleanup
   > (stale/temp data), mark plan complete, commit.

   Includes the resolved findings file.
8. Invoke `finishing-a-development-branch` — present merge/PR/keep/discard
   options and execute.

## Architecture-changing branches

If header has `architecture-changing: true`, the plan must include a commit
that updates `design.md`. Routine branches do not modify `design.md`.

## Size cap

One task = one branch. Soft cap: warn at 15 planned commits, prompt to split
at 20. Override with stated reason in plan header.

## Releases

If the project uses releases, completed branches are listed in
`.claude/plans/release-<version>.md` with `[x]` only after merge to default.
