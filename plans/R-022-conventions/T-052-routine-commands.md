task: T-052
type: feat
depends-on: T-051

# feat/routine-commands — routine-commands convention (R-022)

T-052 of `plans/R-022-conventions/`. A project's CLAUDE.md declares its VCS
host + exact git/test/lint/build commands; execution reads them (host-aware
`gh`/`glab`) instead of probing; `migrate` backfills, `start` scaffolds.
`depends-on: T-051` — both edit `layout.md` / `start.md`; sequence.

Acceptance criteria: see `requirements.md` (project CLAUDE.md declares host
+ commands; `finish` + the `git-workflow` companion read them, no probing;
`migrate` backfills).

**Reconciled (pre-flight):** reuse the existing `## Agent toolchain` section
as the single declared-commands home (not a new `§ Commands`) - it already
declares build/test/VCS commands for `/dev auto`. T-052 makes manual `finish`
read it too, and documents the convention in a shipped companion since
`claude-md.md` (which defines it for auto) is personal.

- [x] `companions/toolchain.md`: document the `## Agent toolchain` declaration as the shipped convention - VCS host (→ `gh`/`glab`) + change-request / merge / test / lint / build commands, read by both `/dev auto` (permissions) and manual `finish`; `layout.md` baseline notes CLAUDE.md includes it.
- [x] `git-workflow.md` companion: state that execution reads the declared `## Agent toolchain` host + commands (host-aware) for change-request / merge rather than probing.
- [x] `finish.md`: consume the declared host + change-request/merge command from `## Agent toolchain` (no probing); no declared host → push + print the URL.
- [x] `start.md`: scaffold `## Agent toolchain` in the new project CLAUDE.md; `migrate.md § 4`: backfill it when absent.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
