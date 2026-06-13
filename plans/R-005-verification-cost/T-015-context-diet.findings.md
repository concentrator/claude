# T-015 context-diet — findings

## Measurements

`/context` isolates an always-loaded **Memory files** category that is
independent of conversation length, so it is the comparison metric for
criterion 5. The headline total is session-dependent (it includes
conversation messages) and is recorded only for reference.

### Baseline (2026-06-13, before any rule edit)

Captured on `refactor/context-diet` with rules unedited (working tree
equals `main`).

| Category | Tokens |
|---|---|
| Total context (session-polluted: 18.5k of it is messages) | 45.8k |
| Memory files (always-loaded) | 8.7k |

Memory-files breakdown:

| File | Tokens | Path-scoped by this branch? |
|---|---|---|
| CLAUDE.md | 1.4k | no (stays always-loaded) |
| rules/planning.md | 3.2k | yes |
| rules/project-layout.md | 1.3k | yes |
| rules/branch-plan.md | 2.7k | yes |

Path-scopable planning-rule baseline: **7.2k** (3.2 + 1.3 + 2.7).

`wc -w` of the three targets:

| File | Words |
|---|---|
| rules/planning.md | 1080 |
| rules/branch-plan.md | 1075 |
| rules/project-layout.md | 353 |

`planning.md § Templates` = 362 of planning.md's 1080 words (extraction target).

### After (rerun after all rule edits — see plan item 6)

_Pending._

## Load-behavior verification

### Round 1 — `**/plans/**` + own-file (2026-06-13) — FAILED (a, b)

| Case | Setup | Memory files in `/context` | Verdict |
|---|---|---|---|
| a | `~/.claude`, read `plans/ROADMAP.md` | CLAUDE.md only (1.4k) | ❌ three rules did not load |
| b | wallarm, read `.claude/plans/ROADMAP.md` | `~/.claude/CLAUDE.md` + project `CLAUDE.md` (4k) | ❌ three rules did not load |
| c | wallarm, read `eslint.config.js` | `~/.claude/CLAUDE.md` + project `CLAUDE.md` (4k) | ✅ none (but vacuous) |
| d | `Read ~/.claude/rules/planning.md` by path | (read succeeded) | ✅ explicit read works |

Initial (wrong) diagnosis: that `**/plans/**` matched nothing. The real
issue was the **instrument**: `/context` → Memory files tallies only
*always-on* memory (session-start). Dynamically path-loaded rules do
not appear there even when loaded, so the 1.4k reading was not evidence
of non-loading. The authoritative signal is the harness `Loaded
rules/…` toast emitted on the matching read. Whether round-1
`**/plans/**` also fired the toast is **indeterminate** (not observed);
round 2 switched to the file-terminated shape, which fires definitively.

### Round 2 — `**/plans/**/*.md` + `**/plans/*.md` + own-file (2026-06-13) — PASS (all)

Signal: the `Loaded rules/…` toast on the matching read (not the
Memory-files panel).

| Case | Setup | Observed | Verdict |
|---|---|---|---|
| a | `~/.claude`, read `plans/ROADMAP.md` | toasts: planning.md, project-layout.md, branch-plan.md | ✅ all three load |
| b | wallarm, read `.claude/plans/ROADMAP.md` | toasts: `../../.claude/rules/{planning,project-layout,branch-plan}.md` | ✅ all three load (cross-project) |
| c | wallarm, read `eslint.config.js` | toast: `js.md` only — no planning-rule toasts | ✅ none of the three load |
| d | `Read ~/.claude/rules/planning.md` by path | file returned | ✅ explicit read works |

Scoping verified: planning rules load on-demand when a plans `.md` is
touched (any project or this repo), stay out of non-planning sessions,
and remain explicitly readable.

## Triage

- [ ] `skills/starting-a-project/SKILL.md` is at 307 `wc -w` total
      (~295 body once frontmatter is excluded — under the 300-word cap,
      but near it). This edit reduced the count; flagged as a tangential
      near-cap observation, not introduced here.
