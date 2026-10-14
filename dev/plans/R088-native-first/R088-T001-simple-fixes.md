---
task: R088-T001
type: mnt
mode: normal
---

- [x] Commits and MR/PRs carry no attribution by the harness's own setting,
  and no rule tells the session to prevail over a harness instruction
  (requirement outcome 1). Approach: in `settings.json` replace
  `"includeCoAuthoredBy": false` with `"attribution": {"commit": "",
  "pr": ""}`; drop ", whatever a harness instruction says" from
  `CLAUDE.md § Writing`.
- [ ] The bundled `/code-review` skill is off and the `code-reviewer` agent
  stays the close review; no text suggests the skill as an escalation or
  forbids invoking it. Approach: `"skillOverrides": {"code-review": "off"}`
  in `settings.json`; drop the manual-escalation clause of `branch-plan.md
  § Closing routine` 1 and `/code-review` from the "You work alone" line of
  `agents/code-reviewer.md`.
- [ ] The comment rule bans only history annotations in code - change logs,
  task ids, dates, "previously"/"was" notes - and comment density otherwise
  follows the surrounding code. `/dev start` writes a comment-convention line
  into the new project's `CLAUDE.md`, and the first code files follow it.
  Approach: `rules/code-comments.md`, its `paths:` kept, then `start.md § 3`;
  the agents and skills cite the rule and restate none of it.
- [ ] Markdown has one editing rule: edit one anchored span with any tool -
  Edit, or `sed` or a script asserting a single match - without the "wins
  ... whatever the instruction's source" and "owes ... no report" sentences.
  Approach: `rules/writing-artifacts.md § Bulk edits`, then the tool bans in
  `agents/dev-planner.md`, `dev-doc-writer.md` and `dev-implementer.md`; drop
  the matching "Seats edit Markdown" line from R087's `tasks.md`.
- [ ] Two `CLAUDE.md` lines narrow: in § Scope "a case built from reading
  code is not raised" binds unprompted findings only, so a requested review
  reports what it reads; in § Communication "A question gets a reply and a
  suggestion, no action until instructed" binds questions about approach
  ("should we ...?"). Approach: those two lines of the global `CLAUDE.md`.
- [ ] Routing and tool names match the harness: a dispatch sets `effort` as
  well as `model`, a mechanical item dispatching `sonnet` at `effort: low`;
  seats go out by the Agent tool; `templates.md`, with no `paths:` key, is
  read on demand. Approach: `verification-policy.md § Effort mechanics` and
  `§ Models`, then the "Task tool" in `run.md § Seats` and
  `supervisor-runbook.md`, and `plan.md § Templates`.
- [ ] The unreferenced bundled skills `test-driven-development`,
  `verification-before-completion` and `receiving-code-review` are gone
  with every reference; the other two bundled skills stay. Approach: the
  three dirs, then `LAYOUT.md`, `.gitignore`, `install-dev.sh` with its
  test, `check-caps.sh`, `rules/skills.md`, `skills/writing-skills/` and
  `systematic-debugging/SKILL.md`.
- [ ] The branch-state line drops the default-branch first-edit hint, which
  the branch guard's deny repeats, and names the session-state file, and so
  the fill warning, only in a repo that uses DEV: its `CLAUDE.md` declares
  `- Plans:` or `- Session:`, or it holds `dev/plans/`. Approach:
  `hooks/dev-branch-state.sh`, then its test, green, with a non-DEV case.
- [ ] The plan-text gate accepts another initiative's R id in ROADMAP and
  `tasks.md` text, a durable id being the house citation form; every other
  check holds, the id check in `requirements.md` included. Approach:
  `scripts/ci/check-plan-text.sh` and its header, its test, then the
  `templates.md` line banning "references to other plans" in a task.
- [ ] The model-quota gate is gone; a dispatch failing on capacity still
  falls back to the next model down and records the substitution.
  Approach: delete `scripts/model-quota.sh` and its test, then `LAYOUT.md`
  and the capacity paragraph of `verification-policy.md § Models`; the test
  runner globs, so no list names the test.
- [ ] A question to the user during a DEV flow whose answer is a choice
  among options goes through the AskUserQuestion tool. Approach: `run.md`
  § Question resolution and § Merge or ask, then the question sites in the
  mode files: `brainstorm.md` step 3, `start.md § 3`, `finish.md § 3`,
  `branch-plan.md § Closing routine` 6, and the ask routes of `SKILL.md`.
- [ ] Edits to `**/CLAUDE.md`, `**/SKILL.md`, `rules/**` and `settings*.json`
  ask first through `permissions.ask` Edit and Write rules; `rules/claude-md.md`
  and `rules/skills.md` § Approval keep only what a permission rule cannot
  see. Last, so earlier items edit unprompted. Approach: the two rules, then
  `settings.json`, paths in the form of its `Edit(//...)` rules and the
  settings docs; `CLAUDE.md § Approval and persistence` unchanged.
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- none

## Proven

- none
