task: T-050
type: feat
depends-on: T-049

# feat/code-size — code-size quality gate (R-022)

T-050 of `plans/R-022-conventions/`. A Tier-1 check enforcing file/function
line limits (file > 300, function > 50) with a documented per-file override
allowlist; shipped to adopters via `install-dev.sh` (copy + document CI
wiring). `depends-on: T-049` — both edit `install-dev.sh` / `settings.json`
/ `install-dev.test.sh`; sequence to avoid conflict.

Acceptance criteria: see `requirements.md` (hard-fail on oversize, pass
within, override allowlist, runs in run-all + pre-push; installer ships it;
test coverage).

- [x] Test-first `scripts/test/check-code-size.test.sh`: an oversized file (>300) fails, an oversized function (>50) fails, within-limits passes, an allowlisted path passes. (red)
- [ ] Implement `scripts/ci/check-code-size.sh`: count lines per tracked file (>300); heuristic function length (>50) for shell/known languages; read an override allowlist (`scripts/ci/code-size-allow.txt`); report + fail. (green)
- [ ] Wire into `scripts/ci/run-all.sh` (the `.githooks/pre-push` mirror inherits it).
- [ ] Seed `scripts/ci/code-size-allow.txt` with existing offenders (audited) so `main` stays green — branch-by-abstraction; each entry carries a reason.
- [ ] `install-dev.sh`: copy `check-code-size.sh` (+ allowlist seed) into the target `scripts/ci/`; document adopter CI wiring in the install output / README.
- [ ] `install-dev.test.sh`: assert the code-size check is copied into a target.
- [ ] `DESIGN.md`: add `check-code-size.sh` to the tree-map + the § Self-enforcement Tier-1 list.
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
