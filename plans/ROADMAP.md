# Roadmap

Initiative index. Items: `R-001: description`; each entry owns
`R-XXX-<slug>/` with its `requirements.md`. A checkbox closes per
`rules/planning.md § Approval and closure`.

- [x] R-001: Restructure planning layout — indexes to
      `.claude/` root, per-roadmap-entry plan dirs, task-id-prefixed
      branch plans, batch manifests dir; rules, skills, and adopter
      projects migrated.
- [x] R-002: Batch integration flow — `batch/B-XXX` branch,
      enforced checkpoint report artifact, full-strength batch review,
      push + MR at accept.
- [x] R-003: Flatten the requirement level into roadmap
      entries — R-rooted chain with in-dir `requirements.md`, indexes
      moved to `plans/`, batches scoped under their R-dir, single
      closure point on verified acceptance criteria, batch-close
      bookkeeping on the batch branch; rules, skills, and adopter
      projects migrated.
- [ ] R-004: Parallel batch execution for DEV auto mode — run
      independent member branches concurrently between checkpoints.
- [x] R-005: Trim agentic verification cost — verification-depth
      policy (spec-check skip for mechanical commits), per-role model
      routing, branch-close folding, slimmer dispatch prompts, context
      diet for always-loaded rules; no defect regression vs the
      B-002/B-003 baseline.
- [x] R-006: Trunk-based, lean, self-enforcing config — adopt TBD
      (protected `main`, CI-gated PRs, batch as the universal delivery
      unit, tag-on-trunk); git rules → `git-workflow.md`; CLAUDE.md ≤400
      + dev ≤300; mistitle + anti-assumption fixes; self-enforcement via
      `maintenance.md` + `maintenance.json` + GitHub CI + pre-push hook
      (~/.claude reference impl).
- [ ] R-007: Per-batch complexity level — `normal`/`high` dial over the
      verification levers (model tier, spec-check skip, close-folding,
      effort, loop rigor); attaches to R-006's batch unit. Sequence
      after R-006. (stub — shape via `/dev plan R-007`)
- [ ] R-008: Wallarm reference skill — single global `skills/wallarm/`
      (thin index + on-demand companion parts: hits, sessions, rules),
      consolidating the existing Wallarm skills; enforced conventions
      split into a path-scoped rule. (stub — shape via `/dev plan R-008`)
- [x] R-009: Adopter-project TBD migration — `migrating-to-dev` gains a
      mode that migrates an already-DEV, pre-TBD project (PR-only
      delivery, `.claude/` structure reconcile, tag-on-trunk
      close/release); `starting-a-project` establishes a protected trunk
      + PR gate. Grounded in `wallarm-api-js`. (approved 2026-06-16)
- [x] R-010: Frictionless planning-PR delivery — merge-friendly ledger
      (`maintenance.jsonl` + `.gitattributes merge=union`, no more
      concurrent-PR conflicts) + `plan/` PRs auto-merge on a green gate
      (native host where available; agent `gh`/`glab` fallback).
      (approved 2026-06-17)
- [x] R-011: Delivery cadence — one branch = one coherent unit of work
      (topic/session), never one atomic edit; VIBE applies-then-waits and
      delivers at a work boundary with merge confirmation; topic-switch
      flagging; DEV inherits the principle. (approved 2026-06-19)
- [x] R-012: Writing quality — global `## Writing` rule (convey intent,
      not verbatim phrasing; conventional terminology, no coined jargon;
      all output) + consolidate the anti-transplant bullets + a Tier-2
      review gate. (approved 2026-06-23)
- [x] R-013: JS file-naming convention — `rules/js.md` defines kebab-case
      (PascalCase for a class/component file matching its export;
      tool-mandated names exempt) + a copyable CI kebab-or-PascalCase
      filename check; no-MAINTENANCE.md behavior documented.
      (approved 2026-06-23)
- [x] R-014: Per-initiative task indexes — deprecate flat `plans/TASKS.md`;
      each R-dir owns a lazily-created `tasks.md` (global T-ids retained;
      ROADMAP stays the cross-R index); update rules/skills/check +
      self-migrate this repo + add the `migrating-to-dev` split step.
      (approved 2026-06-23)
- [ ] R-015: Embeddable self-contained DEV toolchain — opt-in vendor of
      the portable DEV core (skills, rules, generic CLAUDE.md, CI minus
      ledger) into a project's `.claude/`, path-rewritten and committed;
      embedded conventions take precedence (`dev-*` namespaced skills +
      embed-aware global `dev` preserving `/dev`); version-stamped with
      drift detection and re-vendor sync. (approved 2026-06-30)
- [x] R-016: Lean DEV planning & delivery — collapse planning to two
      rounds (`/dev plan R` shapes requirements+tasks under one gate,
      deferrable; `/dev plan R-XXX` details tasks+branch-plans);
      right-size tasks to multi-commit deliverables; scale branch-close
      review to size (refactor→simplify, feature/bugfix→code-review,
      mixed-or->9-commits→both); resolve findings in-branch unless
      cross-component; medium branch ~20 / batch ~30 under the
      short-lived governor. Sequence before R-015 implementation.
      (approved 2026-06-30)
- [x] R-017: migrating-to-dev legacy/non-canonical detection — mode
      detection keys on `.claude/plans/ROADMAP.md` presence, which matches
      a lowercase `roadmap.md` on a case-insensitive filesystem and
      mis-routes a legacy adoption to the Already-DEV path, skipping the
      Inventory gap-check; and neither path re-canonicalizes a
      legacy-schema `.claude/` (lowercase filenames, retired `REQ-XXX`,
      flat tasks index). Run the inventory regardless of mode; detect and
      guided-canonicalize legacy schemas. (approved 2026-07-01)
- [ ] R-018: Void the bootstrap-exception contradiction —
      `migrating-to-dev`/`starting-a-project` cite a "bootstrap exception"
      and commit direct-to-`main` after protecting it, but
      `git-workflow.md` defines no such exception and protection refuses
      the push. Define it narrowly (only the initial `main`-creating
      commit in a new repo, before protection); reorder
      `starting-a-project` (scaffold then protect); `migrating-to-dev`
      delivers adoption artifacts via a branch + MR/PR. (stub — shape via
      `/dev plan R-018`)
- [ ] R-019: Vendor embed onto a non-empty `.claude/` — the transform
      assumes a near-empty target. (a) The copy overwrites an adopter's
      existing same-named rule (it clobbered a project-specific
      `skills.md` on the wallarm skills embed); (b) the path-rewrite globs
      all of `DEST`, so it rewrites pre-existing adopter files, including
      archived history. Preserve adopter files on initial embed (as
      `--update` preserves `CLAUDE.md`); scope the rewrite to
      vendored/copied files. (stub — shape via `/dev plan R-019`)
- [ ] R-020: Consolidate branch-close into `branch-plan.md` — fold the
      `finishing-a-branch` skill into `branch-plan.md § Closing routine`
      (one on-demand owner; `git-workflow.md` stays pure policy), and
      restore the manual-verification as a **distinct blocking step**
      before the merge options (the review→push+MR regression: the verify
      offer had been bundled into `finishing-a-branch § 2` and glossed).
      Rewire all `finishing-a-branch` references (4 files), drop the skill,
      update the vendor/manifest, and re-vendor adopters. (stub — shape
      via `/dev plan R-020`)
- [ ] R-021: Command-driven, isolated DEV toolset — replace the
      skills+rules architecture with a single `/dev` command that resolves
      its instruction dir at runtime (`.claude/dev/` → `~/.claude/dev/`)
      and reads inert mode files on demand; DEV process rules + sub-skills
      become mode files (fire only inside `/dev`, no global pollution);
      trunk discipline via a PreToolUse branch-guard hook;
      `skill-creator`/`writing-skills` stay standalone. Retires R-015
      embedding (vendor/namespace/drift) and its wallarm embed; global
      install or per-project `.claude/dev/` override, no vendoring.
      (approved: pending)

<!-- R-004's requirements are approved: pending — tasks spawn once
     approved. Sequence after R-005: concurrency would multiply an
     unoptimised verification routine. -->
