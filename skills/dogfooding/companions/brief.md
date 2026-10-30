# The brief

Two texts go into `create_session`. The system prompt addition sets the
autonomy rule; the prompt is the task. Both fold in the fixes
`pitfalls.md` calls for. Pass them verbatim, the placeholders replaced.

**System prompt addition** (`append_system_prompt`):

```markdown
You are running a fully autonomous dogfooding exercise. The user is observing this session and will not answer questions, approve gates, or intervene until you deliver the final report. Never block on the user: whenever a skill, mode file, gate or hook asks the user something (AskUserQuestion, an `approved:` gate, a supervisor decision), decide it yourself with the sensible or recommended option, and record each such stop in your running notes as an "autonomy stop" with what the toolset asked and what you chose. Never include a model identifier in commits, PR titles, PR bodies or repository files. Work at high reasoning effort: verify claims against files and command output rather than memory.
```

**Prompt** (`prompt`; replace `<REVIEW_SESSION_ID>`, `<REPO>`, `<TOOLSET_COMMIT>` and `<TASK_COUNT>`):

```markdown
## Goal

Dogfood the claude-dev toolset end to end on a tiny new project, test every feature you use while using it, and deliver a candid report. Everything here is temporary: the repository `<REPO>` (checked out in this session, push access granted, default branch `main`) and this cloud container. The user observes only. Complete this 100% self-managed; do not ask the user anything.

## Step 1: install the toolset

1. `git clone https://github.com/concentrator/claude-dev ~/src/claude-dev && git -C ~/src/claude-dev checkout <TOOLSET_COMMIT>`. Record the commit for the report.
2. Read its README sections "Setup on a new machine" and "Installing the toolset elsewhere", then run the global install from the clone: `bash scripts/install-dev.sh`. If the permission classifier refuses it, record the refusal, then try the project install `bash scripts/install-dev.sh --project <repo path>` on a branch; if that is refused too, record it and follow the toolset by reading `~/src/claude-dev/skills/dev/SKILL.md` and the mode files it names, exactly as the skill would.
3. Record whether the `/dev` skill became available to the Skill tool.

## Step 2: the project

Build a dependency-free Node.js command-line calculator, CalcApp.js, in the repository root. Keep it small; the process is the point. Use the DEV workflow for everything: `/dev start` (REQUIREMENTS, DESIGN, project CLAUDE.md with `## Agent toolchain`, `## Supervision` declaring `Supervisor: AI`, `## Layout`, docs home `docs/` with `index.md`, plans tree `dev/plans/`, `.gitignore`, README, lint + test + CI). CI is a GitHub Actions workflow running the fast tier on pull requests. Then `/dev plan R` for one initiative, `/dev plan R001` for the first <TASK_COUNT> of these feature tasks, in this order (arithmetic module; expression parser with precedence and parentheses; CLI with argv and a REPL; history and memory), each adding a documented component; `/dev plan batch R001`; `/dev run`; `/dev ship` per branch; `/dev release` if a release routine was set up. Follow `git-workflow.md` for branches, commits, PRs and merges. If a declared host command fails or the permission classifier refuses a merge, record the command and its reason as a finding, and go on as the toolset's text directs; name the merge order in the report.

## Step 3: test while using

Judge each criterion from evidence collected as you go: 1 correctness of behaviour; 2 non-conflicting conventions; 3 sequential and clean workflow; 4 no gaps; 5 docs updated after each code change; 6 a docs index and a doc per new component; 7 plan tasks name the exact documents the implementer must read; 8 no unnecessary files or actions; 9 instructions loaded only when needed; 10 token consumption (sum the `usage` fields over every transcript under `~/.claude/projects`; try `python3 ~/src/claude-dev/scripts/context-cost.py --last 1` first); 11 every permission prompt or denial, with the tier or template that should cover it; 12 every wait, retry or detour and its cause. Keep a running notes file in your scratchpad and append after every step.

## Step 4: deliver

1. Write `docs/reports/dev-dogfood-report.md`: environment table, what ran, a verdict table (Pass / Partial / Fail with evidence) per criterion, token figures, the permission stops table, then sections "What blocks rapid development", "What increases cost", "What works wrong, or maybe wrong", each finding naming its file or step and a fix. Ship it through the normal workflow and leave the tree clean.
2. Send the summary (one line per criterion, the three sections condensed, PR links and merge order, final main commit) with `send_message` to `<REVIEW_SESSION_ID>`, in two messages if long. If the send is refused, write the same text to `summary.md` in your scratchpad and say so in your final message.
3. Do not delete the repository or the container. Do not stop until step 4 is done.
```
