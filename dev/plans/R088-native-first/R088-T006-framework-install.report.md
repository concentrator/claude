# R088-T006 report

## Claims
- Item 1 (source): An install records each file it copies in a manifest in
  the target, and leaves in place, listing it, each target file that differs
  from the shipped one and that the manifest does not record as copied
  unchanged.
  Source:
- Item 2 (source): An install writes `settings.json` only to add a missing
  toolset hook entry or to drop a retired one.
  Source:
- Item 3 (source): A full install ships the seat definitions under `agents/`
  and the rules `code-comments.md` and `claude-md.md`.
  Source:
- Item 3 (drop): `agents/` is this repository's own, `install-dev.sh` copying
  none of it.
  Source:
- Item 5 (source): An install ships `dev-instructions.md`, the framework's
  global instructions, and appends a line importing it to the target's
  `CLAUDE.md`.
  Source:
- Item 6 (drop): The repository is cloned as `~/.claude`, with no install step
  of its own, its `settings.json` the machine's global Claude Code config.
  Source:

## Implementer

## Review
