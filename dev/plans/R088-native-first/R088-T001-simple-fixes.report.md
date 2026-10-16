# R088-T001 report

## Implementer

- Item 1: `settings.json` already held the `attribution` block (landed by
  the session per `## Answers`); the seat dropped the harness-instruction
  clause from `CLAUDE.md § Writing`.
- Item 2: `settings.json` already held `skillOverrides` and
  `.claude/settings.json` no `Workflow(code-review)` allow (landed by the
  session per `## Answers`); the seat dropped the escalation clause and
  the `/code-review` ban.
- Item 3: `rules/code-comments.md` drops the no-comments ban and the
  library-API exception; density follows the project's declared
  convention, else the surrounding code, so the `comments:` line
  `start.md § 3` records binds the first code files. The two agents
  already cite the rule and restate none of it, so they stay unchanged.
- Item 4: `§ Bulk edits` becomes `§ Editing Markdown`; the three seats
  cite it in place of their tool bans, and the implementer's config
  paragraph keeps only the settings-surface bar.
- Item 5: the global `CLAUDE.md` § Scope line binds unprompted findings
  and says a requested review reports what it reads; the § Communication
  line binds questions about approach.
- Item 6: `verification-policy.md` has a dispatch override `model` and
  `effort` through the Agent tool's parameters, and the mechanical tier
  dispatch `sonnet` at `effort: low`; the `(judgment-heavy)` and default
  tiers set no effort, the item naming none. `run.md § Seats` and the
  runbook's loop diagram name the Agent tool; `plan.md § Templates` has
  `templates.md` read on demand. Harness source read: the Claude Code
  2.1.296 binary's Agent tool schema carries `effort` (`low` to `max`),
  and `Task` survives there only as a legacy alias of `Agent`.
- Item 7: the three skill dirs are gone, and `BUNDLED`, the `.gitignore`
  allowlist, `LAYOUT.md` and `check-caps.sh`'s reference class name only
  `systematic-debugging` and `dispatching-parallel-agents`, the two the
  companions invoke. The install test pins `skills/` to `dev` plus those
  two. `writing-skills` drops its "required background" paragraphs, the
  TDD mapping table carrying the cycle; `systematic-debugging` drops its
  pointer to the TDD skill and its "Related skills" list;
  `rules/skills.md` takes `dispatching-parallel-agents` as its naming
  example.
- Item 8: `dev-branch-state.sh` drops the hint with the default-branch
  resolution that fed only it, and asks the state and fill helpers only
  where the root the state helper uses holds `dev/plans/` or a
  `CLAUDE.md` or `.claude/CLAUDE.md` declaring `- Plans:` or
  `- Session:`. The test replaces the default-branch cases with one
  hint-free `main` line, adds a non-DEV repo whose line carries neither
  segment above the fill threshold, and one case per DEV signal; it
  failed against the old hook on those two lines.
- Item 9: `check-plan-text.sh` runs the id check in `requirements.md`
  only, and the ROADMAP scan no longer derives an entry's own id, which
  fed only that check. The test moves the two foreign-id cases and the
  `R-NNN` own-id case to `requirements.md` and adds a passing foreign id
  in `tasks.md` and in ROADMAP, both failing against the old gate.
  `templates.md` drops the ban and has another initiative or task cited
  by its id.
- Item 10: the script and its test are gone, with the `LAYOUT.md` row;
  `verification-policy.md`'s capacity fallback keeps the next-model-down
  substitution and its record, dropping the pre-dispatch gate read. No
  other live file named the script.
- Item 11: `run.md` has a relayed seat question that is a choice go
  through AskUserQuestion with the seat's report supplying the options,
  and every user decision of § Merge or ask asked through it. The named
  sites follow: brainstorm's multiple-choice clarifying questions, the
  release-routine and publishing questions of `start.md § 3`, the merge
  or discard decision and the keep-the-plan question of `finish.md § 3`,
  the triage prompt of § Closing routine 6, and one line in `SKILL.md`
  covering every ask of its routing tables. The typed `discard`
  confirmation in `finish.md § 3` stays typed: it confirms a decision
  already taken rather than choosing among options.
- Item 12: `rules/claude-md.md` and `rules/skills.md` § Approval point
  at the `permissions.ask` rules and keep only the changes those rules
  cannot see: a `CLAUDE.local.md`, which the ask list leaves out, and an
  edit through the shell, outside the Edit and Write tools those rules
  name.
  `MAINTENANCE.md § Repair` names settings among the governed files,
  `SKILL.md` in place of skills, and the shell-edit case; its
  "Elsewhere:" becomes "Repairs:", as a settings repair now asks too. The
  `settings.json` ask rules are the session's, after this commit.

### Divergences
- Review 1: `companions/seat-permissions.md § Prompt classes` also told
  a seat and the runner to retry a denied call identically, so it drops
  the retry with the two files the entry names; the rewrite of a call
  the classifier could not evaluate stays, its runbook entry being a
  separate failure mode.
- Item 4: the section is renamed `§ Editing Markdown`, as the rule no
  longer covers bulk edits only; `companions/seat-permissions.md`'s
  paragraph on the seats' shell tools changes to match. The classifier
  denied the seat that edit, and the session made it on the user's
  approval.
- Review 2: `agents/code-reviewer.md § Evidence` now says that in a
  requested review what the reviewer reads in the code is evidence; only a
  finding resting on a constructed input is dropped or listed as
  hypothetical.

### Findings
- [x] Item 3: `/dev migrate` adds no `comments:` line to an existing
  project's conventions. -> backlog
  Evidence: observed `skills/dev/migrate.md § 4` lists the conventions keys without it
- [x] Item 9: the gate's `#NNN` check rejects an MR/PR number the
  durable-id rule allows. -> backlog
  Evidence: observed `check-plan-text.sh` still fails `#545` in `tasks.md`
- [x] Item 11: choice prompts outside the item's sites still ask in
  plain text. -> backlog
  Evidence: observed `brainstorm.md` step 4, `start.md § 1` and `§ 4`, `finish.md § 4`
- [x] Item 6: the dispatching-parallel-agents skill shows `Task(...)`
  examples. -> backlog
  Evidence: observed `skills/dispatching-parallel-agents/SKILL.md` lines 71-73
- [x] Item 12: `CLAUDE.local.md` has no ask rule. -> backlog
  Evidence: observed the `permissions.ask` list in `settings.json`

## Answers
- Item 1: the session writes the `settings.json` change, landed before
  the item; the seat drops the `CLAUDE.md` clause.
- Item 2: the session writes `skillOverrides` and removes the
  `Workflow(code-review)` allow from `.claude/settings.json`, landed
  before the item; the seat makes the text edits.
- Item 3: `start.md` asks the user for the comment convention through
  AskUserQuestion, "match surrounding code" offered as the default.
- Item 4: the `sed -i` ban in `agents/dev-implementer.md`'s config
  paragraph aligns with the one editing rule too.
- Item 8: the DEV-repo signal stands as the item states it.
- Item 12: the seat edits the rules and `MAINTENANCE.md`'s "never
  auto-edited" line; the session writes the `settings.json` ask rules
  after the seat's commit.
- Close review: both fixes approved; the session anchors the ask rules.
- Close triage: the five findings go to R088's backlog; R085 is dropped,
  superseded by this task, its two README lines moving to R088.

## Review
- [x] Item 1: a classifier denial ends the call: no rule tells a seat or
  the runner to retry a denied call identically; the seat reports
  BLOCKED with the classifier's text. Approach: `agents/dev-implementer.md
  § A denied call` and `supervisor-runbook.md`'s denial entry. (Important)
  - agents/dev-implementer.md:122
  Evidence: observed auto mode flagged item 1's identical retry of a denied CLAUDE.md edit as Auto-Mode Bypass
- [x] Close review: the reviewer's evidence rule agrees with `CLAUDE.md
  § Scope`: a finding read in the code is evidence, and one resting on
  an input the reviewer constructed is listed once under "not checked",
  marked hypothetical. (Critical) - agents/code-reviewer.md:83
  Evidence: contract CLAUDE.md § Scope says a requested review reports what it reads
- [x] Close review: the ask rules cover every `CLAUDE.md`, `SKILL.md`,
  `.claude/rules/` and `.claude/settings*.json` path, anchored at the
  filesystem root; the session made the change. (Critical) - settings.json
  Evidence: contract the permissions docs resolve an unanchored `**/` pattern from the current directory only
