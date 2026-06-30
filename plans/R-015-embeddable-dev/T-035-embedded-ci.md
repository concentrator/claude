task: T-035
type: feat
depends-on: T-031

# feat/embedded-ci — embedded CI subset (R-015)

T-035 of `plans/R-015-embeddable-dev/requirements.md` (AC4), split from
T-031. Adapt the portable Tier-1 checks to the adopter `.claude/`-rooted
layout and ship them in the vendored output.

**Findings from the check audit (approved scope):**
- Portable (embed): `check-caps`, `check-plan-integrity`, `check-references`.
- Excluded (self-hosting / repo-scoped): `check-stray` (validates the repo
  root against `DESIGN.md`'s tree-map) and `check-todos` (scoped to this
  repo's `scripts/`, `.githooks/`). AC4 is adjusted to the portable subset.

**Design decision (approved):** parameterize the source checks with
`CLAUDE_ROOT` (`.` self-hosting — default, so this repo's gate is
unchanged; `.claude` embedded) — one source of truth, not vendor-time
rewrite.

- [ ] Parameterize the portable checks with `CLAUDE_ROOT`: `check-caps`
  (root-relative paths for `CLAUDE.md`/`DESIGN.md`/skills + make the
  orchestrator/reference name-lists `dev-`-prefix aware) and
  `check-plan-integrity` (`$CLAUDE_ROOT/plans`); confirm `check-references`
  is layout-agnostic. Test: this repo's `run-all` stays green (default
  `CLAUDE_ROOT=.`).
- [ ] Embedded gate + vendor wiring: a ledger-free `run-all` that sets
  `CLAUDE_ROOT=.claude` and runs the 3 portable checks; extend
  `vendor-toolchain.sh` to copy the 3 checks + this run-all into
  `<target>/.claude/scripts/ci/`. Test: vendor into a fixture, add minimal
  adopter artifacts (`.claude/DESIGN.md`, `.claude/plans/ROADMAP.md`,
  `CLAUDE.md`), run the embedded gate → green; `stray`/`todos`/`ledger`
  absent.
- [ ] Adjust AC4 in `requirements.md` to the portable subset and record
  the `stray`/`todos` exclusion rationale in `manifest.md`.
- [ ] Document the embedded gate in `README.md`, then complete the branch:
  re-review, confirm `bash scripts/ci/run-all.sh` green, triage the
  findings file, mark the plan complete, commit.
