# R-005 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` - format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-012 (R-005) [feat]: Verification depth policy in
      `delegating-to-agents` - deterministic mechanical-commit rule
      (reuse the model-selection heuristic: 1–2 files, complete spec),
      spec-check skip for that class, per-role model routing table
      (implementers → Opus 4.8 high effort; mechanical → Sonnet 4.6;
      probes → Opus 4.8; judgment + reviews → Fable 5; verify
      per-dispatch effort mechanics), and the batch-report "cost" line
      vs the B-002/B-003 baseline.
- [x] T-013 (R-005) [feat]: Fold branch-close review into batch close
      for small branches - stated, checkable "small branch" rule,
      close-phase flow + stop-condition updates in
      `delegating-to-agents`/`branch-plan.md`, full review retained
      for branches above the threshold.
- [x] T-014 (R-005) [refactor]: Slim dispatch prompts - replace the
      pasted conventions block in `implementer-prompt.md` with
      pointers to CLAUDE.md sections the agent reads itself; keep plan
      item text + criteria pasted (rails); record the rail-strength
      trade for checkpoint comparison.
- [x] T-015 (R-005) [refactor]: Context diet for always-loaded rules -
      extract `planning.md § Templates` to a companion file consumed
      by `brainstorming`/`writing-plans`, path-scope `planning.md`,
      `branch-plan.md`, `project-layout.md` to planning-artifact
      paths, fix inbound references, record `/context` per-dispatch
      baseline before/after.
