task: T-080
type: refactor
depends-on: T-079

# refactor/core-dedup - single-home the /dev core (R-039)

T-080 of `plans/R-039-single-home/`. One owner per rule across the core;
behavior preserved (contradictions already fixed by T-079). Every touched
file ends net smaller; caps hold.

- [x] Single-source the git-workflow twins: `skills/dev/git-workflow.md` is canonical; `rules/git-workflow.md` becomes a thin pointer carrying only the repo pin (GitHub → PR) - both files are read-on-demand, nothing always-loaded is lost.
- [x] `SKILL.md`: fold the per-command sections (release/migrate/start/docs) into the Surface table (add the read-file column); drop the VIBE-default sentence (CLAUDE.md owns it); keep round names only, `plan.md` owns the never-auto-start guard.
- [x] `plan.md`: state the R-dir convention once (§ Directory conventions canonical), approval-gate sentence once, REQ-retirement once; trim slug/trunk restatements to git-workflow pointers.
- [x] Planning trio: `templates.md` shape-deferral → one-line plan.md pointer; `brainstorm.md` drops its four restatements (one-act, deferral, approved-stamp, never-auto-execute) and two intra-file dups; `write-plan.md` single-homes the probe rule in step 3, drops the ≤20-slug and ~20/~30 cap constants (cite owners), deletes the redundant closing pointer.
- [x] `branch-plan.md` trims (~150w): delete header-comment dup lines 16-17, findings-promotion → cite `plan.md § Referential integrity`, never-push stated once, batch definition aligned with git-workflow § Coherent delivery (one owner), § Batches cites the closing-routine marks instead of restating, size-cap subordination cited not restated.
- [x] `layout.md`: bare tree (annotations that restate `plan.md` conventions dropped; lazy tags live only in § Creation policy); external/internal distinction stated once in § Docs; `.env` sentence and duplicate hook mention deleted; toolchain wording aligned to `claude-md.md`.
- [x] Execution skeleton: extract the shared Verify/Docs/Commit + Scope-discoveries + Done? cadence into `branch-plan.md § Per-commit rules`; `feat.md`/`fix.md`/`refactor.md` keep only type-specific steps + one pointer (Docs step keeps its one-clause per-type delta); `changelog.md` owns the Internal-heading routing; audience-visibility list in changelog → CLAUDE.md pointer.
- [x] `finish.md`/`auto.md` boundary: auto drops restated halts (§ Stop conditions owns), rails clauses, and the accept/reject ref-handling paragraph (cite § Rails); finish § 1 compresses to a pointer checklist, intra-file dups (verify-blocking twice, deferred-closure twice) merged, trunk-rule sentence dropped.
- [ ] `start.md`/`migrate.md` + always-on: shared scaffold steps single-homed (requirements-gate, layout, toolchain-section, skill-precedence, quality-baseline - migrate keeps the fuller text, start points); `MAINTENANCE.md` cites writing.md/claude-md.md instead of restating (concern names stay); rules-trio maintenance block single-homed in `claude-md.md` (skills.md points); git-workflow's audience-visibility enumeration → CLAUDE.md pointer.
- [ ] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.
