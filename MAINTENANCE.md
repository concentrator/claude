# Maintenance

Keeps `.claude/` and the project root clean and healthy. Two parts: the
**Tier-2 AI review** gates each change into `main` (per-PR); the
**Routine** is the time-based cleanup + repair sweep. The Routine
section is generic and seeded into each project's
`.claude/MAINTENANCE.md`; the **This environment** section holds targets
unique to this repo.

## Tier-2 AI review

The per-PR compliance gate for `~/.claude`, complementing the Tier-1
mechanical CI checks in `scripts/ci/`. Before a PR merges, an AI
reviewer reads the diff against the rule set and confirms four concerns:

- **Compliance** — each changed file obeys its governing rule
  (`CLAUDE.md` per `rules/claude-md.md`; `SKILL.md` per `rules/skills.md`;
  plans per `skills/dev/plan.md`).
- **Cross-file integrity** — references resolve; no rule duplicated
  across files; the `DESIGN.md` tree-map matches the tree.
- **Cleanup** — no stray scratch, dead prose, or transient content.
- **Reference freshness** — no dead paths; no expired time-bound
  references. Mark a time-bound reference `<!-- expires: YYYY-MM-DD -->`;
  `scripts/ci/check-references.sh` fails once the date is past.

Relationship: `rules/*` define the rules; this Tier-2 review applies
them to a change and records its verdict in `maintenance.jsonl` (the
append-only ledger); the Tier-1 gate `scripts/ci/check-ledger.sh`
refuses any PR whose head SHA lacks a clear ledger entry. The Routine
below is the time-based sweep; this is the per-change gate.

### Ledger (`maintenance.jsonl`)

An append-only JSONL file — one stamp per line, keyed by content-tip SHA:

    {"sha": "<content-tip-sha>", "reviewed": "YYYY-MM-DD", "concerns_clear": true}

`.gitattributes` sets `maintenance.jsonl merge=union`, so concurrent PR
stamps auto-merge (both lines kept) instead of conflicting.

Protocol: review at the content tip (the last non-ledger commit), then a
final commit **appends** the line for that tip's full SHA, touching only
`maintenance.jsonl`. `check-ledger.sh` confirms a `concerns_clear` line
exists whose SHA is an ancestor of `HEAD` and whose `<sha>..HEAD` diff
touches only `maintenance.jsonl` — proving the review covered exactly the
delivered tree.

### Prune dead prose

Part of the Compliance concern: review every rule, instruction, or
sentence the diff adds or touches against three gates —

1. Accurate and sensible in context?
2. Valuable in any real scenario?
3. Would behavior change if it were removed?

Fail any gate → cut it and propose the fix. This catches transplanted
verbatim phrasing, coined or idiosyncratic terms where a standard one
exists, rationale that belongs in requirements/DESIGN, and rules that
merely restate a default — replace with the conventional wording
(`CLAUDE.md § Writing`).

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
- Pre-push hook: a tracked `.githooks/pre-push` runs the Tier-1 gate
  (`scripts/ci/run-all.sh`) locally — advisory, bypass with
  `git push --no-verify`. Enable once per clone:
  `git config core.hooksPath .githooks`.
- Verify no skill or rule references removed scripts/log files.
- Confirm foundational files stay at the repo root (not nested
  `.claude/`), per `DESIGN.md § Self-hosting layout`.
