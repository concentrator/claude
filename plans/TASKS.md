# Tasks

Task index. Items: `T-001 (R-001) [feat|fix|refactor]: description` —
format and closure: `rules/planning.md § Levels`.

- [x] T-001 (R-001) [refactor]: Define the new planning layout — update
      `rules/planning.md`, `rules/project-layout.md`,
      `rules/branch-plan.md`, all skills with hardcoded `plans/` paths
      (`dev`, `writing-plans`, `delegating-to-agents` + prompts,
      `finishing-a-branch`, `starting-a-project`, `migrating-to-dev`,
      `release`, `brainstorming`), and this repo's `design.md`
      tree-map + `maintenance.md` targets.
- [x] T-002 (R-001) [refactor]: Migrate this repo's own planning
      artifacts to the new layout (`roadmap.md`/`tasks.md` to root,
      `plans/batches/`, R-dirs, task-id-prefixed plan files). Manual
      mode only — the branch moves active plan files, including its
      own; final commit relocates the remainder.
- [x] T-003 (R-001) [refactor]: Migrate wallarm-api-js plans to the new
      layout — `git mv` per REQ-002 (incl. uppercase renames per
      Amendment 1), update `B-XXX` manifest references, verify file
      count preserved. Lands as documentation commits on that repo's
      main (plans exception); run only between batches, after T-004.
- [x] T-004 (R-001) [refactor]: Uppercase the foundational docs (REQ-002
      Amendment 1) — update every reference in rules and skills, then
      `git mv` this repo's five files to `REQUIREMENTS.md`, `DESIGN.md`,
      `MAINTENANCE.md`, `ROADMAP.md`, `TASKS.md`. Runs before T-003.
- [x] T-005 (R-002) [feat]: Batch integration branch — rewrite
      `branch-plan.md § Agentic execution`: `batch/B-XXX` created at
      pre-flight, member branches merge into it (default branch
      untouched during the run), rollback = delete batch branch
      (`pre-B-XXX` tag stays as belt-and-braces), never-push rail
      narrowed to mid-batch, task checkboxes close on MR merge
      (planning.md + finishing-a-branch alignment).
- [x] T-006 (R-002) [feat]: Batch close phase + report artifact —
      `delegating-to-agents`: full-diff review of `batch/B-XXX` vs
      default on the most capable model, fixes as batch-branch commits,
      tests + lint re-run, docs coherence pass; checkpoint writes and
      presents `plans/batches/B-XXX.report.md` (per-branch + batch
      sections); accept is invalid without the report.
- [x] T-007 (R-002) [feat]: Push + MR at accept — checkpoint accept
      pushes `batch/B-XXX` and creates the MR (`glab`/`gh`, description
      from the report); explicit defer-push option; VCS-CLI toolchain
      requirement with push-only fallback; deny-rule carve-out guidance
      for `git push origin batch/B-XXX` in the permission template
      docs.
- [x] T-008 (R-003) [refactor]: Define the flattened layout in rules —
      `planning.md` (R-rooted chain, in-dir `requirements.md` template,
      initiative-time dir creation, R-closure rule with criteria
      verification + `status: done`, indexes at `plans/`, R-scoped
      batch paths, findings promotion to R stub),
      `branch-plan.md` (batch manifest/report under
      `R-XXX-<slug>/batches/`, single-R batch scope, batch-close
      bookkeeping on the batch branch), `project-layout.md` tree.
- [x] T-009 (R-003) [refactor]: Update skills to the flattened chain —
      `dev` (merge `REQ`/`REQ-XXX`/`roadmap` targets into `R`/`R-XXX`,
      net words out), `brainstorming` (entry + dir + requirements in
      one act), `writing-plans`, `finishing-a-branch` (R-closure
      criteria check; auto-mode bookkeeping onto the batch branch),
      `delegating-to-agents` + prompts (criteria wording, checkpoint
      re-verification, R-scoped batch/report paths, close phase marks
      checkboxes before the MR), `starting-a-project`,
      `migrating-to-dev`, `release`.
- [x] T-010 (R-003) [refactor]: Migrate this repo to the new layout —
      `ROADMAP.md`/`TASKS.md` → `plans/`, REQ-002/REQ-003 criteria
      stamped `status: done` under the new rule, REQ-004 superseded
      mark verified, REQ-001 → R-stub dir (`requirements.md`,
      `approved: pending`), path updates in `CLAUDE.md`, `README.md`,
      `DESIGN.md` tree-map, `MAINTENANCE.md` targets.
- [x] T-011 (R-003) [refactor]: Migrate wallarm-api-js to the new
      layout — indexes → `plans/`, REQ-001 content → its R-dir
      `requirements.md`, `plans/batches/` B-001..003 manifests +
      reports → that R's `batches/`, manifest references updated, file
      count preserved; runs only between batches.
- [x] T-012 (R-005) [feat]: Verification depth policy in
      `delegating-to-agents` — deterministic mechanical-commit rule
      (reuse the model-selection heuristic: 1–2 files, complete spec),
      spec-check skip for that class, per-role model routing table
      (implementers → Opus 4.8 high effort; mechanical → Sonnet 4.6;
      probes → Opus 4.8; judgment + reviews → Fable 5; verify
      per-dispatch effort mechanics), and the batch-report "cost" line
      vs the B-002/B-003 baseline.
- [x] T-013 (R-005) [feat]: Fold branch-close review into batch close
      for small branches — stated, checkable "small branch" rule,
      close-phase flow + stop-condition updates in
      `delegating-to-agents`/`branch-plan.md`, full review retained
      for branches above the threshold.
- [x] T-014 (R-005) [refactor]: Slim dispatch prompts — replace the
      pasted conventions block in `implementer-prompt.md` with
      pointers to CLAUDE.md sections the agent reads itself; keep plan
      item text + criteria pasted (rails); record the rail-strength
      trade for checkpoint comparison.
- [x] T-015 (R-005) [refactor]: Context diet for always-loaded rules —
      extract `planning.md § Templates` to a companion file consumed
      by `brainstorming`/`writing-plans`, path-scope `planning.md`,
      `branch-plan.md`, `project-layout.md` to planning-artifact
      paths, fix inbound references, record `/context` per-dispatch
      baseline before/after.
- [x] T-016 (R-006) [refactor]: TBD foundation — create
      `rules/git-workflow.md` (all git rules + the single "every change
      reaches `main` via CI-gated PR; never push to `main`" rule);
      rewrite `planning.md § Where plans live in git` (trunk model) and
      `branch-plan.md § Agentic execution` (batch = universal delivery
      unit, TBD lifecycle, closing flow, manual/auto delivery); repoint
      `CLAUDE.md` git refs; update `DESIGN.md` branching architecture.
      Keystone — the rest depend on it.
- [x] T-017 (R-006) [refactor]: CLAUDE.md compaction ≤400 (after T-016)
      — drop the extracted git prose, remove the `Temporary Files`
      duplication, rename `Structured Data / API parameters` + add the
      verify-before-stating rule, move the Agent-toolchain rule into
      `rules/claude-md.md`; record the rule-preservation mapping.
- [x] T-018 (R-006) [refactor]: dev/SKILL.md ≤300 + skills to TBD
      (after T-016) — DEV opener, drop `## Branching`, merge the
      `R`/`R-XXX` plan step, batch-aware manual mode; `finishing-a-branch`
      mode-aware PR-to-origin (no local `main` merge);
      `delegating-to-agents` checkpoint → PR to origin + TBD batch
      close; `writing-plans`, `starting-a-project`, `migrating-to-dev`;
      `release` → tag-on-trunk.
- [x] T-019 (R-006) [feat]: Enforcement layer (after T-016/017/018) —
      `maintenance.md` (Tier-2 AI review), `maintenance.json` (ledger),
      `.github/workflows/` (Tier-1 mechanical CI gate), pre-push hook;
      update `DESIGN.md` enforcement architecture.
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
- [ ] T-022 (R-010) [refactor]: Merge-friendly ledger — convert
      `maintenance.json` → append-only `maintenance.jsonl` (one JSONL
      line per stamp: `sha`, `reviewed`, `concerns_clear`); add
      `.gitattributes` (`maintenance.jsonl merge=union`); update
      `check-ledger.sh` to line-search (a `concerns_clear` line whose sha
      is an ancestor of HEAD, `sha..HEAD` touches only the ledger);
      `MAINTENANCE.md § Ledger` (JSONL + union + stamp-is-append);
      `DESIGN.md` tree-map + `§ Self-enforcement` note; `check-stray`
      accepts the new top-level files. Behavior preserved (still
      certifies the content tip).
- [ ] T-023 (R-010) [feat]: Auto-merge policy — document in
      `git-workflow.md § Trunk` the preference order (native host
      auto-merge on a green gate where available; agent `gh`/`glab` merge
      as fallback when no branch protection; `feat`/`fix`/`refactor` PRs
      keep user review) + the agent-merge fallback step (confirm `tier1`
      green → `gh pr merge`); host-neutral; lapses to native when
      available.
