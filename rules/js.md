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

A project with CI can enforce the casing - copy this into
`scripts/ci/check-js-naming.sh` (illustrative; not wired into this repo's
gate, which has ~no JS). It validates the name segment before the first
dot, so `next.config.js`→`next`, `foo.test.js`→`foo`, and
`ClientScope.js`→`ClientScope` all pass with no exemption list:

```bash
#!/usr/bin/env bash
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
fail=0
while IFS= read -r f; do
  base=$(basename "$f")
  case "$base" in .*) continue ;; esac   # dotfiles exempt
  stem=${base%%.*}                        # name before the first dot
  printf '%s' "$stem" | grep -qE '^([a-z0-9]+(-[a-z0-9]+)*|[A-Z][A-Za-z0-9]*)$' \
    || { echo "NAME: $f - '$stem' is not kebab-case or PascalCase"; fail=1; }
done < <(git ls-files '*.js' '*.mjs' '*.cjs' '*.jsx')
(( fail == 0 )) && echo "check-js-naming: OK"
exit $fail
```

Without CI or `MAINTENANCE.md` the convention still holds - it's a rule
that applies whenever JS is edited. The check above is wired where the
project has CI; `/dev migrate` / `/dev start` seed it during
adoption. Absent that, the convention is advisory.
