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
  Source: `skills/dev/` holds no `handoff.md`; `skills/dev/SKILL.md`
   § Surface lists no `/dev handoff`; `scripts/install-dev.sh` line 65
   `MINIMAL_DEV` names no `handoff.md`
  Test: `scripts/test/install-dev-minimal.test.sh` ("minimal ships only
   the delivery skill files")
- Item 4 (drop): The supervisor's ledgers sit in `supervisor/` beside the
  session tree.
  Source: `skills/dev/run.md` holds no § Ledger, its § Resolve (lines
   56-69) opens no file, and § Monitor (lines 282-286) re-derives the
   scope's state from plans, task reports, git and MR/PR state;
   `skills/dev/companions/declarations.md § Declared paths` names no
   ledger directory; `skills/dev/companions/auto-permissions.template.json`
   holds no `mkdir`, `date` or `printf` rule
- Item 5 (drop): A project declares a `Session:` tree, which a `--project`
  install ignores with `supervisor/` beside it.
  Source: `skills/dev/companions/declarations.md § Declared paths`
   declares `Docs:`, `Plans:` and `Layout:` only and reads a `Session:`
   line as nothing; `scripts/install-dev.sh` step 6 (lines 204-227)
   writes only the allowlist lines and step 8 seeds no `Session:` row;
   `scripts/worker-workspace.sh` `project_clone` (line 74 on) writes no
   `.git/info/exclude` line; `.gitignore` holds no `/dev/session/` or
   `/dev/supervisor/` line
  Test: `scripts/test/install-dev.test.sh` ("no session or supervisor
   ignore line written", "a declared Session: tree gets no ignore
   line"); `scripts/test/install-dev-gitignore.test.sh` ("the session
   tree .claude/CLAUDE.md declares gets no ignore line");
   `scripts/test/worker-workspace.test.sh` ("project-clone excludes no
   session tree declared in .claude/")
- Item 6 (source): An explanation or conclusion goes, on the user's
  approval, to the home owning its kind: `CLAUDE.md`, `DESIGN.md`, the
  plans tree, or the docs home and its references.
  Source: `rules/writing-artifacts.md § One home per finding` lines
   31-35 route an explanation or conclusion, on the user's approval, to
   `CLAUDE.md`, `DESIGN.md`, `<plans>`, or `<docs>` and
   `<docs>/references/`; `CLAUDE.md § Approval and persistence` line 58
   cites it
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
- Item 3: the compaction instructions take the `## Compact instructions`
  heading the Claude Code 2.1.303 compaction prompt gives as its example
  of summarization instructions in the included context, read from the
  installed binary's strings, the docs not being readable from this seat.
  Citations in files a later item rewrites lose only the `handoff.md`
  cite, the rest left to that item: the ledger's (`run.md § Ledger`,
  `branch-plan.md § Session boundary`, `seat-permissions.md`) to item 4,
  the `Session:` tree's (`declarations.md`, `plan.md`, `MAINTENANCE.md`
  and its seeded copy, `worker-workspace.sh`, `.gitignore`) to item 5.
  `run.md § Monitor` drops its hand-off sentence outright. Result: no
  tracked file outside `README.md` (the doc writer's) and `DESIGN.md`
  (item 13) cites `handoff.md` or `/dev handoff`.
- Item 4: the re-derivation lands in `run.md § Monitor`, the section on
  the runner's context, which `branch-plan.md § Session boundary` and
  § Task report now cite in place of § Ledger; `agents/dev-implementer.md`
  cites `branch-plan.md § Task report` for keeping dispatch and status
  out of the report. With the ledger gone, `Bash(mkdir:*)`,
  `Bash(date:*)` and `Bash(printf:*)` had no step left to trace to
  (`seat-permissions.md § Bash prefix set`), so their row and template
  entries go and `echo` stands alone as the write-capable verb. The
  ledger mentions in `scripts/worker-workspace.sh`, its test and
  `.gitignore` sit beside their `supervisor/` lines, left to item 5.
  Result: no tracked file outside the plans tree, those three and
  `README.md` (the doc writer's) cites `run.md § Ledger` or the
  runner's ledger.
- Item 5: `root-migration.md § 1` and `untracked-claude.md § Detection`
  also cited `<session>`, so they drop it beside the listed files.
  `MAINTENANCE.md`'s seeded copy keeps its `## Session and planning
  hygiene` heading, the installer's seeding marker, so a project seeded
  earlier is not seeded twice. `install-dev-gitignore.test.sh` drops its
  slash-less dedupe case, the dedupe being gone. With the `.gitignore`
  lines gone, this checkout's local `dev/session/` and `dev/supervisor/`
  files show as untracked; left for item 14's cleanup. Result: no
  tracked file outside the plans tree and `README.md` (the doc
  writer's) names the `Session:` tree, `<session>` or a `supervisor/`
  directory; `scripts/test/dev-branch-state.test.sh` keeps its
  `Session:` fixture as a project still declaring it.
- Item 6: the rule names the plans tree and the docs home by their
  placeholders, `<plans>` and `<docs>`, as `declarations.md § Declared
  paths` asks of a rule. The `CLAUDE.md` bullet drops its "in DEV"
  scope, the cited section applying to every Markdown file in both
  modes. Result: the routing lives in one section, which `CLAUDE.md`
  cites rather than restates.

## Answers

- Item 6: keep the `CLAUDE.md` bullet without "in DEV"; routing to the
  owning home binds in both modes.

## Review
