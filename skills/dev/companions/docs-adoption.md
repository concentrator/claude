# Docs adoption procedure

Runs the docs-adoption behind `/dev docs` and `migrate § 7`; framing
and re-run semantics: `docs.md`.

## Audit

Audit the whole project at its docs-granularity (`layout.md § Docs`; the
model is recorded in `CLAUDE.md § Conventions`). Grade against the
framework (`documentation.md`, applied to features per `layout.md § Docs`)
on two axes - **code-drift** and **convention-conformance** (the right
Diataxis type, the Reference skeleton, the detail bar); a project's
`.claude/rules/feature-docs.md` where present raises the bar
(`layout.md § Docs`). Per feature:

- an existing doc → grade it against the code and the framework with a
  fresh-agent spec-check (`dispatching-parallel-agents`): PASS (conformant
  and current), WARN (fails either axis - a re-align candidate),
  FAIL/TODO; keep it as input when the doc is rebuilt;
- no doc → FAIL/TODO (no agent needed).

Register code issues found while probing as tasks or R stubs
(`plan.md § Referential integrity`). Record the coverage report; the missing
docs and the WARN ones are the backlog.

## Build

Build or rebuild `dev/docs/` to the framework for the
features the
user prioritizes - ask which matter most (entrypoints and high-churn areas
are good candidates), and offer re-alignment for the WARN docs:
restructure onto the framework, then re-verify. The build always runs,
even from zero docs; the rest stay on the backlog, backfilled on-touch by
the doc-first cycle. Reuse graded existing docs as input, and add each doc
to `dev/docs/index.md`. Any doc produced here is complete only after
the verification gate (`documentation.md § Verification gate`).

## Correct the workflow

So future work maintains the docs:

- record the docs conventions in `CLAUDE.md § Conventions` if absent - the
  granularity model and the `dev/docs/index.md` pointer;
- rely on the read-at-plan / reconcile-at-close lifecycle (`branch-plan.md`,
  `write-plan.md`) that ships with DEV.
