---
paths:
  - "**/*.js"
  - "**/*.mjs"
  - "**/*.cjs"
  - "**/*.jsx"
---

# JavaScript style

- **Quotes**: single quotes for strings.
- **Indentation**: 2 spaces.

## File names

- **kebab-case** by default: `hit-attack-types.js`.
- **PascalCase** when the file's primary export is a class or component,
  matching the export name: `ClientScope.js`.
- Tool-/framework-mandated names are exempt (`*.config.js`, dotfiles).
- The "PascalCase ⇒ the export is a matching class/component"
  correspondence is review-level (Tier-2 Compliance), not mechanically
  checked.
- Go-forward: applies to new and renamed files; existing files are not
  renamed wholesale.
