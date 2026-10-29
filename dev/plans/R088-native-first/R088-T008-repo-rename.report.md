# R088-T008 report

## Implementer

## Answers

- Item 3: the one worker host, `claude-worker`, is updated by the runner.
  Its `~/.claude` was still the framework checkout, not a clone, so it is
  migrated in place as the operator's machine was in R088-T006: a clone
  at `~/src/claude-dev` from `concentrator/claude-dev`, `~/.claude/.git`
  moved aside, `config-clone`, `CLAUDE.md` cut to its import lines, the
  three `autoMode` entries retargeted, the repository-only files moved to
  `~/.claude-repo-leftovers`.
- Item 3: the runner stops the host's runner sessions before the
  migration; the user restarts them.
- Item 3: the user checks the weekly audit routine's repository; it reads
  `concentrator/claude-dev`, the rename carried over.

## Review
