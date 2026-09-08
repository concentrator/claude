# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer seat.
Its inputs are the plan, the initiative's acceptance criteria - the
whole list in `requirements.md § Acceptance criteria`, never a
selection - and the diff, and nothing else; the implementer's report
is not an input.

**Purpose:** verify the commit built what the plan item asked (nothing
more, nothing less) and moved no acceptance criterion the wrong way.

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
