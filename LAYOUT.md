# Layout

The repository's actual tree - every directory and fixed-name file, a
collection of same-kind files as one pattern line (`skills/dev/layout.md
§ Layout file`); harness-managed state (`projects/`, `cache/`,
`plugins/`, logs) is gitignored, and skills symlinked from external
repos are versioned there, not mapped.

```
~/.claude/
├── CLAUDE.md                     # global instructions, every session
├── writing.md                    # universal writing conventions (@imported by CLAUDE.md)
├── settings.json                 # global Claude Code config (tracked)
├── .gitignore                    # ignore rules for harness state
├── .env.example                  # worker-host tokens; `.env` is never tracked
├── README.md                     # overview and install
├── REQUIREMENTS.md               # foundational requirements
├── DESIGN.md                     # architecture (≤1000 words)
├── LAYOUT.md                     # the repository's tree (this file)
├── MAINTENANCE.md                # sanity routine + Tier-2 AI review
├── .github/                      # the Tier-1 CI gate
│   └── workflows/ci.yml          # Tier-1 mechanical CI gate (on PRs)
├── .githooks/                    # advisory local gate (core.hooksPath)
│   └── pre-push                  # advisory local Tier-1 mirror
├── hooks/                        # Claude Code hooks, wired in settings.json
│   ├── dev-branch-guard.sh       # PreToolUse: no trunk mutations
│   ├── dev-branch-state.sh       # UserPromptSubmit: branch/tree state
│   ├── dev-context-fill.sh       # context-fill percent helper
│   ├── dev-handoff-nudge.sh      # Stop: hand-off nudge
│   ├── dev-precompact-state.sh   # PreCompact: session state
│   ├── dev-session-brief.sh      # SessionStart: hand-off re-brief
│   ├── dev-secrets-guard.sh      # PreToolUse: secrets guard
│   └── secret-patterns.sh        # the secret predicate, sourced
├── scripts/                      # installer, checks, tests, host tooling
│   ├── ci/                       # Tier-1 checks + run-all.sh
│   ├── context-cost.py           # session context cost + attribution
│   ├── install-dev.sh            # toolset installer (global or --project)
│   ├── model-quota.sh            # pinned-dispatch quota gate
│   └── test/                     # script tests + run-all.sh
├── .claude/                      # this repository's project settings
│   └── settings.json             # project tier, tracked
├── dev/                          # DEV artifacts (session/, supervisor/ gitignored)
│   ├── plans/                    # planning hierarchy
│   │   ├── ROADMAP.md            # cross-R index: skills/dev/plan.md
│   │   ├── R<NNN>-<slug>/        # one dir per roadmap entry (initiative-time)
│   │   │   ├── requirements.md   # initiative requirements
│   │   │   ├── tasks.md          # this initiative's task index (lazy)
│   │   │   ├── R<NNN>-T<NNN>-<slug>.md          # branch plans, one per task
│   │   │   ├── R<NNN>-T<NNN>-<slug>.findings.md # task findings
│   │   │   └── batches/          # R<NNN>-B<NNN> manifests + reports (lazy)
│   │   └── archive/              # closed initiatives, frozen history
├── rules/                        # path-scoped convention rules
│   ├── claude-md.md              # CLAUDE.md maintenance rules
│   ├── writing-artifacts.md      # DEV-artifact writing rules (**/*.md; shipped)
│   ├── js.md                     # JS conventions (path-scoped)
│   └── skills.md                 # SKILL.md maintenance rules
├── agents/                       # dispatched agents
│   └── code-reviewer.md          # branch-close quality review agent
└── skills/                       # the DEV toolset and the skills beside it
    ├── dev/                      # the DEV toolset
    │   ├── SKILL.md              #   the router
    │   ├── *.md                  # modes and process rules, routed by SKILL.md
    │   └── companions/           # declarations, docs framework, prompts, verification policy, runbook
    ├── test-driven-development/  # bundled dependency skills (installer ships these)
    ├── systematic-debugging/     # bundled
    ├── verification-before-completion/SKILL.md # bundled
    ├── receiving-code-review/SKILL.md          # bundled
    ├── dispatching-parallel-agents/SKILL.md    # bundled
    ├── skill-creator/SKILL.md    # personal (skill authoring)
    └── writing-skills/           # personal
```
