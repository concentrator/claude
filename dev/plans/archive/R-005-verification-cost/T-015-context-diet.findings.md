# T-015 context-diet - findings

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

### After (2026-06-13, all rule edits in place)

Fresh `~/.claude` session, `/context` before touching any file
(Messages 8 tokens - genuinely fresh):

| Category | Tokens |
|---|---|
| Memory files (always-loaded) | 1.4k |

Memory-files breakdown: CLAUDE.md 1.4k only - `planning.md`,
`branch-plan.md`, `project-layout.md` no longer always-load.

**Delta vs baseline:** always-on memory **8.7k → 1.4k**, a **~7.2k**
per-dispatch reduction for any session that does not touch planning
artifacts (e.g. implementer/test dispatches editing source). At
uncached rates that is ~7.2k × the non-planning dispatch count per
batch; prompt caching discounts repeats, so the realized saving sits
between cached and uncached rates. Planning sessions still load the
rules on demand (verified above) - no capability lost.

Note on instrument: `/context` → Memory files tallies only always-on
memory, so this before/after captures exactly the fixed per-dispatch
baseline that criterion 5 targets. On-demand loads in planning
sessions are confirmed by the `Loaded rules/…` toast, not this panel.

## Load-behavior verification

### Round 1 - `**/plans/**` + own-file (2026-06-13) - FAILED (a, b)

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

### Round 2 - `**/plans/**/*.md` + `**/plans/*.md` + own-file (2026-06-13) - PASS (all)

Signal: the `Loaded rules/…` toast on the matching read (not the
Memory-files panel).

| Case | Setup | Observed | Verdict |
|---|---|---|---|
| a | `~/.claude`, read `plans/ROADMAP.md` | toasts: planning.md, project-layout.md, branch-plan.md | ✅ all three load |
| b | wallarm, read `.claude/plans/ROADMAP.md` | toasts: `../../.claude/rules/{planning,project-layout,branch-plan}.md` | ✅ all three load (cross-project) |
| c | wallarm, read `eslint.config.js` | toast: `js.md` only - no planning-rule toasts | ✅ none of the three load |
| d | `Read ~/.claude/rules/planning.md` by path | file returned | ✅ explicit read works |

Scoping verified: planning rules load on-demand when a plans `.md` is
touched (any project or this repo), stay out of non-planning sessions,
and remain explicitly readable.

## Triage

- [x] `skills/starting-a-project/SKILL.md` is at 307 `wc -w` total
      (~295 body once frontmatter is excluded - under the 300-word cap,
      but near it). This edit reduced the count; flagged as a tangential
      near-cap observation, not introduced here. **Won't fix** (under
      cap, compliant; monitor on next edit) - user decision 2026-06-13.

## Closing-routine decisions

- `/simplify` altitude finding: the three rules (and
  `planning-templates.md`) originally included their own file in
  `paths:` per the plan text, but all existing path-scoped rules
  (`changelog.md`, `js.md`, `skills.md`, `claude-md.md`) scope only to
  the artifacts they govern, never themselves. Dropped the own-file
  globs to match precedent (commit "Drop own-file globs to match rule
  precedent") - user decision 2026-06-13. No effect on the verified
  load behavior: cases (a)/(b)/(c) relied on the `**/plans/**/*.md`
  pair, and (d) is an explicit path read.
