# Maintenance

Keeps `.claude/` and the project root clean and healthy — a periodical
cleanup + repair routine. The **Routine** section is generic and seeded
into each project's `.claude/MAINTENANCE.md`; the **This environment**
section holds targets unique to this repo.

## Routine

Run on the cadence below, or on demand. For each target: detect → report
→ repair. Never silently delete something you didn't create; surface
contradictions instead of acting on them.

### Targets and thresholds

Initial defaults — tune per project.

| Target | Check | Cadence / threshold |
|---|---|---|
| Transcripts | retention | `cleanupPeriodDays` (settings) |
| `plans/` | orphaned or closed plan, findings, requirements & batch files; empty `R-XXX-<slug>` dirs | monthly |
| `plans/visual-artifacts/` | gitignored scratch left behind | clear when stale |
| `settings.local.json` | allow-list mess: one-off / dead / overlapping rules | weekly |
| skills/ | dead, unused, broken, or duplicate skills | monthly |
| rules/ & CLAUDE.md | stale paths / dead references | on edit + monthly |
| repo root & `.claude/` | stray temp / build artifacts | weekly |
| sizes | CLAUDE.md ≤ 200 lines; SKILL.md within word caps | on edit |
| file counts | flag unexpected growth in `plans/`, skills/ | monthly |

### Repair

- Broken JSON / invalid settings → fix or revert.
- Dead reference (missing skill, renamed path) → update or remove.
- Orphaned findings/plan files for merged work → archive or delete.
- Duplicate rule across files → keep one, delete the other.

### Generalize allow rules

Accepted permission prompts accumulate as verbatim one-offs; the list
rots and prompts keep rising for near-identical commands. Weekly, per
settings file (`settings.json` global, `settings.local.json` per
project):

1. Group entries by command; collapse variants into one prefix rule
   (`Bash(go test -v ...)`, `Bash(go vet ...)` → `Bash(go:*)`).
   Generalize only the prefix actually recurring — not `Bash(*)`.
2. Drop spent one-offs: exact commands with literal paths, session
   scratch (`/tmp/*.sh`), finished migrations/renames.
3. Drop entries embedding secrets/tokens — always; rotate if leaked.
4. Drop rules that defeat the allowlist (`Bash(bash *)`,
   `Bash(env)`-style secret dumps) — re-approve narrowly instead.
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
- Verify no skill or rule references removed scripts/log files.
- Confirm foundational files stay at the repo root (not nested
  `.claude/`), per `DESIGN.md § Self-hosting layout`.
