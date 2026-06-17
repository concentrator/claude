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
- [ ] R-010: Frictionless planning-PR delivery — merge-friendly ledger
      (`maintenance.jsonl` + `.gitattributes merge=union`, no more
      concurrent-PR conflicts) + `plan/` PRs auto-merge on a green gate
      (native host where available; agent `gh`/`glab` fallback).
      (approved 2026-06-17)

<!-- R-004's requirements are approved: pending — tasks spawn once
     approved. Sequence after R-005: concurrency would multiply an
     unoptimised verification routine. -->
