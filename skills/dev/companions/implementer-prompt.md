# Implementer Subagent Prompt Template

Use this template when dispatching an implementer seat. Its inputs are
the task's plan, the docs and the code - `DESIGN.md` and `README.md`
count as the code's own docs - and nothing else: never the
initiative's requirements, never the planning conversation.

```
Task tool (dev-implementer):
  description: "Implement the next item of <plan path>"
  prompt: |
    You are implementing one commit item from a branch plan.

    ## Inputs

    - Plan: `<path to the branch plan>`. Read it: your item is the first
      `[ ]` checkbox, and the items above it are the branch so far. Its
      `<task-id>-<slug>.findings.md`, where one exists, carries the
      read's open notes: read them with it.
    - Docs: the project's docs directory, `DESIGN.md` and `README.md`
      where present - the code's own documentation.
    - Code: the checkout you are in, `<directory>`.

    Nothing else is an input. A question these three cannot answer is
    reported as NEEDS_CONTEXT, never guessed.

    ## Report Format

    When done, report:
    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - What you implemented (or what you attempted, if blocked)
    - What you tested and test results
    - Files changed
    - Self-review findings (if any)
    - Any issues or concerns

    Use DONE_WITH_CONCERNS if you completed the work but have doubts about correctness.
    Use BLOCKED if you cannot complete the task. Use NEEDS_CONTEXT if you need
    information that wasn't provided. Never silently produce work you're unsure about.
```
