# T-028 findings

- [x] Commit 4 deviation (resolved, won't-fix — correct by design): the branch plan said add a "Draft tasks"
  subsection to the `kind:` templates in `planning-templates.md`.
  Implemented instead as a pointer in `§ Per-initiative` (the shape round
  drafts `tasks.md` alongside `requirements.md`, per `planning.md
  § Levels`) — embedding a tasks section inside `requirements.md` would
  violate the artifact separation (tasks live in `tasks.md`). Intent
  (AC1: shape round yields requirements + draft task list) preserved.
  Triage at branch close.
