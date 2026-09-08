# Planner Subagent Prompt Template

Use this template when dispatching a planner seat: once per task in the
detail round (`write-plan.md`), and again whenever a blocker or a
cold-read gap needs plan text changed (`plan.md § Adjusting existing
plans`). Its inputs are the initiative's requirements, the task line,
the docs - the project's docs directory, `DESIGN.md` and `README.md`
where present - the code, and the initiative's other plans; on a
re-dispatch, the blocker's or the gap's text as well. Never a
transcript, never the planning conversation.

```
Task tool (general-purpose):
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
      `<plan branch>`.
    - The initiative's other plans, in `<plans directory>`.
    - <Re-dispatch only: the blocker's or the cold-read gap's text,
      verbatim.>

    Nothing else is an input. A question these cannot answer is
    reported as NEEDS_CONTEXT, never guessed: no transcript and no
    planning conversation reaches you.

    ## Your Job

    1. Resolve the chain, decompose the work, and add the header and
       the mandatory final item per `write-plan.md` steps 1 and 3 to
       5. Every item passes `write-plan.md § Readiness checklist`.
       Leave `cold-read: passed` out of the header - it is written by
       step 6, which is not yours.
    2. Write the plan to `<path to the plan file>`. The dispatch names
       that file: you neither choose the slug nor create the branch.
    3. On a change to an existing plan, state the change as a diff of
       items - which items are added, reworded or dropped, and why -
       and make exactly that change. The rest of the plan stays as it
       is.
    4. Commit on `<plan branch>` (message rules: ## Conventions).
       Never push: delivery is the dispatcher's.

    ## Conventions

    Follow `git-workflow.md § Commit messages`, `CLAUDE.md
    § Audience visibility` and `rules/writing-artifacts.md` - a plan
    states the present and carries no history fields. Edit the plan
    file with the Read/Edit/Write tools, never `sed`/`cat`/`awk`
    (`rules/writing-artifacts.md § Bulk edits`), and never write
    config - settings, hooks, skills, rules, `CLAUDE.md` - wherever it
    lives.

    ## Exit

    Report back. The plan is not yours to approve or deliver: the
    dispatching session runs the cold read (`write-plan.md` step 6),
    a gap re-dispatches a planner with the gap's text, and a pass
    records `cold-read: passed` in the header (`branch-plan.md
    § Header`). Dispatch nothing yourself - no seat dispatches a seat.

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
