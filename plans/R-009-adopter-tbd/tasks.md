# R-009 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` — format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-020 (R-009) [feat]: `migrating-to-dev` already-DEV TBD-migration
      mode — detect already-DEV (`.claude/plans/ROADMAP.md` present) vs
      fresh and route; already-DEV path reports over delivery (flag
      local-merge / direct-to-`main`; go-forward CI-gated-PR + host
      gate), structure (diff `.claude/` vs `project-layout.md`;
      non-canonical files → propose `references/` + allow recorded
      exception; flag missing/stray), and close/release (closes ride
      PRs; tag-on-trunk; archive fork-release leftovers); report detail
      in a companion file; advisory — user executes irreversible/host
      steps; no `main` history rewrite.
- [x] T-021 (R-009) [feat]: `starting-a-project` — after scaffolding,
      establish `main` as the protected trunk + instruct the PR gate
      (host-neutral), TBD-shaped from commit one; trim to stay ≤300w.
