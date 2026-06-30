# T-031 findings

- [ ] AC4 (embedded CI subset) descoped to a new task **T-035**: the
  `scripts/ci/check-*.sh` checks assume this repo's self-hosting layout
  (artifacts at the repo root) and depend on adopter-provided `DESIGN.md`
  / `plans/` that don't exist at vendor time. Adapting them to the adopter
  `.claude/`-rooted layout is a distinct deliverable, not a copy. Promote
  to T-035 under R-015 at branch close. AC4 stays open on R-015 until then.
- [ ] CLAUDE.md backbone is minimal (mode summary + always-on rule import).
  Could be enriched with generic writing/communication norms; the adopter
  customizes their own CLAUDE.md. Triage at close.
- [ ] `--source <ref>` is parsed but the vendor copies from the current
  checkout (the operator checks out the ref first, per Decision B). Wiring
  an explicit `git archive`/checkout of the ref could be a later refinement.
