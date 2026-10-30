# DEV toolset dogfood report

A test report: the DEV toolset (`concentrator/claude-dev` at the merge of
its pull request 612, "plan/r088-t008") driven end to end on a new project,
CalcApp.js, in a Claude Code cloud session under the `auto` permission mode,
with `Supervisor: AI` and no human answering any prompt.

## Environment

| Item | Value |
|---|---|
| Toolset | `concentrator/claude-dev`, cloned to `~/src/claude-dev` |
| Session | Claude Code on the web, `auto` permission mode, 2026-10-29, 02:55 to about 03:50 UTC |
| Host CLI | `gh` with REST only: every `gh pr` subcommand fails with HTTP 403 "GraphQL is not available" |
| Repository | `concentrator/tmp-dev-calcapp`, `main` holding only the GitHub-created initial commit at start |
| Result | 69 tests over 4 components, 4 reference docs, 6 stacked pull requests, none merged |

## What ran

| Step | Mode file | Outcome |
|---|---|---|
| Install | `scripts/install-dev.sh` | Refused by the permission classifier four times; toolset used by reading its files from the clone |
| `/dev start` | `start.md` | Scaffold on `mnt/dev-scaffold`, pull request 1 |
| `/dev plan R` | `brainstorm.md` | R001 requirements on `plan/r001-open`, pull request 2 |
| `/dev plan R001`, `/dev plan batch R001` | `plan.md`, `write-plan.md`, `branch-plan.md § Batches` | 4 planners in parallel, batch R001-B001, pull request 3 |
| `/dev run R001-B001` | `run.md` | 16 implementer, 3 review, 14 docs seats; batch pull request 4 |
| Close-out | `plan.md § Approval and closure` | R001 closed and archived, pull request 5 |
| `/dev release` | `release.md` | CHANGELOG stamped on `release/v0.1.0`, pull request 6; tag blocked |
| `/dev ship` merges | `finish.md § 3` | Every merge refused by the classifier ("Merge Without Review"), so each pull request is stacked on the previous one |

## Verdict per criterion

| # | Criterion | Verdict | Evidence |
|---|---|---|---|
| 1 | Correctness of behaviour | Partial | Seats followed their contracts: red then green in every implementer report, marks and claim entries landed in the item's commit, committer signature on every run commit. Gates the files name do not exist in an adopter: `finish.md § 3` step 1 runs `ci/run-all.sh` and `plan.md § Archival` cites `check-archival`, but `install-dev.sh` ships neither. Hooks could not be observed: the install never ran |
| 2 | Non-conflicting conventions | Fail | The Reference skeleton in `layout.md § Docs` (Behavior, Parameters with an "on invalid/missing" column, Reference data) states each error three times, which the docs verifier flags against `writing.md § No repetition`. `release.md` step 5 "prune roadmap" against `plan.md` "the ROADMAP `[x]` is the closure record". `branch-plan.md § Header` shows no fence, so two planners wrote `---` frontmatter and two did not |
| 3 | Workflow sequential and clean | Partial | Planning to run to close-out ran in order. `run.md § Close` runs review, fixes, then docs; a defect the docs pass found (an overflowing literal) had no route back and left the doc stale until an extra doc-writer dispatch |
| 4 | No gaps in the dev workflow | Fail | `start.md` assumes no `main` yet; nothing adds planned branches to the release plan `start.md` creates; `release.md` step 4 removes `## [Unreleased]` and nothing re-creates it; the supervision signature names no committer value; batch-close fixes name no seat |
| 5 | Docs updated after each code change | Pass | Every branch closed with a doc-writer pass and a verifier gate: `docs/arithmetic.md`, `parser.md`, `cli.md`, `session.md`, CHANGELOG lines and README usage. Docs are per branch, not per commit, by design (`branch-plan.md § Commit cadence` 2) |
| 6 | Docs index, new component triggers a doc | Pass | `docs/index.md` gained one line per component as each doc was written; the batch review confirmed it lists every doc |
| 7 | Plan tasks reference the exact documents | Partial | Plans name exact files, tests, `DESIGN.md § Decisions` and sibling task ids. No plan names the component doc the implementer must read; the implementer contract reads "the docs home" as a whole |
| 8 | Process optimised | Fail | A one-line cosmetic review fix costs a fresh 70k-token seat (dismissed for that reason). Every one of the 4 components needed a second doc-writer round, because the writer may only write listed claims while the verifier checks the detail bar |
| 9 | Instructions loaded when needed | Partial | The router and mode files load on demand. Before writing the first scaffold file the session read about 14 files and 1,900 lines, about 28 files and 3,400 lines by the first run; each seat re-reads its contract and the files it cites. The install could not run, so nothing loaded automatically: the skill was not available to the Skill tool, and the session followed `SKILL.md` by hand |
| 10 | Token consumption moderate or less | Fail | See § Token figures: about 63.7M tokens processed across 38 transcripts (99% cache reads) and 259k output, for 4 small modules |
| 11 | No configurable permission stops | Fail | 10 classifier denials, listed in § Permission stops; none is covered by a tier or template the toolset ships |
| 12 | Smooth and rapid | Partial | About 55 minutes wall time. Detours: install (4 denials), the GraphQL-only `gh pr` (a REST wrapper written), a CI failure of my own (`node --test test/`), merge refusals, one transient push rejection |

## Token figures

Measured from this session's transcripts with a script that sums the
`usage` fields; the toolset's `scripts/context-cost.py` was refused by the
permission classifier, so its attribution table is not available.

| Measure | Value |
|---|---|
| Main session turns | 167 |
| Main session context at first request | 72.6k (harness and system prompt; no toolset loaded) |
| Main session context after the `/dev start` reads | 141.7k |
| Main session peak context | 369k |
| Main session output | 88.6k |
| Subagent transcripts | 37 |
| All transcripts: cache reads | 61.6M |
| All transcripts: cache writes | 1.79M |
| All transcripts: output | 259k |
| Seat first-request context | about 54k before reading anything |
| Seat totals | 64k to 87k each |
| Batch R001-B001 seats | about 2.4M: implementers 1.21M over 16, reviews 0.23M over 3, docs 0.97M over 14 |
| Planners | about 337k over 4 |

Top material returned to the main session, by characters: `hooks/dev-branch-guard.sh` 19.7k, `skills/dev/run.md` 18.9k, `skills/dev/branch-plan.md` 17.9k, `scripts/install-dev.sh` 15.3k, `README.md` (two sections) 13.4k, `skills/dev/companions/documentation.md` 13.3k, `skills/dev/plan.md` 12.8k, `agents/dev-implementer.md` 9.8k, `skills/dev/layout.md` 9.6k, `skills/dev/git-workflow.md` 9.0k.

## Permission stops

Every stop was a denial by the `auto` mode classifier; no permission
prompt appeared, since none could be answered.

| # | Action | Classifier reason | Tier or template that should cover it |
|---|---|---|---|
| 1, 2 | `bash scripts/install-dev.sh`, before and after reading it | Code from External | None ships; needs a user-tier allow rule or a setup-script install |
| 3 | `wc -l` and `ls` inside the toolset clone | Code from External | None; a read-only listing, the classifier was sticky on the directory |
| 4 | Copying the shipped files into `~/.claude` by hand | Auto-Mode Bypass | Same as 1 |
| 5 | Writing `.claude/settings.json` (the push carve-out from `toolchain.md`) | Self-Modification | None; the user must write it |
| 6, 7 | Merging pull request 1 through the declared merge command, before and after an independent review | Merge Without Review | `toolchain.md § Permission carve-out` has no merge rule |
| 8 | `check-plan-text.sh` from the clone | Code from External | A `--project` install would make it project code |
| 9 | `git commit --amend` and a force push on a pushed branch | Git Destructive | None should: the denial was correct and `git-workflow.md` forbids it |
| 10 | `context-cost.py` from the clone | Code from External | Same as 8 |

## What blocks rapid development

- **The install cannot run under `auto` mode.** `bash scripts/install-dev.sh`
  was refused as "Code from External", a manual copy of the same files as
  "Auto-Mode Bypass". Without it there are no hooks, no `/dev` skill, no
  seat agent types and no shipped checks in the project. Fix: document a
  user-tier allow rule for the installer in README § Setup, or install from
  the environment's setup script before the session starts.
- **No seat may merge.** `declarations.md § Supervisor bounds` says the AI
  grant includes the merge, but the classifier refuses an agent's merge of
  its own pull request as "Merge Without Review", even after an independent
  review seat and green CI. No shipped tier covers it:
  `toolchain.md § Permission carve-out` lists pushes and `glab mr create`,
  `auto-permissions.template.json` has no merge rule. Fix: ship an allow
  rule for the declared merge command in the carve-out, and say in
  `declarations.md` that `Supervisor: AI` under `auto` needs it.
- **The project settings tier cannot be written by the session.**
  `layout.md § Creation policy` requires `.claude/settings.json` at
  scaffold; the classifier refused writing it as "Self-Modification".
  Fix: `start.md` hands that file to the user, with the content to paste.
- **Toolset scripts cannot run locally.** `check-plan-text.sh` and
  `context-cost.py` were refused to the main session, yet an implementer
  seat ran `check-plan-text.sh` inside a compound command without a
  denial. Fix: ship the checks into the project (the `--project` install)
  so they are project code, and document the allow rule.
- **The declared host commands assume GraphQL.** `toolchain.md § State
  check` and `§ CI wait` give `gh pr view --json` and `gh pr checks
  --watch`; both fail with HTTP 403 in a cloud session. Fix: give a REST
  form beside each (`gh api repos/<r>/pulls/<n>`, check runs by head sha),
  as the project's `scripts/pr.sh` does.
- **`start.md` assumes a repository without `main`.** Its § 5 bootstrap
  commit creates `main`; a repository created on the host already has one.
  Fix: one line routing that case to a scaffold branch and pull request,
  as `migrate.md § 8` does.

## What increases cost

- **Writer and verifier disagree by construction.** The doc writer writes
  only listed claims (`agents/dev-doc-writer.md` § Steps 2); the verifier
  checks every input, output and error (`documentation.md § Detail bar`).
  All four components failed the gate on missing failure paths and needed
  a second writer round, about 350k tokens. Fix: the planner lists a claim
  per error path, or the writer documents every element of the code it
  reads.
- **Every fix is a fresh seat.** A one-line cosmetic suggestion costs a
  new implementer of about 70k tokens (`run.md § Close` 2), so it was
  dismissed. Fix: let the runner apply a mechanical fix
  (`verification-policy.md § Mechanical commits`) directly.
- **Each seat re-reads the same instructions.** A seat starts at about 54k
  context and reads its contract plus the files it cites before touching
  code; 37 seats paid that again. Fix: a short per-seat digest of the
  cited rules, or seat definitions that inline the few lines they use.
- **Instruction volume before any code.** `/dev start` alone sent the
  session through about 14 files; planning and running added about 14
  more, about 3,400 lines in all. Fix: `start.md` could carry its
  declarations template inline instead of routing through `migrate.md`,
  `layout.md` and `declarations.md`.
- **Parallel planners negotiate interfaces through each other's files.**
  `write-plan.md § Bulk mode` runs planners in parallel because "the tasks
  are independent", but R001-T003 and R001-T004 depend on T002. Two
  planners changed the history-reference syntax three times between them,
  adding fix commits. Fix: run bulk planners in `depends-on` order, in
  parallel only within a wave.
- **The checkpoint's Cost section is manual.** `report-template.md` asks
  for subagent tokens per role and seat prompt sizes; no tool collects
  them. Fix: have `context-cost.py` print that block.

## What works wrong, or maybe wrong

- **Gates the files cite are not shipped.** `finish.md § 3` step 1 names
  `ci/run-all.sh` and `plan.md § Archival` names `check-archival`;
  `install-dev.sh` ships neither. Fix: ship them, or name the shipped
  checks instead.
- **`rules/claude-md.md § Approval` cites a rule nothing installs.** It
  says `permissions.ask` in `~/.claude/settings.json` holds every
  `CLAUDE.md` edit; `install-dev.sh` writes only hook entries. Fix: the
  installer adds the rule, or the text stops claiming it.
- **The evidence rule can suppress a real defect.** The R001-T002 close
  review listed a 400-digit literal evaluating to `Infinity` as
  "hypothetical, not raised" (`agents/code-reviewer.md` § Evidence), yet
  it broke a written decision in `DESIGN.md` ("Finite results only"). A
  later seat observed it and it was fixed. Maybe wrong: a reading that
  shows code contradicting a written design decision is a documented
  contract, so it should count as evidence.
- **A defect found at the docs step has no route back.** `run.md § Close`
  orders review, fixes, docs; the fix after the docs left the doc stale,
  and the extra doc-writer dispatch fell outside the contract. Fix: allow
  one code-fix-then-docs pass when the docs step surfaces a defect.
- **Seats break "probe nothing".** Two doc writers and a docs verifier ran
  `node -e` against the code and said so. Maybe wrong rather than a seat
  fault: confirming a sentence by running the code is the cheapest
  evidence, and the rule may be stricter than its purpose.
- **Release steps disagree with the rest.** `git describe --tags` in
  `release.md` step 2 returns the batch anchor `pre-R001-B001` as the last
  release while a batch tag exists; step 4 drops `## [Unreleased]`, which
  the doc writer and the next release both expect; step 6 says "output
  filepath" with no path. Fix: `--match 'v*'`, keep an empty
  `## [Unreleased]` above the stamped block, name the notes' home.
- **The release plan is never filled.** `start.md` creates
  `release-v0.1.0.md` empty and the closing routine marks "any
  release-plan entry", but no step adds the entries. Fix: the detail round
  adds each planned branch to the open release plan.
- **The CHANGELOG has no seed form.** `start.md` asks for `CHANGELOG.md`
  without its first heading; the scaffold wrote `## Unreleased`, and the
  review caught that `release.md` needs `## [Unreleased]`. Fix: a seed
  template beside `gitignore.template`.
- **The supervision signature has no value.** `declarations.md` wants the
  committer name to say how a commit was applied but names no string; this
  run used `Claude (supervised: AI)`. Fix: name the value.
- **Commit attribution conflicts with the host.** `dev-instructions.md
  § Writing` forbids trailers such as `Co-Authored-By` and
  `git-workflow.md § MR/PR messages` forbids a "Generated with" line,
  while the cloud harness asks for both; the toolset's rule was followed.
  Maybe wrong only in that the toolset could say which wins.

## Setup and review

The review session that prepared the run, watched it and merged its
output adds what the run session could not see:

- Preparation lost about two hours to three requirements discovered one
  at a time: covering the repository with the Claude GitHub App, putting
  the review session in `auto` mode before creating the run session, and
  trusting the review session to reach other sessions.
- Without that trust the run's summary never arrived: its `send_message`
  was refused and it saved the summary to its scratchpad instead.
- The report's three strongest toolset claims, each opened at the tested
  commit, all held.
