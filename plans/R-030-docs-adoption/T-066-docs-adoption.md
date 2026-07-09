task: T-066
type: feat
depends-on: T-065

# feat/docs-adoption - migrate docs audit, build, correction (R-030)

T-066 of `plans/R-030-docs-adoption/`. Add a docs-adoption step to
`migrate.md` for bringing an existing project onto the docs convention:
audit the whole project, build a user-prioritized subset (reusing any prior
docs), and correct the workflow. Depends on T-065 (the index) and R-023 (the
`docs/` artifact + doc-first cycle, merged).

Acceptance criteria: see `requirements.md` (whole-project audit grading +
reusing existing docs; backlog; code issues registered as fixable tasks;
user-prioritized build, always performed; workflow correction wiring the
doc-first cycle + index).

- [ ] `migrate.md`: add the docs-adoption step (audit + backlog) - a whole-project pass at the project's docs-granularity: grade existing docs with the `dispatching-parallel-agents` fresh-agent spec-check (PASS/WARN/FAIL/TODO) and reuse them as build input; a missing doc is FAIL/TODO (no agent); backlog the gaps; register any code issues found while probing as fixable tasks (a fitting open `R-XXX` -> `T-XXX`, else an R stub, per `migrate § 6`).
- [ ] `migrate.md`: the build + workflow-correction phase - build `.claude/docs/` for a subset the user prioritizes (ask which features matter most; build always occurs, even from zero docs; prior docs feed the new ones), the rest on-touch; wire the doc-first cycle + the index into the project.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
