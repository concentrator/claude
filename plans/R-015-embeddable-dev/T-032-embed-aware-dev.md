task: T-032
type: feat
depends-on: T-031

# feat/embed-aware-dev — embed-aware dev + clone-time check (R-015)

T-032 of `plans/R-015-embeddable-dev/requirements.md` (AC5). Make this
repo's `dev` orchestrator embed-aware so a contributor with a global
toolchain still routes `/dev` into an embedded project's `dev-*` skills,
and ship a clone-time check that warns when the global `dev` is missing or
too old to be embed-aware. `/dev` is preserved for everyone.

**Design decisions (approved):**
- **Clone-time trigger: manual.** The vendor ships
  `.claude/scripts/dev-embed-check.sh`; the embedded project documents
  "run it after cloning." No Claude Code hook dependency.
- **Staleness detection: capability marker.** The embed-aware `dev` carries
  a stable `<!-- dev-embed-aware -->` marker; the check greps the global
  `dev/SKILL.md` for it (present → embed-aware; absent → stale → warn).

**Altitude note.** Commit 1 edits the `dev` skill (prose, not TDD-able):
verified by the marker's presence + the ≤400-word orchestrator cap, and it
needs explicit approval (`skills.md` gate). Commits 2–3 are TDD.

- [x] Make `skills/dev/SKILL.md` embed-aware: when the project has
  `.claude/.dev-toolchain.json`, dispatch to the `dev-*` skills and follow
  the embedded `.claude/rules`; add the `<!-- dev-embed-aware -->`
  capability marker. Keep ≤400-word orchestrator cap. (skill edit —
  propose + approval)
- [x] Clone-time check script `scripts/dev-embed-check.sh` + test (TDD):
  in an embedded project (marker present), warn when no global
  `~/.claude/skills/dev` exists is acceptable (embedded `dev` serves
  `/dev`); warn when a global `dev` exists but lacks the
  `<!-- dev-embed-aware -->` marker (stale → update); silent when the
  global `dev` is embed-aware. Test drives each branch with fixture dirs.
- [x] Vendor emits the check into embedded `.claude/`: extend
  `scripts/vendor-toolchain.sh` to copy `dev-embed-check.sh` into the
  target's `.claude/scripts/` and note "run after cloning" in the emitted
  `CLAUDE.md` backbone; test the vendored output includes the check and
  the note.
- [ ] Document the embed-aware behavior + clone-time check in `README.md`
  (doc-before-commit), then complete the branch: re-review across commits,
  cleanup, confirm `bash scripts/ci/run-all.sh` green, triage the findings
  file, mark the plan complete, commit.
