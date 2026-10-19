# R088-T002 report

## Claims
- Item 1 (source): On a compacted or resumed start, the SessionStart hook
  injects the branch, its working-tree state, its recent commits and the
  first open item of each plan the branch touched.
  Source:
- Item 2 (drop): The Stop hook nudges a hand-off note, the PreCompact hook
  saves the tree to a session file, and the installer ships both with the
  context-fill helper.
  Source:
- Item 3 (drop): `/dev handoff` writes the session's hand-off note, and
  `--minimal` ships `handoff.md`.
  Source:
- Item 4 (drop): The supervisor's ledgers sit in `supervisor/` beside the
  session tree.
  Source:
- Item 5 (drop): A project declares a `Session:` tree, which a `--project`
  install ignores with `supervisor/` beside it.
  Source:
- Item 6 (source): A project's settled questions live one per line in
  `<plans>/DECISIONS.md`, which its `CLAUDE.md` imports.
  Source:
- Item 8 (source): A project declares its CI wait command in its
  `§ Agent toolchain`.
  Source:
- Item 9 (probe): The GitHub CI wait, `gh pr checks <n> --watch`, exits 0
  when every check passes and non-zero when one fails.
  Call:
  Output:
  Environment:
- Item 10 (source): A `review:` line in `CLAUDE.md § Conventions` sets the
  code reviewer's model and effort.
  Source:
- Item 12 (source): A weekly cloud routine audits the repository against
  Claude Code's current defaults and docs, its prompt kept in
  `MAINTENANCE.md § This environment`.
  Source:

## Implementer

## Review
