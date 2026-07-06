# R-010 tasks

Task index for this initiative. Items:
`T-001 (R-001) [feat|fix|refactor]: description` - format and closure:
`rules/planning.md § Levels`. Cross-R index: `plans/ROADMAP.md`.

- [x] T-022 (R-010) [refactor]: Merge-friendly ledger - convert
      `maintenance.json` → append-only `maintenance.jsonl` (one JSONL
      line per stamp: `sha`, `reviewed`, `concerns_clear`); add
      `.gitattributes` (`maintenance.jsonl merge=union`); update
      `check-ledger.sh` to line-search (a `concerns_clear` line whose sha
      is an ancestor of HEAD, `sha..HEAD` touches only the ledger);
      `MAINTENANCE.md § Ledger` (JSONL + union + stamp-is-append);
      `DESIGN.md` tree-map + `§ Self-enforcement` note; `check-stray`
      accepts the new top-level files. Behavior preserved (still
      certifies the content tip).
- [x] T-023 (R-010) [feat]: Auto-merge policy - document in
      `git-workflow.md § Trunk` the preference order (native host
      auto-merge on a green gate where available; agent `gh`/`glab` merge
      as fallback when no branch protection; `feat`/`fix`/`refactor` PRs
      keep user review) + the agent-merge fallback step (confirm `tier1`
      green → `gh pr merge`); host-neutral; lapses to native when
      available.
