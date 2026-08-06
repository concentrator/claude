task: T-081
type: refactor
depends-on: T-080

# refactor/companions - single-home the companions (R-039)

T-081 of `plans/R-039-single-home/`. Companions own their domain detail;
consumers point. Prompt files keep justified inlines (subagents lack
context); only drifted or self-duplicated text goes.

- [x] Carve-out ownership: `companions/untracked-claude.md` is the single home for untracked-mode deviations; `migrate.md` (detection command, conventions key), `finish.md` (§ 1/§ 4 clauses), `start.md`, and the git-workflow plan-prefix carve-out shrink to one-line pointers.
- [x] `companions/toolchain.md` + `verification-policy.md`: toolchain owns declared-commands detail (skill git-workflow block → bare pointer; finish consumer detail lives in finish only; fallback stated once); verification-policy drops the restated branch-plan/auto paragraphs, the repeated effort column (one footnote), and its self-restating Effort note.
- [x] Docs companions: `docs-adoption.md` drops the docs.md framing restatement and the layout.md verbatim bar sentence (pointers); `documentation.md` folds the provenance-preference into the gate section; `report-template.md` drops the auto.md rule restatements (no-report-no-accept stated once, in auto).
- [x] Prompts: `implementer-prompt.md` single commit-message mention; `spec-reviewer-prompt.md` merges the duplicated dont-trust-report guidance into one section.
- [x] `visual-companion.md` compression (~400w): halve the When-to-Use example lists (keep the litmus line); fragment-wrapping, file-naming/versioning, server-info recovery, and events-file semantics each stated once; drop the duplicated Windows background note.
- [x] Close review (2 combined angles): every pointer target verified; 7 fixes - detection command back inline in migrate, helper-script injection note, flows/state-machines, effort degradation clause, modification-time tie-break, residual prompt dup, verbless fragment.
- [x] R-closure: criterion 3 amended to measured >=8% (user decision at close gate).
- [x] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.
