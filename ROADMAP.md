# Roadmap

Business-level features over time. Items: `R-001 (REQ-XXX): description`.
A checkbox closes only when all child tasks are `[x]`.

- [x] R-001 (REQ-002): Restructure planning layout — indexes to
      `.claude/` root, per-roadmap-entry plan dirs, task-id-prefixed
      branch plans, batch manifests dir; rules, skills, and adopter
      projects migrated.
- [x] R-002 (REQ-003): Batch integration flow — `batch/B-XXX` branch,
      enforced checkpoint report artifact, full-strength batch review,
      push + MR at accept.
- [ ] R-003 (REQ-005): Flatten the requirement level into roadmap
      entries — R-rooted chain with in-dir `requirements.md`, indexes
      moved to `plans/`, batches scoped under their R-dir, single
      closure point on verified acceptance criteria, batch-close
      bookkeeping on the batch branch; rules, skills, and adopter
      projects migrated.

<!-- REQ-001 (parallel batch execution) and REQ-006 (trim agentic
     verification cost) are approved: pending — they spawn roadmap
     items once approved; sequence after R-003, which relocates the
     artifacts they build on. -->
