task: T-067
type: refactor

# refactor/docs-companion - extract docs-adoption to a companion (R-031)

T-067 of `plans/R-031-docs-command/`. Extract the docs-adoption procedure
from `migrate § 7` into `companions/docs-adoption.md`, framed
context-neutrally so both `migrate` and `/dev docs` (T-068) can invoke it.
Behavior preserved for fresh adoption; the audit's drift-grading of existing
docs and the conventions-recording in workflow-correction are made explicit.

Acceptance criteria: see `requirements.md` (companion holds the procedure;
`migrate § 7` is a pointer; audit grades existing docs for drift; workflow
correction records the docs conventions).

- [x] Create `companions/docs-adoption.md`: the audit (whole-project at the project's granularity; grade existing docs doc-vs-code with `dispatching-parallel-agents`, WARN on drift, reuse as input; missing = FAIL/TODO; register code issues as fixable tasks) -> user-prioritized build (ask which matter; always runs; prior docs feed new; add to `.claude/docs/index.md`) -> workflow correction (doc-first cycle + index pointer + record the granularity model and index pointer in `CLAUDE.md § Conventions` if absent). Framed to run standalone on any project.
- [x] Replace `migrate § 7` body with a pointer: "run the docs-adoption procedure (`companions/docs-adoption.md`)". Confirm fresh-adoption behavior is unchanged.
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
