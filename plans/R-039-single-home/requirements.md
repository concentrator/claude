---
approved: 2026-07-30
kind: refactor
---

# R-039: Single-home the /dev system

## Current state

A precedence-ordered dedup audit of the /dev system (30 prose files,
~18.6k words: CLAUDE.md, writing.md, rules/, MAINTENANCE.md, skills/dev/
+ companions) found ~200 restatements: 15 contradictions or stale facts,
8 structural duplication clusters, roughly 15% of the prose removable.
Drift is proven, not hypothetical: the git-workflow twins diverged
(`starting-a-project` ghost), the feat/fix/refactor cadence triplets
diverged, and three files disagree on who stamps the release `[x]`.

## Desired state

Every rule has exactly one owner file; other files point, never restate.
Zero contradictions. The git-workflow twins single-sourced: the skill
copy is canonical, `rules/git-workflow.md` becomes a thin repo-pinned
pointer (both are read-on-demand, so nothing always-loaded is lost).
Execution files are type-deltas over a shared cadence. Companions
compressed. Total system prose reduced >=12%.

## Invariants

- No process-behavior change except resolving the 15 contradictions,
  each toward the named winner below.
- Deliberate adopter-completeness inlines stay (e.g. the Tier-2
  five-concern list in `branch-plan.md` - adopters lack MAINTENANCE.md).
- All file caps met; every touched file net smaller or equal.
- Tier-1 gate and `scripts/test/run-all.sh` green on every commit.
- Host-neutral wording (`git-workflow.md § Terminology`) throughout.

## Scope

The 30 audited files. Out of scope: bundled dependency skills,
DESIGN.md, hooks/scripts code (except none needed).

## Contradictions to resolve (T-079; winner named)

1. `rules/git-workflow.md` bootstrap cites `starting-a-project` →
   `start.md` (winner: reality).
2. `SKILL.md` "Planning (doc PRs)" + `plan.md:114` "doc branch" →
   "plan" (winner: prefix taxonomy, git-workflow § Trunk).
3. `MAINTENANCE.md` § Repair direct-fix wording → propose-and-approve
   for governed files (winner: claude-md/skills § Approval).
4. `rules/js.md` "still holds" vs "advisory" → one status (advisory,
   Tier-2-reviewed).
5. Release-`[x]` owner: `branch-plan.md` closing-routine mark wins
   (R-035); `templates.md § Release plan` and `release.md` align
   (release verifies marks, never sets).
6. `branch-plan.md § Scope changes` → name `/dev plan <slug>` (winner:
   plan.md § Adjusting).
7. `batch/` prefix absent from git-workflow § Trunk prefix set → add it
   (engine-only, no id).
8. `companions/documentation.md` sibling-duplication vs DRY → scope:
   DRY within a doc set's shared facts; variant-split duplication
   accepted (reconcile in one sentence).
9. `companions/report-template.md` hardcoded B-002/B-003 baselines →
   placeholders.
10. `companions/verification-policy.md` claims a SKILL.md pointer that
    does not exist → delete the claim.
11. `spec-reviewer-prompt.md` "finished suspiciously quickly" → drop
    (spec check is unconditional per auto.md).
12. `plan-document-reviewer-prompt.md` orphan + "Task/Step" vocabulary →
    wire into the auto plan-review path it serves, align to commit
    checkboxes; if truly unused, retire it (user gate at close).
13. `tbd-migration.md` who-executes vs `migrate.md` (winner: migrate -
    agent executes, user approves), `TASKS.md` vs `plans/tasks.md`
    naming (winner: legacy-migration's `plans/tasks.md`), archival
    optionality restored (winner: plan.md § Archival).
14. `legacy-migration.md` wrong § pointer (ID format, not Archival),
    REQ fold target = foundational `REQUIREMENTS.md` (winner: plan.md),
    no bootstrap exception for canonicalization (winner: git-workflow -
    branch + MR/PR).
15. `release.md` `.claude/release_notes_template.md` dead path → add to
    layout.md lazily or drop the reference (settle in detail).

## Dedup clusters (T-080 core, T-081 companions)

T-080: git-workflow twins single-sourced; SKILL.md per-command sections
folded into its Surface table; plan.md states each convention once;
shape-deferral clause and ~20/~30 caps single-homed; branch-plan trims
(~150w) incl. batch-definition ownership; layout.md bare tree + policy,
conventions cite plan.md; execution cadence skeleton extracted to
`branch-plan.md § Per-commit rules` with feat/fix/refactor as deltas;
finish/auto keep procedure only, rails/halts cited from branch-plan;
start/migrate shared scaffold steps single-homed; MAINTENANCE cites
rules instead of restating; rules-trio maintenance block single-homed;
audience-visibility list owned by CLAUDE.md.

T-081: untracked-claude.md owns all carve-outs (sources keep one-line
pointers); toolchain.md owns declared-commands detail; verification-
policy deduped (effort column, self-restatements); docs companions
(docs-adoption framing, report-template rule restatements); prompt files
keep justified inlines, drift removed; visual-companion.md ~400w of
self-duplication removed.

## Acceptance criteria

- [ ] All 15 contradictions resolved toward the named winners; a grep
  for each stale token (`starting-a-project`, `doc PRs`, B-002 baseline,
  dead template path) is clean.
- [ ] The 8 clusters executed; a fresh cross-file sweep finds no rule
  stated normatively in two files (justified inlines documented in the
  branch plans).
- [ ] System prose reduced >=12% (baseline 18,572 words); every capped
  file under its cap.
- [ ] Tier-1 + full test suite green; ships via the same files.

## Constraints

- Three tasks, sequential (`depends-on` chain): contradictions before
  dedup so the right copies survive; core before companions.
- Branch plans carry the full per-finding lists (self-sufficient in the
  repo).

## Open questions

- none (item 12/15 settle at detail/close per their entries)

## References

- R-035 (atomic marks - release-mark winner), R-033 (documentation
  framework), R-021/R-024 (toolset lineage).
