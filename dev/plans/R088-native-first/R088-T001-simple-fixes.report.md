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

## Review
- [x] Item 1: a classifier denial ends the call: no rule tells a seat or
  the runner to retry a denied call identically; the seat reports
  BLOCKED with the classifier's text. Approach: `agents/dev-implementer.md
  § A denied call` and `supervisor-runbook.md`'s denial entry. (Important)
  - agents/dev-implementer.md:122
  Evidence: observed auto mode flagged item 1's identical retry of a denied CLAUDE.md edit as Auto-Mode Bypass
