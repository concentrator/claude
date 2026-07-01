task: T-037
type: fix
depends-on: T-031

# fix/skill-name-field — complete dev-* namespacing (R-015)

T-037 of `plans/R-015-embeddable-dev/requirements.md` (AC5). The vendor's
`dev-*` namespacing renamed skill dirs and rewrote the dispatch table but
left each `SKILL.md` `name:` frontmatter unprefixed — so embedded skills
collide with the global set by name (shadowed; user > project) and
dispatch breaks (dir ≠ `name:`). Rewrite `name:` too.

**Fix:** in the namespacing loop, after `mv skills/<name> skills/dev-<name>`,
rewrite that skill's `name: <name>` → `name: dev-<name>`. The orchestrator
`dev` is excluded (dir == name already).

- [ ] Reproduce + fix (TDD): add a test asserting every embedded skill's
  `name:` frontmatter equals its `dev-<name>` directory (red — currently
  unprefixed); then make `vendor-toolchain.sh` rewrite `name:` after the
  dir rename (green). Verify `vendor-toolchain.test` + `bash
  scripts/ci/run-all.sh` green. (closes the T-031 test gap: `name:` was
  never checked)
- [ ] Complete the branch: re-review, confirm the gate green, triage the
  findings file, mark the plan complete, commit.
