# R088-T002 report

## Claims
- Item 1 (source): On a compacted or resumed start, the SessionStart hook
  injects the branch, its working-tree state, its recent commits and the
  first open item of each plan the branch touched.
  Source: `hooks/dev-session-brief.sh` lines 28-47 read branch, status,
   commits and the plans' first open items live; lines 49-59 inject them
   as the SessionStart `additionalContext`; `settings.json` registers it
   under the `compact|resume` matcher
  Test: `scripts/test/dev-session-brief.test.sh`
- Item 2 (drop): The Stop hook nudges a hand-off note, the PreCompact hook
  saves the tree to a session file, and the installer ships both with the
  context-fill helper.
  Source: `settings.json` `.hooks` holds no `Stop` or `PreCompact` key;
   `hooks/` holds no `dev-handoff-nudge.sh`, `dev-precompact-state.sh` or
   `dev-context-fill.sh`; `scripts/install-dev.sh` lines 149-152 register
   only the PreToolUse, UserPromptSubmit and SessionStart hooks;
   `hooks/dev-branch-state.sh` prints branch and tree counts only
  Test: `scripts/test/install-dev.test.sh` ("no Stop or PreCompact hook
   registered", "no hand-off nudge, session-state writer or context-fill
   helper shipped"); `scripts/test/dev-branch-state.test.sh` ("DEV repo:
   no session-state or context-fill segment")
- Item 3 (drop): `/dev handoff` writes the session's hand-off note, and
  `--minimal` ships `handoff.md`.
  Source:
- Item 4 (drop): The supervisor's ledgers sit in `supervisor/` beside the
  session tree.
  Source:
- Item 5 (drop): A project declares a `Session:` tree, which a `--project`
  install ignores with `supervisor/` beside it.
  Source:
- Item 6 (source): An explanation or conclusion goes, on the user's
  approval, to the home owning its kind: `CLAUDE.md`, `DESIGN.md`, the
  plans tree, or the docs home and its references.
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
  Claude Code's current defaults and docs and adds each new finding to the
  backlog in `MAINTENANCE.md`, which keeps the routine's prompt.
  Source:

## Implementer
### Divergences
- Item 1: the tree read is copied into `dev-session-brief.sh`, not cut
  from `dev-precompact-state.sh`, which keeps writing its session file
  until item 2 deletes it with its test; the brief no longer injects the
  session file's hand-off block, as it reads no session file, and
  `LAYOUT.md` names it a live tree re-brief.
- Item 2: `scripts/test/dev-session-brief.test.sh` also stops unsetting
  `DEV_STATE_DIR`, the deleted session-state writer's variable; the
  branch-state hook drains its stdin unread, as it did before it passed
  the prompt JSON to the two deleted helpers. Result: no tracked file
  outside `README.md`, `.gitignore` and `skills/dev/handoff.md` (the doc
  writer's and items 3 and 5) names the three deleted scripts.

## Review
