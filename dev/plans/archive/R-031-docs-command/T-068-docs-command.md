task: T-068
type: feat
depends-on: T-067

# feat/docs-command - the /dev docs command (R-031)

T-068 of `plans/R-031-docs-command/`. Add a standalone `/dev docs` entry that
runs `companions/docs-adoption.md` on the current project (whole-project,
on-demand, re-runnable). Depends on T-067 (the companion). On a project that
already has docs, it runs as a refresh: audit existing docs for drift,
rebuild the stale ones the user picks.

Acceptance criteria: see `requirements.md` (`/dev docs` in `SKILL.md
§ Surface` + router; a `docs.md` runs the companion; works on an already-DEV
project as a re-runnable refresh).

- [x] `docs.md` mode file: `/dev docs` runs `companions/docs-adoption.md` on the current project - whole-project, on-demand, re-runnable; a refresh when docs already exist (audit for drift, rebuild the user-picked stale ones).
- [x] `SKILL.md`: add `/dev docs` to the § Surface table + a `## /dev docs` section mapping it to `docs.md` (the router dispatch). Trim ~20 words elsewhere to stay within the <=400-word orchestrator cap; propose the diff for approval first (`rules/skills.md § Approval`).
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
