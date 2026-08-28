# T-031 findings

- [x] AC4 (embedded CI subset) **promoted to T-035** (in R-015 `tasks.md`): the
  `scripts/ci/check-*.sh` checks assume this repo's self-hosting layout
  (artifacts at the repo root) and depend on adopter-provided `DESIGN.md`
  / `plans/` that don't exist at vendor time. Adapting them to the adopter
  `.claude/`-rooted layout is a distinct deliverable, not a copy. Promote
  to T-035 under R-015 at branch close. AC4 stays open on R-015 until then.
- [x] CLAUDE.md backbone is minimal (mode summary + always-on rule import).
  Won't-fix: the adopter customizes their own CLAUDE.md; enriching the
  backbone with generic norms is optional polish, not required.
- [x] `--source <ref>` is parsed but the vendor copies from the current
  checkout (the operator checks out the ref first, per Decision B).
  Won't-fix: matches the approved pinned-source model.
- [x] Re-run idempotency: resolved by the re-run guard (refuses an
  already-embedded target); update-in-place is T-033.
