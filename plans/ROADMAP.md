# Roadmap

Initiative index. Items: `R-001: description`; each entry owns
`R-XXX-<slug>/` with its `requirements.md`. A checkbox closes per
`skills/dev/plan.md § Approval and closure`.

- [x] R-001: Restructure planning layout - indexes at `.claude/` root,
      per-roadmap-entry plan dirs, task-id-prefixed branch plans, batch
      manifests dir.
- [x] R-002: Batch integration flow - `batch/B-XXX` branch, enforced
      checkpoint report, full-strength batch review, push + MR at accept.
- [x] R-003: Flatten the requirement level into roadmap entries -
      R-rooted chain with in-dir `requirements.md`, single closure point
      on verified acceptance criteria.
- [ ] R-004: Parallel batch execution for DEV auto mode - run
      independent member branches concurrently between checkpoints.
- [x] R-005: Trim agentic verification cost - verification-depth policy,
      per-role model routing, branch-close folding, slimmer dispatch
      prompts, context diet for always-loaded rules.
- [x] R-006: Trunk-based, lean, self-enforcing config - protected
      `main`, CI-gated PRs, batch as the delivery unit, tag-on-trunk,
      CI + pre-push self-enforcement.
- [ ] R-007: Per-batch complexity level - `normal`/`high` dial over the
      verification levers (model tier, spec-check skip, close-folding,
      effort, loop rigor); attaches to R-006's batch unit.
      (stub - shape via `/dev plan R-007`)
- [x] R-008: Wallarm reference skill - superseded: the Wallarm reference
      skills live in the `skills/` repo, not `~/.claude/skills/`.
- [x] R-009: Adopter-project TBD migration - already-DEV pre-TBD
      projects migrate to PR-only delivery; `start` establishes a
      protected trunk.
- [x] R-010: Frictionless planning-PR delivery - `plan/` MR/PRs
      auto-merge on a green gate (native host or agent fallback).
- [x] R-011: Delivery cadence - one branch = one coherent unit of work;
      VIBE applies-then-waits and delivers at a work boundary.
- [x] R-012: Writing quality - global convey-intent writing rule +
      Tier-2 review gate.
- [x] R-013: JS file-naming convention - `rules/js.md` kebab-case
      (PascalCase for class files) + a copyable CI filename check.
- [x] R-014: Per-initiative task indexes - each R-dir owns a
      lazily-created `tasks.md`; ROADMAP stays the cross-R index.
- [x] R-015: Embeddable self-contained DEV toolchain - superseded by
      R-021 (no vendoring).
- [x] R-016: Lean DEV planning & delivery - two planning rounds,
      right-sized multi-commit tasks, size-scaled close review.
- [x] R-017: migrating-to-dev legacy detection - inventory runs
      regardless of mode; legacy schemas detected and
      guided-canonicalized.
- [x] R-018: Bootstrap exception defined narrowly - only the initial
      `main`-creating commit before protection; `start` protects after
      it; migration delivers via branch + MR/PR.
- [x] R-019: Vendor embed onto a non-empty `.claude/` - mooted by R-021
      (no vendoring).
- [x] R-020: Consolidate branch-close into `branch-plan.md` - absorbed
      by R-021 (`finish.md`) and R-024 (verify gate).
- [x] R-021: Isolated, self-contained DEV toolset - the `/dev` router
      over inert `skills/dev/` mode files; trunk discipline via the
      branch-guard hook; distribution via skill precedence, no
      vendoring.
- [x] R-022: Config conventions & guardrails - secrets gatekeeper hook,
      code-size gates, scaffold required-files, routine-commands
      convention.
- [x] R-023: Feature documentation layer - `.claude/docs/` per-feature
      docs between `DESIGN.md` and code; doc-first execution step +
      doc-to-code reconcile at close.
- [x] R-024: DEV confirmation and outcome gates - plan approval never
      auto-starts code; `finish` verifies before merge options; precise
      branch guard.
- [ ] R-025: Explicit review checklist - a review.md-style checklist
      (Correctness, Security, Performance, Maintainability) with
      severity-tagged output across the reviewer agent, the
      `receiving-code-review` skill, and the `finish` close-review.
      (stub - shape via `/dev plan R-025`)
- [x] R-026: Writing conventions - em dashes banned in every tracked
      file (Tier-1 check + one-time sweep); prose style as Tier-2
      review criteria.
- [x] R-027: Conflict-free Tier-2 ledger - per-commit stamp store
      replaced the appended ledger; retired with the ledger by R-029.
- [x] R-028: Self-enforcement layer hygiene - `scripts/test/run-all.sh`
      wired into CI and pre-push, blocking.
- [x] R-029: Retire the Tier-2 ledger - gate, store, and stamp step
      deleted; the five-concern Tier-2 review stays a branch-close step.
- [x] R-030: Docs-layer routing & adoption - CLAUDE.md doc-lookup
      routing + the migrate docs-adoption audit.
- [x] R-031: Standalone `/dev docs` command - docs audit/build/refresh
      runnable on any project (`companions/docs-adoption.md`).
- [x] R-032: Feature-doc detail bar - full input surface, provenance
      markers, tested examples (`layout.md § Docs`).
- [x] R-033: Documentation conventions (Diataxis) - global framework +
      independent-agent per-claim verification gate
      (`companions/documentation.md`); supersedes R-023/R-030/R-031/
      R-032.
- [x] R-034: Branch-guard foreign-path scope - deny only paths inside
      the owning repo and not ignored; fail-open.
- [x] R-035: Atomic branch-close bookkeeping - task/R marks ride the
      final commit and land with the merge; close-out PR only for
      run-dependent criteria.
- [x] R-036: Branch-guard target scope - writes judged by the target
      path's owning repo, not the session cwd.
- [x] R-037: Branch-guard compound detection - the branch-create
      exemption covers `git -C` option groups.
- [x] R-038: Declared state-check command - one allowlisted,
      JSON-emitting MR/PR state check per host.
- [x] R-039: Single-home the /dev system - one owner per rule with
      pointers; twins single-sourced; execution files as cadence deltas.
- [ ] R-040: Supervisor-orchestrated autonomous DEV - a local
      supervisor agent, in its own context, orchestrates planned-task
      execution running in sessions on a remote machine: reviews and
      merges MRs within declared capability bounds, verifies task/doc
      correctness at boundaries, and runs the `/dev auto` cadence; the
      user syncs with the supervisor periodically and resolves raised
      issues. Stub - shape later.
- [x] R-041: Docs reconcile (this repo) - apply the docs lifecycle to
      the repo that authored it: archive the closed initiatives out of
      `plans/`, compact `ROADMAP.md` and open plan artifacts to state
      the present, verify `check-plan-integrity` across the move, and
      add the accretion check to the Tier-1 suite. Mirrors the
      adopter-side reconcile pattern.
