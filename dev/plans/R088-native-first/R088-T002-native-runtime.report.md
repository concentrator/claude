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
   `dev-context-fill.sh`; `scripts/install-dev.sh` lines 151-154 register
   only the PreToolUse, UserPromptSubmit and SessionStart hooks;
   `hooks/dev-branch-state.sh` prints branch and tree counts only
  Test: `scripts/test/install-dev.test.sh` ("no Stop or PreCompact hook
   registered", "no hand-off nudge, session-state writer or context-fill
   helper shipped"); `scripts/test/dev-branch-state.test.sh` ("DEV repo:
   no session-state or context-fill segment")
- Item 3 (drop): `/dev handoff` writes the session's hand-off note, and
  `--minimal` ships `handoff.md`.
  Source: `skills/dev/` holds no `handoff.md`; `skills/dev/SKILL.md`
   § Surface lists no `/dev handoff`; `scripts/install-dev.sh` line 67
   `MINIMAL_DEV` names no `handoff.md`
  Test: `scripts/test/install-dev-minimal.test.sh` ("minimal ships only
   the delivery skill files")
- Item 4 (drop): The supervisor's ledgers sit in `supervisor/` beside the
  session tree.
  Source: `skills/dev/run.md` holds no § Ledger, its § Resolve (lines
   56-69) opens no file, and § Monitor (lines 291-295) re-derives the
   scope's state from plans, task reports, git and MR/PR state;
   `skills/dev/companions/declarations.md § Declared paths` names no
   ledger directory; `skills/dev/companions/auto-permissions.template.json`
   holds no `mkdir`, `date` or `printf` rule
- Item 5 (drop): A project declares a `Session:` tree, which a `--project`
  install ignores with `supervisor/` beside it.
  Source: `skills/dev/companions/declarations.md § Declared paths`
   declares `Docs:`, `Plans:` and `Layout:` only and reads a `Session:`
   line as nothing; `scripts/install-dev.sh` step 6 (lines 225-248)
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
   `<docs>/references/`; `CLAUDE.md § Approval and persistence` line 61
   cites it
- Item 8 (source): A project declares its CI wait command in its
  `§ Agent toolchain`.
  Source: `skills/dev/companions/declarations.md § Declared commands`
   lines 17-21 name the CI wait among the declared commands, on a `CI
   wait:` line; `skills/dev/companions/toolchain.md § CI wait` gives its
   forms, `gh pr checks <n> --watch` and `glab ci status --branch
   <branch> --wait`; `scripts/preflight-permissions.sh` `toolchain_rules`
   (lines 157-168) reads every command span of the section;
   `.claude/CLAUDE.md` line 10 declares this repository's CI wait
  Test: `scripts/test/preflight-permissions.test.sh` ("the CI wait prefix
   is declared"); `scripts/test/preflight-permissions-toolchain.test.sh`
   ("the CI wait line is read with the other declared commands")
- Item 9 (probe): The GitHub CI wait, `gh pr checks <n> --watch`, exits 0
  when every check passes and non-zero when one fails.
  Call: `gh pr checks 600 --watch; echo "exit=$?"` (every check passed);
   `gh pr checks 14035 -R cli/cli --watch; echo "exit=$?"` (one check
   failed); on finished checks `--watch` prints the table twice
  Output:
   tier1	pass	1m49s	https://github.com/concentrator/claude/actions/runs/39136505040/job/117701975682
   tier1	pass	1m49s	https://github.com/concentrator/claude/actions/runs/39136505040/job/117701975682
   exit=0
   lint	fail	1m11s	https://github.com/cli/cli/actions/runs/33321337572/job/99283726990
   (ten passing rows, then all eleven rows a second time)
   exit=1
  Environment: gh 2.97.0 on macOS (Darwin 25.5.0), 2026-10-19T09:39Z;
   concentrator/claude PR 600 and cli/cli PR 14035, both read only,
   their checks already finished
- Item 10 (source): A `review:` line in `CLAUDE.md § Conventions` sets the
  code reviewer's model and effort.
  Source: `skills/dev/companions/verification-policy.md § Models`
   lines 133-137 read a `review: <model> <effort>` line in `CLAUDE.md
   § Conventions`, which the runner sets on every `code-reviewer`
   dispatch, the definition's pins holding without it; `run.md § Close`
   1 (line 155) and `§ Batch close` 1 (line 197) dispatch the reviewer
   at that cost; `migrate.md § 4` line 77 lists the `review:` line among
   the conventions
- Item 12 (source): A weekly cloud routine audits the repository against
  Claude Code's current defaults and docs and adds each new finding to the
  backlog in `MAINTENANCE.md`, which keeps the routine's prompt.
  Source: `MAINTENANCE.md § Weekly audit` lines 138-167 keep the
   routine's prompt, which audits the repository against Claude Code's
   current defaults and docs (steps 1-3), skips a finding `§ Backlog`
   lists or a `rules/writing-artifacts.md § One home per finding` home
   settles (step 4), opens no PR when nothing is new (step 5) and
   otherwise opens a plan PR appending one line per finding (step 6);
   `§ Backlog` (line 169 on) gives the line's form

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
- Item 7: the three files cite `rules/writing-artifacts.md § One home
  per finding` for the homes rather than list them. A question a home
  settles still halts the item, so `run.md § Question resolution` has
  the runner write the settling home's citation under `## Answers`, the
  one channel to the next implementer. Result: the session, the runner
  and the code reviewer each check the item 6 homes before asking or
  raising a finding.
- Item 8: `scripts/preflight-permissions.sh` is unchanged: its
  `toolchain_rules` already reads every command span of `§ Agent
  toolchain`, so the `CI wait:` line needs no reader of its own, and
  only its test grows. The test stood at the code-size gate's 300
  lines, so its cases on reading the section - from either instruction
  file, the GitLab CI wait among them - move to
  `scripts/test/preflight-permissions-toolchain.test.sh`, which
  `install-dev.sh` ships beside it, `install-dev.test.sh` asserting
  both. The GitLab form is `glab ci status --branch
  <branch> --wait`, `--wait` being the flag of glab 1.112.0's help that
  returns when the pipeline finishes without a prompt; `glab ci status`
  takes a branch rather than an MR, so the form names the source
  branch. Its exit status on a failed pipeline is unprobed, item 9's
  probe covering the GitHub form alone. The template carries
  `Bash(gh pr checks:*)` and `Bash(glab ci status:*)` beside the view
  allows, as it does for the state check. `start.md § 4` declares the
  wait where CI is wired. Result: a project's `CI wait:` line resolves
  to a Bash prefix in the pre-flight report, which the template's rule
  covers on either host.
- Item 9: no tracked PR of this repository has a failed check at its
  head, so the failing case reads a public `cli/cli` PR, read only.
  `git-workflow.md § Merge order` drops the poll's first-read sentence
  without a successor: the probes show the GitHub wait exits at once
  on finished checks, the GitLab form being unprobed. The runbook's
  GitLab failure mode keeps its pipelines-endpoint
  read for the head-sha match only, the wait's exit carrying the
  result. Result: `finish.md § 3`, `run.md § Boundary verification` 4
  and the runbook take CI's result from one background wait, and no
  rule polls the state check.
- Review 1: `gh pr view 600 --json
  state,mergedAt,statusCheckRollup,headRefOid` returns the head sha the
  form without `headRefOid` lacks, read only. `toolchain.md § State
  check` names `headRefOid` as the sha Boundary verification 4 matches;
  the GitLab form is unchanged, its head-sha field unprobed, no GitLab
  remote being at hand. Result: the GitHub state check returns state,
  merged-at, checks and the head sha in one call.
- Review 2: the re-run lands in `git-workflow.md § Merge order` alone,
  which `finish.md § 3`, `run.md § Boundary verification` 4 and the
  runbook cite for the wait. `sleep` is reached by no rule of
  `seat-permissions.md § Bash prefix set` or
  `auto-permissions.template.json`; no rule is added, a template entry
  being one the pre-flight then requires of every project. Result: a
  `no checks reported` exit re-runs the wait after 30 seconds, at most
  3 times, then goes to the user.
- Item 10: the line's form is `review: <model> <effort>`, both values
  the Agent tool's, as `verification-policy.md § Effort mechanics`
  names them. `run.md § Batch
  close` 1 drops its "most capable" model for the review's cost, so
  without a `review:` line the batch review runs on the definition's
  pins as the close review does; `report-template.md`'s batch review
  heading drops "most capable model" with it. Result: the project's
  `review:` line, or else `agents/code-reviewer.md`'s pins, sets the
  model and effort of every code review.
- Item 11: dropping `release.md` steps 3 and 4 renumbers the procedure,
  so the step citations in `documentation.md § Verification gate`,
  `seat-permissions.md` and `toolchain.md` follow it. `release.md § Rules`
  replaces its block-on-review rule with one stating the release runs no
  code review, citing the two closes that review each change.
  `REQUIREMENTS.md`'s batch close still reviews the full batch diff,
  which the reviewer reads for cross-branch concerns, so it is
  unchanged. Result: a branch's close reviews it, a folded branch's one
  review is the batch close's, and the release reviews nothing.
- Item 12: both sections sit under `§ This environment`, the audit
  covering this repository alone, so `install-dev.sh`'s seeded hygiene
  copy does not carry them; the file's opening paragraph names them.
  The prompt's branch is `plan/audit-<YYYY-MM-DD>`: the backlog belongs
  to no R, where `git-workflow.md` names a `plan/` branch by its R id.
  It names no documentation URL, the docs not being readable from this
  seat, and cites the dedupe homes by `rules/writing-artifacts.md § One
  home per finding` rather than listing them. Result: the user's
  `/schedule` call takes the prompt as written in `MAINTENANCE.md
  § Weekly audit`.
- Review 4: the installer removes the three retired scripts and every
  settings entry, on any event, whose command runs one, dropping an
  event it leaves empty, so a `PreCompact` entry naming the deleted
  session-state writer goes with the `Stop` nudge rather than run a
  missing script. The upgrade fixture's install and check share one
  line, `install-dev.test.sh` standing at the code-size gate's 300
  lines. Result: a reinstall over an earlier install leaves no retired
  hook and no entry running one, and keeps every other entry.
- Review 5: a queued judgment call and a carried concern are written as
  `## Review` entries, the section the runner already writes and
  § Monitor already re-derives from, which the close resolves;
  `branch-plan.md § Task report` names the carried concern among the
  runner's entries. Result: both survive compaction in the task
  report.
- Review 8: the claim entries also follow the line shifts this round's
  edits make in `scripts/install-dev.sh` (items 2, 3 and 5) and
  `run.md § Batch close` 1 (item 10).
- Review 9: commit "Ignore the harness state directory" adds `state/` to
  `.gitignore`, outside every item: the directory holds the harness's
  `state/mcp-discover-verdicts.json` in this checkout. Result: the
  harness's state stays out of the tree.
### Findings
- [x] Item 10: `REQUIREMENTS.md` still has the batch close review the
  full batch diff on the most capable model, where `run.md § Batch
  close` 1 now runs it at the review's cost
  Evidence: contract `REQUIREMENTS.md:62`, "The batch close phase
  reviews the full batch diff on the most capable model"

## Answers

- Item 6: keep the `CLAUDE.md` bullet without "in DEV"; routing to the
  owning home binds in both modes.
- Item 9: a CI wait whose exit prints `no checks reported` is neither
  pass nor fail; it runs again once the checks register, so "once" means
  once per real result.
- Item 9: no test; the `## Claims` entry is filled from the second probe.
- Item 9: fix the missing head sha on this branch.
- Item 9: after `no checks reported`, re-run the CI wait in the
  background after a short delay, at most 3 times; still no checks then
  escalates to the user.
- Item 10: with no `review:` line the batch review runs at the
  reviewer's pins; `REQUIREMENTS.md` follows the rule.
- Close review: the branch-naming rule admits `plan/audit-<YYYY-MM-DD>`.
- Close review: the CI-wait retry's `sleep` goes to R088's backlog, no
  allow rule.
- Close review: the installer cleanup of an earlier install is fixed on
  this branch.
- Close review: the runner writes each queued judgment call and carried
  concern to the task report as it arises.

## Review

- [x] Item 9: the GitHub state check returns no head sha, so
  `run.md § Boundary verification` 4 cannot match CI to the head sha;
  add `headRefOid` to the state-check form in `toolchain.md § State
  check` and the `.claude/CLAUDE.md` declaration (Important) -
  `skills/dev/companions/toolchain.md:11`
  Evidence: observed `gh pr view 600 --json
  state,mergedAt,statusCheckRollup` returns only `mergedAt`, `state`,
  `statusCheckRollup`, no rollup entry holding a commit sha (implementer
  report, item 9)
- [x] Item 9: "once the checks register" names no mechanism; after a
  `no checks reported` exit the CI wait re-runs in the background after
  a short delay (`sleep 30 && <CI wait>`), at most 3 times, and still no
  checks escalates to the user (Important) -
  `skills/dev/git-workflow.md:63`
  Evidence: observed the item 9 implementer report: the answer's
  wording gives no way to learn registration without polling
- [x] Close review: `MAINTENANCE.md § Weekly audit` cuts
  `plan/audit-<YYYY-MM-DD>`, a form the `plan/` naming rule does not
  admit; amend `git-workflow.md` to admit it for the audit (Critical) -
  `skills/dev/git-workflow.md:49`
  Evidence: contract `git-workflow.md:49-54`, `plan/r<NNN>-<action>`
- [x] Close review: a reinstall over an earlier install keeps the
  `dev-handoff-nudge.sh` Stop entry and the three retired scripts;
  `install-dev.sh` removes both, `install-dev.test.sh` asserts it with an
  upgrade fixture (Important) - `scripts/install-dev.sh`
  Evidence: observed the close review's upgrade probe: `.hooks.Stop`
  still holds the nudge after a HEAD reinstall over an aa1137c install
- [x] Close review: with no ledger, queued judgment calls and carried
  concerns have no home after compaction; the runner writes each to the
  task report as it arises (Important) - `skills/dev/run.md:290`
  Evidence: contract `run.md:109` and `:165` queue them, `run.md:290-294`
  re-derives from sources that do not hold them
- [x] Close review: `run.md § Question resolution` restates the
  settled-homes check of `CLAUDE.md § Scope`; keep only the `## Answers`
  citation step and cite `CLAUDE.md § Scope` (Important) -
  `skills/dev/run.md:128`
  Evidence: contract `rules/claude-md.md § Size and structure`, "No
  duplication"
- [x] Close review: `verification-policy.md § Close folding` restates
  `run.md § Batch close` 1, which it cites; cut the restated clause
  (Important) - `skills/dev/companions/verification-policy.md:50`
  Evidence: contract `rules/claude-md.md § Size and structure`, "No
  duplication"
- [x] Close review: claim entries cite stale lines - item 6 `CLAUDE.md`
  58 (now 61), item 4 `run.md § Monitor` 282-286 (now 290-294), item 10
  `verification-policy.md` 136-140 (now 135-139) (Suggestion) - this
  report, `## Claims`
  Evidence: observed the close review's reads
- [x] Close review: commit "Ignore the harness state directory" is not
  named in `## Implementer`; name it as a divergence (Suggestion) - this
  report
  Evidence: observed `git log aa1137c..HEAD`
- [x] Close review: `scripts/install-dev.sh` line 11 runs to 121
  characters where its comment wraps near 78; rewrap (Suggestion) -
  `scripts/install-dev.sh:11`
  Evidence: observed line length
- [x] Close review: count annotations "the three rules" and "Those three
  values" drop the count (Suggestion) -
  `skills/dev/companions/verification-policy.md:125`,
  `skills/dev/companions/declarations.md:132`
  Evidence: contract `rules/writing-artifacts.md § One home per number`
- [x] Close review: `DESIGN.md` names retired mechanisms - "so no session
  file carries state across compaction" (drop the clause) and "The runner
  keeps no ledger" (say "keeps no record of its own") (Suggestion) -
  `DESIGN.md:103`, `DESIGN.md:48`
  Evidence: contract `rules/writing-artifacts.md § State the present`
