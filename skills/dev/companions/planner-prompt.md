# Planner Subagent Prompt Template

Use this template when dispatching a planner seat: once per task in the
detail round (`write-plan.md`), and again whenever an acceptance-level
question (`run.md § Question resolution`), a cold-read gap or the
user's rejection of a change needs plan text changed (`plan.md
§ Adjusting existing plans`). The template's `## Inputs` is the seat's
whole input set.

```
Task tool (dev-planner):
  description: "Write the branch plan for <task-id>"
  prompt: |
    You are writing one branch plan for a planned task.

    ## Inputs

    - Requirements: `<path to the initiative's requirements.md>` -
      approved requirements and acceptance criteria.
    - Task line: `<task-id>` with its tag, in `<path to tasks.md>`.
    - Docs: the project's docs directory, `DESIGN.md` and `README.md`
      where present - the code's own documentation.
    - Code: the checkout you are in, `<directory>`, on branch
      `<branch>`.
    - The initiative's other plans, in `<plans directory>`.
    - <Re-dispatch only: the acceptance-level question's, the
      cold-read gap's or the user's objection text, verbatim.>

    Nothing else is an input. A question these cannot answer is
    reported as NEEDS_CONTEXT, never guessed: no transcript and no
    planning conversation reaches you.

    ## Your Job

    1. Write the plan to `<path to the plan file>`. The dispatch names
       that file: you neither choose the slug nor create the branch.

    ## Exit

    Report back. The plan is not yours to approve or deliver: the
    dispatching session runs the cold read (`write-plan.md` step 6),
    an acceptance gap re-dispatches a planner with the gap's text and
    re-runs the read over the change - once, what the second read
    still finds going to the findings file (step 6) - an approach gap
    once with no second read, the user's rejection one with the
    objection's text, and a pass records `cold-read: passed` in the
    header (`branch-plan.md § Header`).

    ## Report Format

    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT
    - The plan file, and its items in order - on a change, the diff of
      items
    - Each decision an item implies, and where the item states or
      cites it
    - Anything the inputs could not settle

    Use DONE_WITH_CONCERNS if you wrote the plan but doubt an item,
    BLOCKED if you cannot write it, NEEDS_CONTEXT if an input is
    missing or contradicts another. Never silently produce a plan you
    are unsure about.
```
