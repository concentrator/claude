# Maintenance

Keeps `.claude/` and the project root clean and healthy. Two parts: the
**Tier-2 AI review** gates each change into `main` (per-PR); the
**Routine** is the time-based cleanup + repair sweep. The Routine
section is generic and seeded into each project's
`.claude/MAINTENANCE.md`; the **This environment** section holds targets
unique to this repo.

## Tier-2 AI review

A mandatory compliance review for `~/.claude`, complementing the Tier-1
mechanical CI checks in `scripts/ci/`. At branch close, before delivery,
review the diff against the rule set and confirm the concerns below:

- **Compliance** - each changed file obeys its governing rule
  (`CLAUDE.md` per `rules/claude-md.md`; `SKILL.md` per `rules/skills.md`;
  plans per `skills/dev/plan.md`).
- **Cross-file integrity** - references resolve; no rule duplicated
  across files, read maximally: any echo of a rule's text is a
  restatement, so a concern names the rule and cites its owning
  document instead (`rules/claude-md.md § Size and structure`, "No
  duplication"); the `DESIGN.md` tree-map matches the tree.
- **Cleanup** - no stray scratch or transient content, and no dead
  prose: every rule, instruction, or sentence the diff adds or touches
  passes three gates - accurate and sensible in context; valuable in a
  real scenario; behavior would change if it were removed. Fail any →
  cut it and propose the fix (content tests: `rules/claude-md.md
  § Content`).
- **Reference freshness** - no dead paths; no expired time-bound
  references. Mark a time-bound reference `<!-- expires: YYYY-MM-DD -->`;
  `scripts/ci/check-references.sh` fails once the date is past.
- **Doc sync** - a change that alters a documented surface updates the
  doc documenting it, in the same branch. The concern covers docs the
  diff does not touch: staleness a change induces elsewhere has no other
  owner, since every other concern reads only changed files. Which
  change obliges which doc is a per-project table, kept with the
  project's own targets (here: § This environment › Doc-sync pairs); a
  project without one still owes the concern, judged against its own
  docs.
- **Writing** - changed prose follows `writing.md`.

## Routine

Run on the cadence below, or on demand. For each target: detect → report
→ repair. Never silently delete something you didn't create; surface
contradictions instead of acting on them.

### Targets and thresholds

Initial defaults - tune per project.

| Target | Check | Cadence / threshold |
|---|---|---|
| Transcripts | retention | `cleanupPeriodDays` (settings) |
| `plans/` | orphaned or closed plan, findings, requirements & batch files; empty `R<NNN>-<slug>` dirs | monthly |
| `plans/visual-artifacts/` | gitignored scratch left behind | clear when stale |
| `.claude/settings.json` + any regrown `settings.local.json` | allow-list mess: one-off / dead / overlapping rules; local entries a tracked tier already carries | weekly |
| skills/ | dead, unused, broken, or duplicate skills | monthly |
| rules/, CLAUDE.md, foundational docs & README | stale paths / dead references | on edit + monthly |
| repo root & `.claude/` | stray temp / build artifacts | weekly |
| sizes | caps per `claude-md.md § Size and structure` / `skills.md § Size` | on edit |
| file counts | flag unexpected growth in `plans/`, skills/ | monthly |

### Repair

Governed files (CLAUDE.md, `rules/`, skills) are never auto-edited -
propose the repair and await approval (`claude-md.md` / `skills.md`
§ Approval). Elsewhere:

- Broken JSON / invalid settings → fix or revert.
- Dead reference (missing skill, renamed path) → update or remove.
- Findings/plan files for merged work → promote their durable facts;
  the files archive with their initiative, never per task
  (`skills/dev/plan.md § Archival`).
- Duplicate rule across files → single-home (`claude-md.md § Size and
  structure`).

### Generalize allow rules

Accepted permission prompts accumulate as verbatim one-offs; the list
rots and prompts keep rising for near-identical commands. Weekly, per
settings file (`settings.json` global, `.claude/settings.json` project
tier, any regrown `settings.local.json` per machine):

1. Group entries by command; collapse variants into one prefix rule
   (`Bash(go test -v ...)`, `Bash(go vet ...)` → `Bash(go:*)`).
   Generalize only the prefix actually recurring - not `Bash(*)`.
2. Drop spent one-offs: exact commands with literal paths, session
   scratch (`/tmp/*.sh`), finished migrations/renames.
3. Drop entries embedding secrets/tokens - always; rotate if leaked.
4. Drop rules that defeat the allowlist (`Bash(bash *)`,
   `Bash(env)`-style secret dumps) - re-approve narrowly instead.
5. Rule covered by a broader tier (global ⊃ project ⊃ local) → keep
   the broad one, delete the shadowed.
6. Recurring prompts the list misses → `/fewer-permission-prompts`
   scans transcripts and proposes additions; merge its output through
   steps 1–5.
7. Validate (`jq -e . <file>`); never commit a tracked settings file
   containing credentials.

## This environment (repo-specific)

Targets beyond the generic routine:

- Skill usage audit (monthly): read `skill_invocations.jsonl` (written
  by the `PostToolUse`/`Skill` hook in `settings.json`). A skill with
  zero invocations over the period and no inbound reference from
  CLAUDE.md / rules / other skills → flag for triage (wire in, accept
  as description-triggered, or remove). Truncate the log after review.
- Skill listing: keep total descriptions within
  `skillListingBudgetFraction`.
- Pre-push hook: a tracked `.githooks/pre-push` runs the Tier-1 gate
  (`scripts/ci/run-all.sh`) locally - advisory, bypass with
  `git push --no-verify`. Enable once per clone:
  `git config core.hooksPath .githooks`.
- Verify no skill or rule references removed scripts/log files.
- Confirm foundational files stay at the repo root (not nested
  `.claude/`), per `DESIGN.md § Self-hosting layout`.

### Doc-sync pairs

Targets for the Doc sync concern (§ Tier-2 AI review). The left column
is what the branch changed; the right is what it updates before
delivery.

| Changed | Also update |
|---|---|
| A `/dev` command added, renamed, or removed | `README.md § Workflow`, `DESIGN.md` tree-map |
| A `skills/dev/` mode file or companion added, renamed, or removed | `SKILL.md`'s router table, `DESIGN.md` tree-map |
| A tracked root file or directory added or removed | `README.md § Contents`, `DESIGN.md` tree-map |
| What `install-dev.sh` copies or registers | `README.md § Installing the toolset elsewhere`, `scripts/test/install-dev.test.sh` (it asserts the copied set) |
| A `scripts/ci/` check added or removed | `scripts/ci/run-all.sh` (its loop is what registers a check), `DESIGN.md § Self-enforcement` |
| A `hooks/` guard added or removed | `DESIGN.md` tree-map (`check-stray.sh` reads it) and § Self-enforcement, `README.md § Contents` |
| Planning layout, the artifacts root, or an id or naming convention | `README.md`, `REQUIREMENTS.md § Planning discipline`, `DESIGN.md`, and every `skills/dev/` file stating the convention (`plan.md`, `layout.md`, `branch-plan.md`, `write-plan.md`, `finish.md`, `templates.md`) |
| Any file moved or renamed | Every inbound reference (grep the tracked tree) |
