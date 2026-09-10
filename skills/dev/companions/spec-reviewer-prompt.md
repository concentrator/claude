# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer seat.
Its inputs are the plan, the initiative's acceptance criteria - the
whole list in `requirements.md § Acceptance criteria`, never a
selection - the branch base (`run.md § Dispatch per item` 3) and the
diff, and nothing else; the implementer's report is not an input.

```
Task tool (dev-spec-reviewer):
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

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ⚠️ Convention drift only: [list] - spec otherwise compliant
      (handling: `verification-policy.md § Spec-check skip`)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
```
