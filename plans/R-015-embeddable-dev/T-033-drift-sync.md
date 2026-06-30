task: T-033
type: feat
depends-on: T-031

# feat/drift-sync — drift detection + re-vendor sync (R-015)

T-033 of `plans/R-015-embeddable-dev/requirements.md` (AC6, AC7). A
source-side drift check that reports when an embedded copy lags the
toolchain, and an `--update` mode on the vendor that re-vendors in place
without clobbering adopter content. Builds on T-031's stamp + re-run guard.

**Design decisions (approved):**
- **Drift check is source-side.** `scripts/dev-drift-check.sh <project>`
  reads `<project>/.claude/.dev-toolchain.json` `source` and compares it to
  this repo's current `git describe` — up-to-date / stale / unknown.
- **Update replaces the managed footprint by name** — the 8 vendored
  rules, `dev` + `dev-*` skills, the check script, the stamp — leaving
  adopter-added rules/skills/plans untouched. The adopter's `CLAUDE.md` is
  **not overwritten**; update re-emits it only if untouched, else reports
  "backbone template changed; merge manually."

All new code / script extension — no skill-edit gate.

- [x] `scripts/dev-drift-check.sh <project>` + test (TDD): reads the
  project's stamp `source`; reports `up-to-date` when it equals this repo's
  `git describe`, `stale` when it differs, `unknown` when the stamp is
  missing/unreadable. Test drives each via fixture stamps + a stubbed
  `git describe`.
- [x] Vendor `--update` mode + test: with `--update`, remove the
  vendor-managed footprint (8 rules by name, `dev` + `dev-*` skills, check
  script, stamp) and re-vendor; preserve the adopter `CLAUDE.md` (re-emit
  only if byte-identical to a fresh backbone, else leave it and report);
  a bare re-run without `--update` is still refused. Test: update succeeds
  with no double-prefix, an adopter-added file under `.claude/` survives,
  a hand-edited `CLAUDE.md` is preserved, bare re-run refused.
- [ ] Document drift-check + `--update` in `README.md` (doc-before-commit),
  then complete the branch: re-review across commits, cleanup, confirm
  `bash scripts/ci/run-all.sh` green, triage the findings file, mark the
  plan complete, commit.
