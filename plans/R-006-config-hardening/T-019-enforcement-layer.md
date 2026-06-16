task: T-019
type: feat
architecture-changing: true
depends-on: T-018

# feat/enforcement-layer — two-tier self-enforcement for ~/.claude (R-006)

T-019 of `plans/R-006-config-hardening/requirements.md` — the
enforcement capstone. Builds the two-tier self-enforcement the R-006
rules (T-016) describe: a Tier-2 AI-review spec, a model-free SHA-keyed
`maintenance.json` ledger, a `.github/workflows/` Tier-1 mechanical CI
gate, and an advisory pre-push hook. Updates `DESIGN.md` with the
enforcement architecture (→ `architecture-changing`).

Constraints carried from R-006: enforcement infra is **~/.claude-only**
(adopter infra is a later initiative) — GitHub specifics are allowed in
the workflow + hook here, but global rules stay host-neutral.
`maintenance.json` is model-free, CI-checkable, keyed on commit SHA
(never a host MR id). Checks are shell/`grep`/`wc`-based (no test
runner). This is the repo's **first** CI: the workflow gates PRs
(`on: pull_request`), never re-judges the direct-to-main bootstrap
commits already on `main`.

Decisions carried from `/dev plan all` review:
- macOS APFS is case-insensitive, so a separate lowercase `maintenance.md`
  would collide with `MAINTENANCE.md`. The Tier-2 review spec + 3-gate
  prompt + `maintenance.json` schema **fold into `MAINTENANCE.md`** as a
  `## Tier-2 AI review` section; only `maintenance.json` is a new file.
- Manual mode (no `agentic:` stamp): the CI/hook/ledger infra is
  self-referential and run-dependent — fails the readiness criteria.
- Ledger keying (resolved at execution): a commit can't certify its own
  SHA, so the ledger certifies the **content tip** — review at the last
  non-ledger commit, then a final stamp commit records that tip's SHA
  touching only `maintenance.json`; `check-ledger.sh` verifies the entry
  exists, is an ancestor of `HEAD`, and `<sha>..HEAD` touches only the
  ledger. Adds a final stamp commit (14).

Open-question resolutions (R-006): reference-expiry marker
`<!-- expires: YYYY-MM-DD -->` (markdown-invisible, greppable); pre-push
hook distributed via tracked `.githooks/` + `core.hooksPath`;
index-edit PR cadence is a `planning.md` policy, **deferred** (T-019
enforces integrity, doesn't set cadence).

Each mechanical check is a standalone `scripts/ci/*.sh` script — one
source of truth, runnable locally, from the workflow, and from the hook;
"tested" by dry-run against the current tree (noted per item).

- [x] Add a `## Tier-2 AI review` section to `MAINTENANCE.md` — the
      review's four concerns (compliance, cross-file integrity, cleanup,
      reference freshness) and the `rules/*` (define) ↔ `MAINTENANCE.md`
      (the AI review) ↔ `maintenance.json` (the ledger it stamps)
      relationship. Verify caps; grep that all three are cross-linked.
- [x] Add the 3-gate "prune dead prose" prompt to that section (per
      T-016 findings): for every sentence — (1) accurate and sensible in
      context? (2) valuable in any real scenario? (3) would behavior
      change if removed? Fail any → cut; propose the fix. Touches:
      MAINTENANCE.md.
- [ ] Add `maintenance.json` + document its schema in `MAINTENANCE.md` —
      model-free object keyed by head commit SHA: `{ "<sha>": {
      "reviewed": "YYYY-MM-DD", "concerns_clear": true } }`; seed with the
      current head. Verify `jq -e .` parses. Touches: maintenance.json,
      MAINTENANCE.md.
- [ ] Add `scripts/ci/check-caps.sh` — enforce declared caps (CLAUDE.md
      ≤ 200 lines AND ≤ 400 words; `dev/SKILL.md` ≤ 300w; every
      `skills/**/SKILL.md` per its class; `description` ≤ 12 words;
      DESIGN.md ≤ 1000w). Exit non-zero listing violators. Verify:
      dry-run green against current tree.
- [ ] Add `scripts/ci/check-stray.sh` — flag tracked files absent from
      the DESIGN.md tree-map / expected layout, respecting `.gitignore`
      (`git ls-files`). Verify: dry-run green; scratch-test a junk file
      yields non-zero.
- [ ] Add `scripts/ci/check-plan-integrity.sh` — plan referential
      integrity per `planning.md` (every `T-XXX` → existing R; branch
      plan `task:`/`depends-on:` resolve; no closed/missing parent).
      Verify: dry-run green against current `plans/`.
- [ ] Add `scripts/ci/check-todos.sh` — hard-fail on `TODO`/`FIXME`/`XXX`
      in code (scripts/hooks only), excluding rule/skill prose that names
      the tokens (`branch-plan.md`, `skills.md`, this script). Verify:
      dry-run green.
- [ ] Add `scripts/ci/check-references.sh` + document the expiry syntax
      in `MAINTENANCE.md` — scan rules/skills/docs for dead path refs and
      expired `<!-- expires: YYYY-MM-DD -->` markers (fail if today >
      date). Verify: dry-run green; scratch-test a past date yields
      non-zero. Touches: scripts/ci/check-references.sh, MAINTENANCE.md.
- [ ] Add `scripts/ci/check-ledger.sh` — find a `concerns_clear: true`
      entry in `maintenance.json` whose SHA is an ancestor of `HEAD` and
      whose `<sha>..HEAD` diff touches only `maintenance.json`; fail if
      none. Verify: scratch fixture entry for the current tip passes;
      missing entry fails.
- [ ] Add `.github/workflows/ci.yml` — `on: pull_request` only; run each
      `scripts/ci/*.sh` (via an aggregator `scripts/ci/run-all.sh`),
      failing the PR on any non-zero exit. Read the GitHub Actions schema
      reference before writing; validate with `actionlint` if available.
      True green is run-dependent (first real PR) — see R-006 closure.
- [ ] Add `.githooks/pre-push` + install note — run `scripts/ci/run-all.sh`
      (fast subset), print the `--no-verify` bypass hint, exit non-zero on
      failure; distribute via tracked `.githooks/` + a one-line `git
      config core.hooksPath .githooks` note in `MAINTENANCE.md`. Verify:
      run the hook script directly, green. Touches: .githooks/pre-push,
      MAINTENANCE.md.
- [ ] Update `DESIGN.md` — add `## Self-enforcement`: the two tiers
      (Tier-1 mechanical CI via `scripts/ci/*` + `.github/workflows/`;
      Tier-2 AI review via `MAINTENANCE.md`), the SHA-keyed
      `maintenance.json` ledger, the gate list, the advisory pre-push
      hook; add `maintenance.json`, `scripts/ci/`, `.github/`,
      `.githooks/` to the Components list + tree-map; note ~/.claude-only
      scope. Verify `wc -w` ≤ 1000; tree-map matches `git ls-files`.
- [ ] Content tip: re-review docs across all commits; run
      `scripts/ci/run-all.sh` green (except the ledger check, stamped
      next); run the 3-gate Tier-2 review over the new files; triage the
      findings file; cleanup; mark the plan complete; commit. This is the
      tip the ledger certifies.
- [ ] Ledger stamp: write the `maintenance.json` entry for the content
      tip's SHA (`reviewed`, `concerns_clear: true`); this commit touches
      only `maintenance.json`. Confirm `scripts/ci/run-all.sh` green
      including `check-ledger.sh`. Hand off to `finishing-a-branch`.
