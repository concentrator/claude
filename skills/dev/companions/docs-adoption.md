# Docs adoption procedure

Bring a project's `.claude/docs/` feature docs onto the doc-first convention.
Run during a `migrate` adoption, or standalone via `/dev docs` - on a fresh
adoption or as a re-runnable refresh of an already-documented project.

## Audit

Audit the whole project at its docs-granularity (`layout.md § Docs`; the
model is recorded in `CLAUDE.md § Conventions`). Grade against the
framework (`documentation.md`, applied to features per `layout.md § Docs`)
on two axes - **code-drift** and **convention-conformance** (the right
Diataxis type, the Reference skeleton, the detail bar); a project's
`.claude/rules/feature-docs.md` where present supersedes the default bar.
Per feature:

- an existing doc → grade it against the code and the framework with a
  fresh-agent spec-check (`dispatching-parallel-agents`): PASS (conformant
  and current), WARN (code-drifted, below the detail bar, or built to a
  prior convention - a re-align candidate), FAIL/TODO; keep it as input
  when the doc is rebuilt;
- no doc → FAIL/TODO (no agent needed).

Register any code issues found while probing (bugs, inconsistencies, debt) as
fixable tasks - a `T-XXX` under a fitting open `R-XXX`, else an R stub
(`plan.md § Referential integrity`). Record the coverage report; the missing
docs and the WARN (drifted) ones are the backlog.

## Build

Build or rebuild `.claude/docs/` to the framework (`documentation.md`, per
the `layout.md § Docs` mapping) for the features the user prioritizes - ask which matter most (entrypoints and
high-churn areas are good candidates). The build always runs, even from zero
docs; the rest stay on the backlog, backfilled on-touch by the doc-first
cycle. Reuse graded existing docs as input, and add each doc to
`.claude/docs/index.md`. Re-aligning a WARN doc restructures it to its
Diataxis type and skeleton and fills the detail bar. A built, refreshed,
or re-aligned doc is complete only after the verification gate
(`documentation.md § Verification gate`).

## Correct the workflow

So future work maintains the docs:

- record the docs conventions in `CLAUDE.md § Conventions` if absent - the
  granularity model and the `.claude/docs/index.md` pointer;
- rely on the read-at-plan / reconcile-at-close lifecycle (`branch-plan.md`,
  `write-plan.md`) that ships with DEV.
