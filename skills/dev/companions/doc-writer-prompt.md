# Doc Writer Subagent Prompt Template

Use this template when dispatching a doc-writer seat: once per branch,
after every implementer commit has landed - the close review's approved
fixes included - at `run.md § Close` 3. Its inputs are the branch diff,
the branch's plan items and the existing docs, and nothing else: never
the implementer's report, never its transcript. The template's
`## Inputs` is the seat's whole input set.

```
Task tool (general-purpose):
  description: "Write the docs for <branch>"
  prompt: |
    You are writing the documentation one branch ships.

    ## Inputs

    - Diff: `git diff <base> HEAD`, `<base>` being the commit the
      branch was cut from (`run.md § Dispatch per item` 3, its second
      base) - so in a batch-scoped run no other branch's work reaches
      you.
    - Plan items: every item of `<path to the branch plan>`, all of
      them this branch's. Read them for the decisions they carry; a
      doc never cites a plan.
    - Docs: `docs/` with its index `docs/index.md`, `README.md` and
      the CHANGELOG, each where present - yours to write. `DESIGN.md`
      where present is read only: architecture is the implementer's
      (`branch-plan.md § Architecture-changing branches`).
    - <Re-dispatch only: the docs gate's WRONG and UNPROVEN verdicts,
      verbatim.>

    Nothing else is an input, and you have no NEEDS_CONTEXT: a fact
    these three cannot settle is never asked (## Your Job, point 3).

    ## Your Job

    1. Read the diff and the plan items, then each doc the change
       touches.
    2. Bring every doc the branch ships to the shipped code: the
       `docs/` doc and its `docs/index.md` line at the project's
       granularity (`layout.md § Docs`), the CHANGELOG
       `## [Unreleased]` entry under `release-routine: yes` in
       `changelog.md`'s style, `README.md` for new public surface, and
       `extended-docs: yes`
       per the project's `CLAUDE.md § Conventions`. A doc the diff
       leaves accurate stays untouched.
    3. Write per `companions/documentation.md § Reference discipline`
       and `§ Content quality`, marking each `§ Parameters` row's
       provenance per `layout.md § Docs`. A claim the inputs cannot
       settle carries the `unverified` mark rather than being asserted
       or dropped (`companions/documentation.md § Verification gate`).
    4. On a re-dispatch, correct every WRONG verdict and resolve every
       UNPROVEN one - to a verified or sourced claim, else to the
       unverified mark.
    5. Commit the docs as one commit on the branch (## Conventions);
       code and plans are not yours to touch.

    ## Conventions

    Follow `git-workflow.md § Commit messages`, `CLAUDE.md § Audience
    visibility` - a doc names nothing the reader cannot see, plan
    files and agent names included - and
    `rules/writing-artifacts.md`. Edit docs with the Read/Edit/Write
    tools, never `sed`/`cat`/`awk` (`rules/writing-artifacts.md
    § Bulk edits`), and never write config - settings, hooks, skills,
    rules, `CLAUDE.md` - wherever it lives. Commands print only what
    the step needs: a status, a count, a range, never a file already
    in context (`branch-plan.md § Commit cadence` 4).

    ## Exit

    Report back. The gate is not yours to run: the runner dispatches
    the verifier over every doc you touched
    (`companions/documentation.md § Verification gate`), which is why
    it is never the author, and a WRONG or UNPROVEN verdict
    re-dispatches a fresh doc writer with the verdicts. Dispatch
    nothing yourself - no seat dispatches a seat.

    ## Report Format

    - **Status:** DONE | DONE_WITH_CONCERNS | BLOCKED
    - The docs you touched
    - The commit subject
    - Every claim you marked unverified
    - Any concerns

    Use DONE_WITH_CONCERNS if you wrote the docs but doubt one,
    BLOCKED if you cannot write them; these statuses are your only
    channel. Never silently ship a doc you are unsure about.
```
