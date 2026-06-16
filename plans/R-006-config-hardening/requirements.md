---
approved: 2026-06-14
kind: refactor
status: done 2026-06-16
---

# R-006: Trunk-based, lean, self-enforcing config

## Current state

- `CLAUDE.md` (~545w) mixes core AI-behavior rules with git mechanics
  and a repo-specific `## Agent toolchain` block. Git rules ("never
  push to main" + its exceptions) are restated across `CLAUDE.md`,
  `dev/SKILL.md`, `planning.md`, `branch-plan.md`.
- No `main` protection. Planning artifacts and `~/.claude` config
  commit directly to `main`; manual task branches merge to *local*
  `main`; only batches reach origin via MR, and post-merge closure
  commits land directly on `main`. The branching model is implicit and
  inconsistent, and partially reinvents Git Flow's long-lived `develop`.
- `## Temporary Files` is mistitled (it describes persistent
  planning-file locations — a dup of `planning.md § Where things live`,
  nothing about `tmp/`). `## Structured Data / API parameters` does not
  curb Claude's assume-then-state tendency.
- `## Agent toolchain` is low-signal / misplaced (SKILL caps are
  rule-enforced anyway; agent-setup belongs in a skill; the push
  rule + exception is redundant).
- `dev/SKILL.md` (~366w, near its 400 cap) opens describing **VIBE**
  (the non-DEV default), carries a duplicated `## Branching`, and splits
  one act (`R`, `R-XXX`) into two plan-targets.
- Nothing enforces hygiene: caps, stray files, and stale references can
  drift silently; no MR gate.

## Desired state

Anchor the whole git side to **Trunk-Based Development** (GitHub-Flow
form) rather than a bespoke scheme:

- `main` is the **protected, always-releasable trunk**. Every change
  reaches it through a **short-lived branch + CI-gated PR** — never a
  raw push, never a local merge. No long-lived branches exist. In
  ~/.claude this is enforced three ways: origin branch protection
  (hard), a pre-push hook (fast local feedback), and the CI gate.
- **Coherent-delivery invariant:** every PR to `main` leaves it
  releasable (builds, checks pass, nothing half-wired). The three
  sanctioned techniques to honor it, chosen at planning time:
  (a) decompose so a task is itself a coherent merge; (b) group coupled
  tasks into one batch; (c) inert landing / branch-by-abstraction
  (land dormant, wire up last).
- **Batch = the universal delivery unit:** 1+ tasks that must land
  together, shipped as exactly one CI-gated PR. A lone coherent task is
  a degenerate batch — its task branch *is* the PR (no integration
  branch). Coupled tasks integrate on a short-lived `batch/B-XXX` →
  one PR. **Mode is orthogonal:** delivery is uniform (integration
  branch → one PR); only *verification* differs — auto runs the agentic
  checkpoint (report + amortized top-model review + accept/reject),
  manual uses human PR review. `depends-on` / "not independently
  functional" at planning drives batch membership.
- **Planning artifacts live on `main`**, updated via short-lived doc
  PRs (auto-mergeable on a green gate): creating an initiative is a doc
  PR adding the `ROADMAP` entry + the R-dir `requirements.md`
  (`requirements.md` and the `ROADMAP`/`TASKS` index edits are separate
  commits). Task `[x]` marks ride the delivering batch PR; R-closure +
  release marks ride a small close-out PR.
- **Batch lifecycle (TBD):** pre-flight cuts `batch/B-XXX` off latest
  `main` + sets `pre-B-XXX`; members integrate on it; [auto] close
  phase runs review + fixes + green + `B-XXX.report.md`; bookkeeping
  (member `[x]`, batch `[x]`) commits on the batch branch; sync latest
  `main` in; **accept → CI-gated PR `batch/B-XXX → origin/main`** (the
  one delivery), `pre-B-XXX` deleted on accept; reject → delete the
  branch (premature marks gone). No `plan/R-XXX` branch anywhere.
- **Git rules** consolidated into `rules/git-workflow.md` (branching,
  commit/MR style, the single "all changes reach `main` via CI-gated
  PR" rule), referenced once near the top of `CLAUDE.md`. No git rule
  stated twice.
- **Releases: tag-on-trunk.** `main` is always releasable; a release
  tags `main` at a chosen commit — no release branch. `release-vX.Y.Z.md`
  plan + per-batch checkboxes remain.
- `CLAUDE.md` ≤ 400w — only global content (AI-behavior tuning +
  project-relevant rules) + the git-workflow pointer; specifics in
  `rules/*`.
- `dev/SKILL.md` ≤ 300w — accurate DEV opener (strict, spec-driven,
  manual + auto), no `## Branching`, `R`/`R-XXX` merged into one plan
  step (still separate commits per artifact), batch-aware manual mode.
- Mistitled sections fixed: temp-files dup removed; a renamed behavior
  section adds "verify before stating; don't assume / approximate /
  pre-conclude." The Agent-toolchain *rule* moves into
  `rules/claude-md.md`.
- **Self-enforcement (~/.claude):** `rules/*` define rules,
  `maintenance.md` is the pre-MR AI review (compliance + cross-file
  integrity + cleanup + reference freshness), `maintenance.json` is the
  ledger, a GitHub CI pipeline + pre-push hook gate `main`. Two tiers:
  mechanical CI checks + the AI review that stamps `maintenance.json`.

## Invariants

- No behavioral rule loses meaning in the compaction/extraction — every
  rule in `CLAUDE.md` / `dev` / `planning.md` / `branch-plan.md`
  survives (relocated), unless dropping it is an explicit, listed
  decision. A rule-preservation mapping is recorded.
- The DEV chain (R → T → batch → PR), approval gating, and closure
  semantics are unchanged except for *where artifacts live* and that
  delivery is via PR, not direct push/local merge.
- The agentic verification model (checkpoint, report, adversarial
  review, verification-policy tiers) is preserved; batch reject-safety
  preserved — rejecting deletes the un-merged `batch/B-XXX` with its
  premature marks.
- R-005 path-scoped rule loading and the word caps are unaffected.
- `main` is releasable (coherent) after every merge.

## Scope

- Edit: `CLAUDE.md`, `skills/dev/SKILL.md`, `rules/planning.md`
  (§ Where plans live in git → PR/trunk model), `rules/branch-plan.md`
  (§ Agentic execution → batch as the universal delivery unit, TBD
  lifecycle, PR delivery), `rules/claude-md.md`, `MAINTENANCE.md`,
  `DESIGN.md`; skills: `writing-plans`, `finishing-a-branch` (mode-aware
  PR delivery to origin, no local `main` merge),
  `delegating-to-agents` (checkpoint → PR to origin), `dev` (batch-aware
  manual, merged plan step), `starting-a-project`, `migrating-to-dev`,
  `release` (tag-on-trunk).
- Create: `rules/git-workflow.md`, `maintenance.json`,
  `.github/workflows/…`, a pre-push hook.
- Global rule changes apply to all DEV projects; enforcement infra is
  built for **~/.claude only**.
- Out of scope: adopter-project infra (own later initiative); the
  unrelated `settings.json` model line.

## Acceptance criteria

- [x] `CLAUDE.md` ≤ 400w; `dev/SKILL.md` ≤ 300w (`wc -w`).
- [x] All git rules live in `rules/git-workflow.md`, referenced once in
      `CLAUDE.md`; grep finds no git-policy rule duplicated elsewhere.
- [x] TBD documented: `main` = protected trunk; every change via a
      short-lived branch + CI-gated PR; no long-lived branches; "all
      changes reach `main` via PR" stated once; in ~/.claude enforced at
      origin + pre-push hook + CI.
- [x] Coherent-delivery invariant stated with the three techniques;
      coupled tasks (`depends-on`) default to one batch.
- [x] Batch defined as the universal delivery unit (1+ tasks → one PR);
      lone task = degenerate batch; mode orthogonal (delivery uniform,
      verification differs).
- [x] Batch closing: members → `batch/B-XXX` (if >1) → CI-gated PR to
      origin `main`; bookkeeping on the batch branch; reject deletes the
      branch (marks gone); `pre-B-XXX` deleted on accept.
- [x] Manual tasks deliver via their own CI-gated PR to origin (no local
      `main` merge); `finishing-a-branch` PR target is mode-aware.
- [x] Planning artifacts reach `main` only via short-lived doc PRs;
      `requirements.md` vs `ROADMAP`/`TASKS` stay separate commits;
      R-closure + release marks ride a close-out PR.
- [x] Releases tag-on-trunk; the `release` skill tags `main` with no
      release branch; `release-vX.Y.Z.md` retained.
- [x] Agent-toolchain declaration rule lives in `rules/claude-md.md`;
      gone from `CLAUDE.md` prose.
- [x] Temp-files duplication removed; a behavior section enforces
      verify-before-stating.
- [x] `dev/SKILL.md` opens with an accurate DEV description; no
      `## Branching`; `R`/`R-XXX` merged into one plan step.
- [x] `maintenance.md` defines the Tier-2 AI review; the
      `rules/*` ↔ `maintenance.md` ↔ `maintenance.json` relationship is
      documented.
- [x] GitHub CI hard-fails a PR on: cap violation, stray/unindexed
      file, plan-integrity break, `TODO`/`FIXME`/`XXX` in code, expired
      reference, or missing `maintenance.json` confirmation for the head
      commit (SHA-keyed).
- [x] A rule-preservation mapping is recorded (every prior rule →
      kept / relocated / explicitly dropped).
- [x] `DESIGN.md` updated for the TBD model + enforcement architecture.

## Constraints

- Bootstrap: R-006's own planning predates the new model, so it
  scaffolds and ships under the *current* rules (direct-to-main plans);
  TBD applies from the next initiative / once R-006 merges.
- Global rules must not hardcode GitHub specifics (adopters may be
  GitLab); `maintenance.json` must be model-free CI-checkable and keyed
  on commit SHA (not a host-specific MR id).
- Skill word caps hold (`dev` ≤ 300, others per `skills.md`);
  compaction must net words out.
- Releases are tag-on-trunk only — no release branch.

## Open questions

- Reference-expiry convention: what syntax marks a time-bound reference
  so CI can flag expiry mechanically?
- Pre-push hook distribution: tracked dir via `core.hooksPath`, vs
  per-clone install?
- Index-edit cadence: do `ROADMAP`/`TASKS` open/create edits auto-merge
  as their own immediate doc PR, or ride the requirements PR?
  (Trunk-sync resolves conflicts either way.)

## References

- Trunk-Based Development / GitHub Flow / GitLab Flow — the production
  standard this anchors to; Git Flow (long-lived `develop`) is the
  pattern deliberately *not* used.
- This session's user input (R-006 seed).
- `rules/planning.md § Where plans live in git` (the rule being
  changed), `§ Where things live`.
- `rules/branch-plan.md § Agentic execution` (the batch model, now
  generalized to the universal delivery unit).
- R-005 (context diet — caps / path-scoping this builds on).
- `skills/delegating-to-agents` (checkpoint + auto-permissions +
  friction-hook patterns — CI / maintenance precedent).

## Closure verification (2026-06-16)

One-line evidence per acceptance criterion (T-016–T-019, all merged):

1. CLAUDE.md 250w, dev body 283w (`wc -w`). [T-017/T-018]
2. Git rules in `git-workflow.md`, referenced once in CLAUDE.md; grep
   finds no git-policy rule duplicated in skills. [T-016/T-018]
3. `git-workflow.md § Trunk`/`§ Enforcement` document the protected
   trunk, CI-gated-PR-only flow, and origin+hook+CI enforcement. [T-016]
4. `git-workflow.md § Coherent delivery` states the invariant + three
   techniques; coupled tasks default to one batch. [T-016]
5. `branch-plan.md § Agentic execution` defines batch as the universal
   delivery unit, lone task = degenerate, mode orthogonal. [T-016]
6. Same § documents the batch lifecycle (members → `batch/B-XXX` → PR;
   reject deletes branch; `pre-B-XXX` deleted on accept). [T-016]
7. `finishing-a-branch` delivers via CI-gated PR (no local merge),
   mode-aware. [T-018]
8. `planning.md § Where plans live in git` documents doc-PR delivery +
   separate commits + close-out PR. [T-016]
9. `release` skill tags trunk, no release branch; `release-vX.Y.Z.md`
   retained. [T-018]
10. Agent-toolchain declaration rule in `claude-md.md`, gone from
    CLAUDE.md prose. [T-017]
11. Temp-files dup removed; `## Verify before stating` added. [T-017]
12. dev/SKILL.md opens with DEV; no `## Branching`; `R`/`R-XXX` merged.
    [T-018]
13. `MAINTENANCE.md § Tier-2 AI review` defines the review + the
    `rules/*`↔`MAINTENANCE.md`↔`maintenance.json` relationship. [T-019]
14. `scripts/ci/*` cover all six gates, each fail-path negative-tested;
    `run-all` exits non-zero on any; CI green on PR #5 (the job runs
    `run-all`). [T-019]
15. Rule-preservation mappings recorded in the T-016 and T-017 findings
    files. [T-016/T-017]
16. DESIGN.md has `## Git & delivery model` + `## Self-enforcement`.
    [T-016/T-019]

Operational follow-up (not an R-006 deliverable): enable origin branch
protection in GitHub settings (require the `tier1` check, restrict direct
pushes to `main`) so the documented host-side enforcement is active.
