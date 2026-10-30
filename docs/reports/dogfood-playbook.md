# DEV toolset dogfood run: playbook

Oct 29, 2026 · @Dmitry

## Purpose and scope

A dogfood run drives the DEV toolset (`concentrator/claude-dev`) end to end on a throwaway project, in a fresh cloud session that nobody touches, and ends with a report graded against twelve criteria.

The run answers one question: can an agent adopt the toolset and deliver a small initiative without a human, and what does that cost. It does not test the toolset's own CI, which `claude-dev`'s Tier-1 gate covers.

- **Produces:** a repository on `main` with the project, its plans archive, docs with an index, a changelog, and `docs/reports/dev-dogfood-report.md`; a one-line verdict per criterion; three lists of findings (blocks, cost, wrong).
- **Run it** after any change to `skills/dev/`, `agents/`, `hooks/` or the installer, and on a fixed cadence otherwise, so run-to-run deltas show regressions.
- **Two sessions:** a run session that does the work, and a review session that prepares it, watches it, merges its output and writes the final judgement. The playbook below is written for the review session, which is what the skill will automate.

## Requirements

| Item | Requirement | Why |
| --- | --- | --- |
| Toolset | `concentrator/claude-dev` public on GitHub, at the commit to test | The run clones it over HTTPS; a private clone needs the Claude GitHub App to cover it too |
| Target repository | A fresh GitHub repository under the user's account, one initial commit on `main`, public or covered by the Claude GitHub App | The run needs push and pull-request access; a repository the session's credential cannot see fails at `add_repo` |
| GitHub App coverage | The Claude GitHub App installation on the owner account includes the target repository (`github.com/settings/installations`, Claude, Repository access) | Making the repository public fixes reads only; pushes are refused until the app covers it |
| GitHub identity | claude.ai's GitHub connection is the repository owner | A connection to another GitHub user cannot see the owner's private repositories |
| Review session mode | `auto` permission mode, set in the app before the run session is created | A child session cannot be more permissive than its parent; a `default` child blocks on its first Write prompt |
| Run session | Cloud environment with trusted network access, model `claude-opus-5-5`, permission mode `auto`, `source_url` = the target repository | The environment API has no effort setting; high effort goes in the system prompt addition |
| Session trust | The review session must be allowed to reach the owner's other sessions (a one-time trust card the owner answers in person) | Without it the run session's `send_message` back to the review session is refused |
| Tools in the run session | `gh` is present but REST-only in cloud sessions; `gh pr` subcommands fail with HTTP 403 | The toolset's declared `gh pr` commands do not work; the run writes a REST wrapper or the brief supplies one |
| Tags | Not creatable from a cloud session, by git push or by `gh api` | The release tag is done by hand on a trusted machine after the run |
| Budget | About 30 USD and one hour per run at the first run's scale (4 tasks, 37 seats) | Scale the task count down for a cheaper smoke run |

## Preparation, step by step

Steps 1 to 3 are the owner's, done once per run; the rest the review session does.

1. **Create the target repository** on GitHub: `tmp-dev-<slug>` under the owner account, private or public, "Add a README" ticked so `main` exists. Record its URL.
2. **Cover it with the Claude GitHub App:** `github.com/apps/claude/installations/select_target`, pick the owner account, Repository access, add the repository, save. Check that claude.ai's GitHub connection is that same owner.
3. **Put the review session in `auto` mode** in the app's mode selector before anything else. Changing it later restarts the session's worker and loses nothing, but the run session cannot be created in `auto` until this is done.
4. **Attach the repository** from the review session: `add_repo` with `access: push`, then `check_repo_access`; both must report push ok. A `not_found_or_no_access` result means step 2 or the identity is wrong; a `push_check: refused` after a successful attach means step 2 alone.
5. **Confirm session trust** once: the first `send_message` to another session returns a `content_digest`; pass it to `confirm_repository_trust`, and the owner answers the card in person. Skip this and the run session's summary never arrives.
6. **Record the toolset commit** to test: `git -C <claude-dev clone> rev-parse HEAD`, and that it equals `origin/main` or the branch under test.
7. **Create the run session** with `create_session`: `source_url` = the repository, `model: claude-opus-5-5`, `permission_mode: auto`, a tag such as `dogfood-<date>`, the system prompt addition and the brief from the next section, with the review session's id substituted into the brief's delivery step.
8. **Arm a safety-net check-in** with `send_later`, 90 minutes, naming the run session id, so a stalled run is noticed without polling. Delete it when the summary arrives.
9. **Clone the repository locally** in the review session as well, shallow, for the verification step at the end.

## The brief

Two texts go into `create_session`. The system prompt addition sets the autonomy rule; the prompt is the task. Both fold in the fixes the pitfalls section calls for.

**System prompt addition** (`append_system_prompt`):

```markdown
You are running a fully autonomous dogfooding exercise. The user is observing this session and will not answer questions, approve gates, or intervene until you deliver the final report. Never block on the user: whenever a skill, mode file, gate or hook asks the user something (AskUserQuestion, an `approved:` gate, a supervisor decision), decide it yourself with the sensible or recommended option, and record each such stop in your running notes as an "autonomy stop" with what the toolset asked and what you chose. Never include a model identifier in commits, PR titles, PR bodies or repository files. Work at high reasoning effort: verify claims against files and command output rather than memory.
```

**Prompt** (`prompt`; replace `<REVIEW_SESSION_ID>`, `<REPO>` and `<TOOLSET_COMMIT>`):

```markdown
## Goal

Dogfood the claude-dev toolset end to end on a tiny new project, test every feature you use while using it, and deliver a candid report. Everything here is temporary: the repository `<REPO>` (checked out in this session, push access granted, default branch `main`) and this cloud container. The user observes only. Complete this 100% self-managed; do not ask the user anything.

## Step 1: install the toolset

1. `git clone https://github.com/concentrator/claude-dev ~/src/claude-dev && git -C ~/src/claude-dev checkout <TOOLSET_COMMIT>`. Record the commit for the report.
2. Read its README sections "Setup on a new machine" and "Installing the toolset elsewhere", then run the global install from the clone: `bash scripts/install-dev.sh`. If the permission classifier refuses it, record the refusal, then try the project install `bash scripts/install-dev.sh --project <repo path>` on a branch; if that is refused too, record it and follow the toolset by reading `~/src/claude-dev/skills/dev/SKILL.md` and the mode files it names, exactly as the skill would.
3. Record whether the `/dev` skill became available to the Skill tool.

## Step 2: the project

Build a dependency-free Node.js command-line calculator, CalcApp.js, in the repository root. Keep it small; the process is the point. Use the DEV workflow for everything: `/dev start` (REQUIREMENTS, DESIGN, project CLAUDE.md with `## Agent toolchain`, `## Supervision` declaring `Supervisor: AI`, `## Layout`, docs home `docs/` with `index.md`, plans tree `dev/plans/`, `.gitignore`, README, lint + test + CI). CI is a GitHub Actions workflow running the fast tier on pull requests. `gh pr` subcommands fail in this container (REST only); declare the state-check, CI-wait and merge commands as `gh api` calls or a small wrapper script, and record that as a finding. Then `/dev plan R` for one initiative, `/dev plan R001` for four feature tasks (arithmetic module; expression parser with precedence and parentheses; CLI with argv and a REPL; history and memory), each adding a documented component; `/dev plan batch R001`; `/dev run`; `/dev ship` per branch; `/dev release` if a release routine was set up. Follow `git-workflow.md` for branches, commits, PRs and merges. If a merge is refused by the permission classifier, record it, retarget nothing, and stack the next branch on the previous one; name the merge order in the report.

## Step 3: test while using

Judge each criterion from evidence collected as you go: 1 correctness of behaviour; 2 non-conflicting conventions; 3 sequential and clean workflow; 4 no gaps; 5 docs updated after each code change; 6 a docs index and a doc per new component; 7 plan tasks name the exact documents the implementer must read; 8 no unnecessary files or actions; 9 instructions loaded only when needed; 10 token consumption (sum the `usage` fields over every transcript under `~/.claude/projects`; try `python3 ~/src/claude-dev/scripts/context-cost.py --last 1` first); 11 every permission prompt or denial, with the tier or template that should cover it; 12 every wait, retry or detour and its cause. Keep a running notes file in your scratchpad and append after every step.

## Step 4: deliver

1. Write `docs/reports/dev-dogfood-report.md`: environment table, what ran, a verdict table (Pass / Partial / Fail with evidence) per criterion, token figures, the permission stops table, then sections "What blocks rapid development", "What increases cost", "What works wrong, or maybe wrong", each finding naming its file or step and a fix. Ship it through the normal workflow and leave the tree clean.
2. Send the summary (one line per criterion, the three sections condensed, PR links and merge order, final main commit) with `send_message` to `<REVIEW_SESSION_ID>`, in two messages if long. If the send is refused, write the same text to `summary.md` in your scratchpad and say so in your final message.
3. Do not delete the repository or the container. Do not stop until step 4 is done.
```

## What to watch and log during the run

The review session watches from outside through `get_session` and `list_events`; it never messages the run session while it works. Log each item with a timestamp into a run log, so the final judgement cites events rather than memory.

| Signal | How to read it | What to log |
| --- | --- | --- |
| Stalls | `get_session`: `status_bucket` BLOCKED or `post_turn_summary.needs_action` set | The prompt text, the tool, how long it waited; in `auto` mode a stall is a defect in the brief or the toolset |
| Permission denials | `list_events` kind `result`, field `permission_denials`; the run's own notes | Command, classifier reason, which settings tier or shipped template should have covered it |
| Autonomy stops | The run's notes and report ("autonomy stop") | What the toolset asked, the option chosen, whether the choice mattered later |
| Seat fan-out | `result.subagent_stats`: spawned, completed, failed, by type | Seats per task; a second seat for the same step is waste to name |
| Context growth | `external_metadata.context_usage.used_tokens` sampled each check | Peak context; what the run read before its first scaffold file |
| Cost | `usage.cost_usd`, `cache_read_tokens`, `cache_write_tokens`, `output_tokens` on `get_session` | Totals at the end; compare run to run at equal task count |
| Branches and PRs | `git ls-remote`, `list_pull_requests` with `base` and `head` | Stacking (a PR whose base is not `main`), merge refusals, CI red |
| CI | `pull_request_read` `get_check_runs` on each head | Any failure the run caused itself, and how many pushes it took |
| Repository hygiene | `git status --short`, `git ls-files`, untracked and ignored lists on the final tree | Stray files, wrapper scripts the toolset forced, tracked files the toolset should have ignored |
| Toolset claims | Each finding in the report that names a toolset file and section | Open the file at the tested commit; mark the claim verified or not before repeating it |

The twelve criteria and what counts as evidence for each:

1. **Correctness:** a hook, check or gate did what its file says, or a cited file does not exist in the install.
2. **Non-conflicting conventions:** two shipped files that a seat had to choose between; name both.
3. **Sequential and clean:** a step that had to be repeated, or a defect with no route back to the step that owns it.
4. **No gaps:** something a mode file assumes exists (a branch, a file, a value) that no step creates.
5. **Docs after each change:** each merged branch touched its component doc; the per-branch cadence is by design.
6. **Index and new docs:** `docs/index.md` has one line per component doc; count both.
7. **Exact documents in tasks:** each branch plan names the doc the implementer reads, not "the docs home".
8. **Optimised:** files or seats that added nothing: count them and their tokens.
9. **Loaded when needed:** files and lines read before the first project file; whether the skill loaded as a skill.
10. **Tokens:** totals over all transcripts, main-session peak context, per-seat average; the previous row of `docs/reports/dogfood-runs.md` is the baseline.
11. **Permission stops:** the denials table; zero is the target.
12. **Smooth and rapid:** wall time from session creation to report merged; every detour and its cause.

## Finishing

The run ends with the report on a branch and, until the merge rule is shipped, every pull request open and stacked. The review session finishes the project, then judges.

1. **Read the summary** from the run's message, or from its last assistant message via `list_events` when the send was refused.
2. **List the open pull requests** with `base` and `head`. Stacked ones have the previous head as base.
3. **Retarget before merging.** Set every stacked pull request's base to `main` with `update_pull_request` first, then merge in number order with `merge_pull_request`, method `merge`, passing `expectedHeadSha`. Merging a stacked PR while its base is still a branch lands it on that branch, not on `main`; GitHub retargets only when the base branch is deleted.
4. **Verify `main`:** shallow pull, `git status --short` empty, the report present, tests green (`node --test`), the app runs, `CHANGELOG.md` stamped.
5. **Tag the release by hand** on a trusted machine: `git tag -a v0.1.0 <release merge sha> -m v0.1.0 && git push origin v0.1.0`. Cloud sessions cannot create tags.
6. **Verify the report's toolset claims** against the tested commit before repeating them.
7. **Write the judgement:** verdict per criterion with the review session's own evidence where it differs from the run's, then the three findings lists. Deliver it to the owner, and append the run's row to the comparison table in `docs/reports/dogfood-runs.md`.
8. **Clean up:** the owner deletes the repository, or keeps it as the baseline for the next run's diff. Merged branches stay unless the owner deletes them; branch deletion is refused to the session as destructive.

## Known pitfalls from the first run

Each cost real time on 2026-10-29. The fix column is what the playbook or the brief now does about it; the toolset fixes belong in `claude-dev`'s backlog.

| Pitfall | What happened | Fix |
| --- | --- | --- |
| Repository invisible | `add_repo` returned not found for a private repository; the GitHub App did not cover it | Step 2 of Preparation; public visibility alone fixes reads, not pushes |
| Wrong GitHub identity | The connected GitHub user was not the repository owner | Reconnect as the owner, or invite the connected user with write access and still cover the repository with the app |
| Child in `default` mode | The review session was in `default`, so `auto` was refused for the child; the child then blocked on its first Write | Step 3: switch the review session first; only the owner can switch it, in the app |
| Summary never arrived | The run's `send_message` was refused: the review session was not trusted to reach other sessions | Step 5: answer the trust card once per review session, before the run |
| Installer refused | `auto` mode refused `install-dev.sh` as external code, and a manual copy as a bypass; no hooks or skill loaded | Brief step 1 records it and falls back; toolset backlog: an install path a cloud session may run, such as a setup script |
| Merges refused | Every merge was refused as "Merge Without Review", even after review and green CI | Brief step 2 stacks branches; the review session merges; toolset backlog: ship the merge allow rule |
| Stacked merge landed on a branch | Merging PR 2 while its base was the scaffold branch put it there, not on `main` | Finishing step 3: retarget to `main` first |
| `gh pr` unusable | Cloud `gh` is REST only; the declared `gh pr view` and `gh pr checks` fail with 403 | Brief step 2 asks for `gh api` forms; toolset backlog: ship REST forms in `toolchain.md` |
| Tag impossible | `git push` of a tag and `gh api git/refs` both refused by the proxy | Finishing step 5, by hand |
| Branch deletion refused | `git push --delete` is classed as destructive | Leave branches; the owner cleans up |
| Safety-net check-in failed | The `send_later` reminder fired with access denied after the session restarted | Re-arm the check-in after any worker restart, or rely on `get_session` polls from the skill |
| Effort not settable | `create_session` has no effort parameter | The system prompt addition asks for high effort; record the served model from `get_session` |

## Skill design notes

The skill runs in a review session and treats the run session as a black box with a known contract: a repository state and a report at the end. Keep the brief verbatim in the skill, parameterised only by the three placeholders.

**Inputs**

- `repo`: the target repository URL, created and app-covered by the owner beforehand; the skill refuses to start until `check_repo_access` reports push ok.
- `toolset_commit`: a sha or branch of `claude-dev`; default `origin/main`.
- `scale`: task count, default 4; a smoke run of 1 task exercises the same modes at a quarter of the cost.
- `baseline`: the previous run's report URL or its figures, for the delta.

**Outputs**

- The report on `main` of the target repository, and the judgement delivered to the owner.
- One row appended to the comparison table in `docs/reports/dogfood-runs.md`.
- The findings diff: findings new since the baseline, findings gone, findings unchanged. A finding is matched by the toolset file and section it names.

**Schedule and triggers**

- Weekly on a fixed day outside 06:00 to 09:00 Pacific, and on demand after a merge that touches `skills/dev/`, `agents/`, `hooks/` or `scripts/install-dev.sh`.
- The owner's part (repository, app coverage, `auto` mode, trust) is the same each time; a reusable repository the skill resets to its initial commit removes steps 1 and 2 from every later run, if the owner accepts force-pushing `main` of a throwaway repository on a trusted machine.

**What the skill checks before trusting the run's report**

- Every toolset claim opened at the tested commit.
- Token figures recomputed from the run's `get_session` usage, not only the run's own sums.
- The merged `main` verified as in Finishing step 4.
- Verdict changes against the baseline explained by a named finding, or flagged as unexplained.

## Review findings

A review of this playbook against the repository found six changes it
needs before it becomes the dogfood skill:

1. The brief must not work around what R089 is judged on: brief step 2
   tells the run to declare `gh api` forms and to stack branches when a
   merge is refused. The brief instead records a refusal, as it already
   does for the installer, so the re-run shows whether the gap is closed.
2. The task count is hard-coded at four while the design notes offer a
   `scale` input and say the brief has only three placeholders: the
   brief gains a task-count placeholder.
3. The pitfalls table cites `toolchain.md`; the file is
   `skills/dev/companions/toolchain.md`.
4. The comparison row cites the bare hash `d1a854d`; the durable-id rule
   pairs it with its subject, "Merge pull request #612".
5. The comparison table is kept "with the skill", but the install copies
   skills into `~/.claude` and run measurements belong in a report: the
   table lives in one file under `docs/reports/`.
6. The date and byline header and the first-run history lines ("lost
   about two hours", "the first run's three strongest claims all held")
   are history; they live in `docs/reports/dev-dogfood-report.md`.

The playbook is far over the 300-word body cap of
`rules/skills.md § Size`, so it lands as a short `SKILL.md` with
companions, as `skills/worker-host/` does, the brief kept verbatim.
