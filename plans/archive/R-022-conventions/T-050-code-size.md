task: T-050
type: feat
depends-on: T-049

# feat/code-size - code-size quality gate (R-022)

T-050 of `plans/R-022-conventions/`. A Tier-1 check enforcing file/function
line limits (file > 300, function > 50) with a documented per-file override
allowlist; shipped to adopters via `install-dev.sh` (copy + document CI
wiring). `depends-on: T-049` - both edit `install-dev.sh` / `settings.json`
/ `install-dev.test.sh`; sequence to avoid conflict.

Acceptance criteria: see `requirements.md` (hard-fail on oversize, pass
within, override allowlist, runs in run-all + pre-push; installer ships it;
test coverage).

- [x] Test-first `scripts/test/check-code-size.test.sh`: an oversized file (>300) fails, an oversized function (>50) fails, within-limits passes, an allowlisted path passes. (red)
- [x] Implement `scripts/ci/check-code-size.sh`: count lines per tracked file (>300); heuristic function length (>50) for shell (reliable; js/other are file-size only, documented); read an override allowlist (`scripts/ci/code-size-allow.txt`); report + fail. (green)
- [x] Wire into `scripts/ci/run-all.sh` (the `.githooks/pre-push` mirror inherits it).
- [x] Seed `scripts/ci/code-size-allow.txt` with existing offenders (audited) so `main` stays green - branch-by-abstraction; each entry carries a reason.
- [x] `install-dev.sh`: copy `check-code-size.sh` + a template allowlist into the target `scripts/ci/`; document adopter CI wiring in the install output.
- [x] `install-dev.test.sh`: assert the code-size check is copied into a target (+ committability).
- [x] `DESIGN.md`: `check-code-size` + its allowlist named in the § Self-enforcement Tier-1 list (the tree-map `ci/` summary covers the script).
- [x] Close-review hardening, tests first: fixtures for the shell-function misses (trailing comment on opener, `function name() {`, `function name {`, indented close), a no-trailing-newline file at the 300/301 boundary, and an allowlist whose last line lacks a newline - red.
- [x] Harden `check-code-size.sh` - green: broaden the opener (accept `function` prefix, optional `()`, trailing content) + one-liner guard (`{ ... }` on the line) + close at the opener's indent + flag an unclosed opener at EOF (CRITICAL); count lines with `awk NR` (HIGH + LOW padding); read the allowlist with `|| [ -n "$p" ]` (MEDIUM); document the heredoc-brace residual.
- [x] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
