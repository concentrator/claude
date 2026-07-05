task: T-052
type: feat
depends-on: T-051

# feat/routine-commands — routine-commands convention (R-022)

T-052 of `plans/R-022-conventions/`. A project's CLAUDE.md declares its VCS
host + exact git/test/lint/build commands; execution reads them (host-aware
`gh`/`glab`) instead of probing; `migrate` backfills, `start` scaffolds.
`depends-on: T-051` — both edit `layout.md` / `start.md`; sequence.

Acceptance criteria: see `requirements.md` (project CLAUDE.md § Commands
declares host + commands; `finish` + the `git-workflow` companion read
them, no probing; `migrate` backfills).

- [ ] `layout.md`: define the project CLAUDE.md § Commands convention — declared VCS host (→ `gh`/`glab`) + exact open-change-request / merge / test / lint / build commands (extend the required project CLAUDE.md sections from T-051).
- [ ] `git-workflow.md` companion: state that execution reads the declared § Commands (host-aware) for change-request / merge operations rather than probing.
- [ ] `finish.md`: consume the declared § Commands for the change-request + merge step (no host probing).
- [ ] `migrate.md`: backfill § Commands when absent (CLAUDE.md-alignment step); `start.md`: scaffold § Commands in the new project CLAUDE.md.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
