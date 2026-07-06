---
approved: 2026-06-23
kind: feat
status: done 2026-06-23
---

# R-013: JS file-naming convention + CI validation

## Motivation

`rules/js.md` defines JS style (quotes, indent) but no file-naming
convention, so JS filenames drift. Establish one and make it
CI-validatable - without depending on a repo having `MAINTENANCE.md`.

## Goals

- `rules/js.md` states a file-naming convention: kebab-case by default
  (`hit-attack-types.js`); PascalCase when the file's primary export is a
  class/component, matching the export (`ClientScope.js`); tool-/
  framework-mandated names exempt (`*.config.js`, dotfiles).
- A copyable CI-validation example lives in `rules/js.md` (travels with
  the rule): verifies each `*.js`/`.mjs`/`.cjs`/`.jsx` filename is
  kebab-case OR PascalCase, ignoring exempt patterns. The "PascalCase ⇒
  matching class export" correspondence is review-level, not mechanical.
- Document the no-`MAINTENANCE.md` behavior: the convention is a rule
  (always applies when editing JS); CI enforcement is added where the
  project has CI / `MAINTENANCE.md` - seeded by `migrating-to-dev` /
  `starting-a-project`. Without it, the convention holds advisorily.

## Non-goals

- AST-level verification that a PascalCase file exports a matching class
  (review-level only).
- Naming conventions for non-JS files.
- Renaming existing files in any repo (go-forward; applies to new/changed
  files).
- Building per-adopter CI infra (the example is copyable; adopters wire
  it into their own CI).

## User experience

- Editing JS, files are named kebab-case - or PascalCase for a
  class/component file matching its export; tool-mandated names left
  as-is.
- A project with CI copies the `rules/js.md` example to validate
  filenames (kebab-or-PascalCase, exempt patterns ignored); a violation
  fails CI.
- A repo without `MAINTENANCE.md`: the convention still applies (rule);
  the check is added when CI / `MAINTENANCE.md` is set up (adopter flow).

## Acceptance criteria

- [x] `rules/js.md` states the file-naming convention: kebab-case
      default; PascalCase for a file whose primary export is a
      class/component (matching the export); `*.config.js` / dotfiles
      exempt.
- [x] `rules/js.md` carries a copyable CI-validation example: verifies
      each matched filename is kebab-case OR PascalCase, ignoring exempt
      patterns; rejects camelCase / snake_case / mixed.
- [x] The example notes that the PascalCase ⇒ class-export correspondence
      is review-level, not mechanical.
- [x] The no-`MAINTENANCE.md` behavior is documented: the convention
      always applies; CI enforcement is added where CI / `MAINTENANCE.md`
      exists (seeded by the adopter flow).
- [x] No existing files renamed (go-forward convention).
- [x] Domain-neutral; rules within any caps.

## Constraints

- The CI example is a simple, portable check (glob/shell), not an AST
  parser.
- Mostly adopter-facing; `~/.claude` has ~no JS, so the check is
  illustrative here.
- `rules/js.md` is path-scoped (`**/*.js` etc.) - loads when editing JS.

## Open questions

- CI example as shell (filename glob) or a tiny node script? (Lean shell
  - portable, matches the `scripts/ci/` style.)

## References

- `rules/js.md` (the rule extended).
- The common "filename matches its primary export" convention (e.g.
  Airbnb JS style guide) - the established basis.
- `MAINTENANCE.md § Tier-2 AI review` (where a project wires the check +
  the review-level export-correspondence check).
- R-009 adopter flow (`migrating-to-dev` / `starting-a-project` seed
  enforcement).

## Closure verification (2026-06-23)

One-line evidence per criterion (T-026 merged):

1. `js.md § File names`: kebab-case default; PascalCase for a
   class/component file matching its export; `*.config.js`/dotfiles
   exempt. [T-026]
2. `js.md` copyable shell check validates the first dot-delimited segment
   as kebab-or-PascalCase; rejects camelCase/snake_case/mixed (ran
   against the repo's JS - passes). [T-026]
3. The example states the PascalCase ⇒ class-export correspondence is
   review-level, not mechanical. [T-026]
4. `js.md` documents the no-`MAINTENANCE.md` behavior (convention always
   applies; enforcement seeded by the adopter flow). [T-026]
5. Go-forward stated (no wholesale renames). [T-026]
6. Domain-neutral; `check-caps` green. [T-026]
