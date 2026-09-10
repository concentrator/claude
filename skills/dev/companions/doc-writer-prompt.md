# Doc Writer Subagent Prompt Template

Use this template when dispatching a doc-writer seat: once per branch,
after every implementer commit has landed - the close review's approved
fixes included - at `run.md § Close` 3. Its inputs are the branch diff,
the branch's plan items and the existing docs, and nothing else: never
the implementer's report, never its transcript. The template's
`## Inputs` is the seat's whole input set.

```
Task tool (dev-doc-writer):
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
    - Docs: `<docs>`, the docs home the project's root `CLAUDE.md
      § Layout` declares, with its index `<docs>/index.md`,
      `README.md` and the CHANGELOG, each where present - yours to
      write. `DESIGN.md` where present is read only: architecture is
      the implementer's (`branch-plan.md § Architecture-changing
      branches`).
    - <Re-dispatch only: the docs gate's WRONG and UNPROVEN verdicts,
      verbatim.>

    Nothing else is an input, and you have no NEEDS_CONTEXT: a fact
    these three cannot settle is never asked
    (`agents/dev-doc-writer.md`: the claim takes the `unverified`
    mark).

    ## Exit

    Report back. The gate is not yours to run: the runner dispatches
    the verifier over every doc you touched
    (`companions/documentation.md § Verification gate`), which is why
    it is never the author, and a WRONG or UNPROVEN verdict
    re-dispatches a fresh doc writer with the verdicts.

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
