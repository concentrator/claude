# R-013 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` - format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-026 (R-013) [feat]: JS file-naming - add the file-naming
      convention to `rules/js.md` (kebab-case default; PascalCase for a
      file whose primary export is a class/component, matching the
      export; `*.config.js`/dotfiles exempt) + a copyable CI check (each
      `*.js`/`.mjs`/`.cjs`/`.jsx` filename kebab-or-PascalCase, exempt
      patterns ignored; PascalCase⇒class-export is review-level) +
      document the no-`MAINTENANCE.md` behavior. One coherent branch.
