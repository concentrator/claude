task: T-055
type: feat
depends-on: T-054

# feat/em-dash-check - Tier-1 em-dash gate (R-026)

T-055 of `plans/R-026-writing-conventions/`. A Tier-1 check that hard-fails on
an em dash in any tracked file, shipped to adopters via `install-dev.sh`.
`depends-on: T-054` - the check lands only once the sweep has cleared the
tree, so `main` is never red. Fixtures generate the em-dash character at
runtime (no literal in the tracked test source), so the check never flags
itself.

Acceptance criteria: see `requirements.md` (Tier-1 check hard-fails on an
introduced em dash and passes on the clean tree; runs in `run-all.sh` +
pre-push; installer ships it + test coverage).

- [x] Test-first `scripts/test/check-no-em-dash.test.sh`: a planted em dash (built at runtime) in a `.md` fixture and in a `.sh` fixture both fail; a clean tree passes; a binary file is skipped. (red)
- [x] Implement `scripts/ci/check-no-em-dash.sh`: scan tracked text files (`git grep -I` to skip binary) for the em-dash character; report file:line + fail. (green)
- [x] Wire into `scripts/ci/run-all.sh` (the `.githooks/pre-push` mirror inherits it).
- [ ] `install-dev.sh`: ship `check-no-em-dash.sh` into the target `scripts/ci/`; `install-dev.test.sh`: assert it is copied.
- [ ] `DESIGN.md`: add `check-no-em-dash` to the tree-map + the § Self-enforcement Tier-1 list.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
