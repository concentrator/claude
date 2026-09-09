# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer seat.
Its inputs are the plan, the initiative's acceptance criteria - the
whole list in `requirements.md § Acceptance criteria`, never a
selection - the branch base (`run.md § Dispatch per item` 3) and the
diff, and nothing else; the implementer's report is not an input.

**Purpose:** verify the commit built what the plan item asked (nothing
more, nothing less), moved no acceptance criterion the wrong way and
left the item's acceptance as the planner wrote it.

```
Task tool (general-purpose):
  description: "Review spec compliance for commit item"
  prompt: |
    You are reviewing whether one commit matches its specification.

    ## Inputs

    - Plan: `<path to the branch plan>`; the item under review is
      `<item text>`, the rest of the plan its context.
    - Acceptance criteria: `<path to requirements.md>` § Acceptance
      criteria - the whole list.
    - Diff: the commit `<sha>` (`git show <sha>`).
    - Branch base: `<base>`, the planner commit the branch's latest
      ledgered answer names, else the commit the branch was cut from
      (`run.md § Dispatch per item` 3), for the plan file's diff.

    Nothing else is an input.

    ## Your Job

    Read the diff against the item and the criteria and verify:

    **Missing requirements:**
    - Did the commit implement everything the item asked?
    - Are there parts of the item it skipped or missed?
    - Does it move any acceptance criterion the wrong way?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?

    **Convention drift (rail-strength sensor):**
    - Does the commit message follow git-workflow.md § Commit messages?
    - Were docs updated per project conventions where the commit item required it?
    - CLAUDE.md is in your context - check against it directly; flag drift even when the implementation is otherwise spec-compliant.

    **Acceptance unchanged:** `git diff <base> <sha> -- <plan path>`
    shows no change in the item's acceptance - its text up to the
    `Approach:` run-in. A changed approach is the implementer's and no
    finding; a changed acceptance is an issue (`run.md § Seats`).

    **Verify by reading code.** Use the Read tool and
    plain `git show <ref>:<path>` - not process/command substitution
    (`diff <(git show ...)`, `$(grep ...)`), which the permission matcher
    can't allowlist and which stalls the run on a prompt.

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ⚠️ Convention drift only: [list] - spec otherwise compliant
      (handling: `verification-policy.md § Spec-check skip`)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
```
