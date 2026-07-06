task: T-053
type: feat

# feat/writing-conv - writing-conventions doc (R-026)

T-053 of `plans/R-026-writing-conventions/`. The writing conventions live in a
single dedicated top-level `writing.md`, `@import`ed by CLAUDE.md so they load
every session (not a `/dev` companion). This single-sources them: the global
`~/.claude/CLAUDE.md` imports it (active in every project), and `install-dev.sh`
ships the file + appends the import to an adopter's CLAUDE.md (committed,
team-wide). Reshaped from a shipped companion after confirming `@import` is the
idiomatic team-shared, always-loaded pattern (`CLAUDE.local.md` is gitignored /
per-user). The doc names the em dash as `U+2014`, never the literal character,
so it does not trip its own gate.

Acceptance criteria: see `requirements.md` (a shipped, always-loaded convention
doc states the rules; AI-tells + repetition recorded as Tier-2 criteria). The
homing ("companion" -> "dedicated `@import`ed file") reconciles at R-026 close.

- [x] Move the writing conventions into a dedicated top-level `writing.md`, merging the existing `CLAUDE.md § Writing` content in: convey-intent/terminology, no em dashes (all files, hard), write-like-a-human, no repetition. Not a `/dev` companion; remove `skills/dev/writing.md`.
- [x] `CLAUDE.md § Writing` -> `@writing.md` (single source, always-loaded; drops the inline duplication).
- [x] `MAINTENANCE.md § Tier-2` Writing concern references `writing.md`.
- [x] `DESIGN.md` tree-map: add top-level `writing.md` (also satisfies check-stray).
- [x] `install-dev.sh`: ship `writing.md` into the target and append its `@import` to the target CLAUDE.md, idempotent + no clobber; `install-dev.test.sh` covers it (copied + import present, idempotent).
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
