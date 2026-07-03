task: T-042
type: refactor

# refactor/relocate-adopt — brainstorm + adoption skills → skills/dev/ (R-021)

T-042 of `plans/R-021-command-toolset/`, per `manifest.md`. Copy
`brainstorming` + the adoption skills into `skills/dev/` companions, and —
uniquely for this task — **strip the embed/vendor instructions** from
migrate/start and **inline the CLAUDE.md-rules slice** into migrate.
Originals stay until cut-over/removal (T-044/T-045); **dormant**.

## Notes

- `brainstorm.md` is a **verbatim** relocation (fidelity-checkable).
  `migrate.md` and `start.md` are relocations **with edits** (embed removal
  + inline), so they won't be byte-identical to their sources — verify by
  reading, not just diffing.
- Ref rewiring per `manifest.md`: rule refs → the T-040 companions;
  sub-skill refs → short names; bundled-skill refs stay as skill refs;
  `~/.claude/…` prefixes stripped.
- Companions go to `skills/dev/companions/`.

- [ ] `skills/dev/brainstorm.md` from `brainstorming` (+ `visual-companion.md`
  and `scripts/` → `skills/dev/companions/`); rewire refs.
- [ ] `skills/dev/migrate.md` from `migrating-to-dev` (+ `legacy-migration.md`,
  `tbd-migration.md` → `skills/dev/companions/`); **remove** the
  embed/vendor instructions (`vendor-toolchain.sh` ref, embed opt-in) →
  replace with the install / `.claude/skills/dev/` model; **inline** the
  CLAUDE.md size/content slice from `claude-md`; rewire refs.
- [ ] `skills/dev/start.md` from `starting-a-project`; **remove** the embed
  opt-in → install/override note; rewire refs.
- [ ] Complete the branch: confirm **no** `vendor-toolchain`/embed refs
  remain in migrate/start, re-review refs, mark plan complete, commit.
