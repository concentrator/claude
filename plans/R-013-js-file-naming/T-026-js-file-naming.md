task: T-026
type: feat

# feat/js-file-naming — file-naming convention + copyable CI check (R-013)

T-026 of `plans/R-013-js-file-naming/requirements.md`. One coherent
branch: extend `rules/js.md` with the file-naming convention, a copyable
shell CI-check example, and the no-MAINTENANCE.md note. Illustrative —
not wired into `run-all.sh` (~no JS here). Not architecture-changing.

- [x] Add the file-naming convention to `rules/js.md`: kebab-case
      default (`hit-attack-types.js`); PascalCase when the file's primary
      export is a class/component, matching the export (`ClientScope.js`);
      dotfiles exempt. State that the PascalCase ⇒ matching-class-export
      correspondence is review-level (Tier-2 Compliance), not mechanical.
      Go-forward (no renames).
- [x] Add the copyable CI-check example to `rules/js.md`: a portable bash
      glob over `git ls-files '*.js' '*.mjs' '*.cjs' '*.jsx'` that
      validates the **first dot-delimited segment** of each basename is
      kebab-case or PascalCase — so `next.config.js`→`next`,
      `foo.test.js`→`foo`, `ClientScope.js`→`ClientScope` all pass with
      no exemption list; dotfiles skipped; rejects camelCase/snake_case/
      mixed. Styled after `scripts/ci/check-stray.sh`. Mark illustrative.
- [x] Add the no-`MAINTENANCE.md` note to `rules/js.md`: the convention
      is a rule (always applies when editing JS); CI enforcement is wired
      where the project has CI / `MAINTENANCE.md`, seeded by the adopter
      flow (`migrating-to-dev` / `starting-a-project`); else advisory.
- [x] Complete the branch: re-review, `check-caps` + `run-all` green,
      mark the plan complete; stamp follows per the ledger protocol; hand
      off to `finishing-a-branch` (feat → user review + merge).
