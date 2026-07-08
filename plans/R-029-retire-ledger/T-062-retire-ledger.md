task: T-062
type: refactor
architecture-changing: true

# refactor/retire-ledger - remove the Tier-2 ledger, keep the review (R-029)

T-062 of `plans/R-029-retire-ledger/`. Delete the `check-ledger` gate, the
`maintenance.d/` stamp store, and the per-PR stamp practice; keep the
five-concern Tier-2 review as a mandatory branch-close step. Settled open
questions: the review is a separate, named checklist step in the closing
routine (not folded into the code-review); `ci.yml` fetch-depth drops to 1.

Acceptance criteria: see `requirements.md` (gate + store + stamp gone,
Tier-1 green with no stamp; Tier-2 review named as a close step in
`MAINTENANCE.md` + closing routine; DESIGN + tree-map updated; R-028 reduced
to T-060).

- [x] Remove the gate: drop `ledger` from the `scripts/ci/run-all.sh` loop and delete `scripts/ci/check-ledger.sh`, `scripts/test/check-ledger.test.sh`, and `maintenance.d/`. After this the Tier-1 gate is green with no stamp.
- [x] `MAINTENANCE.md`: remove the Ledger section; reframe the Tier-2 AI review as a mandatory branch-close review (no stamp, no gate); fix the intro that names `maintenance.d/` / `check-ledger`.
- [x] Relocate the review: add the explicit Tier-2 five-concern checklist step to `branch-plan.md § Closing routine`, align `finish.md`, and remove any stamp-at-delivery wording. Grep `skills/` + `rules/` for stray ledger/stamp references and fix.
- [x] `DESIGN.md` (architecture): rework the self-enforcement section (Tier-2 no longer a committed stamp/gate), the tree-map (`maintenance.d/` node removed), and the infrastructure-group line; keep it net-neutral against the ~1000-word cap.
- [x] `.github/workflows/ci.yml`: reduce `fetch-depth` to 1 (only `check-ledger` needed history) and update the comment.
- [x] Amend R-028: drop T-061 from `plans/R-028-enforcement-hygiene/tasks.md`, trim `requirements.md` (remove the ledger-hygiene goal, its acceptance criterion, and the motivation half), and update the R-028 `ROADMAP.md` entry to T-060 only.
- [x] Verify `install-dev.sh` + `install-dev.test.sh` are unaffected (the installer ships CI minus the ledger). Complete the branch: re-review docs, cleanup, mark plan complete, commit.
