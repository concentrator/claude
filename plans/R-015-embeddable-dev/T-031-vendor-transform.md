task: T-031
type: feat
depends-on: T-030

# feat/vendor-transform — embed the portable DEV core (R-015)

T-031 of `plans/R-015-embeddable-dev/requirements.md` (AC2, AC3, AC4,
AC6-stamp). A `scripts/vendor-toolchain.sh` that copies the portable core
(`manifest.md`) from a pinned source into a target project's `.claude/`,
path-rewritten, `dev-*`-namespaced, self-hosting excluded, version-stamped,
with the embedded CI subset. TDD via `adding-a-feature`.

**Design decisions (approved):**
- **Namespacing** — the orchestrator stays `dev`; all other 17 embedded
  skills get a `dev-<full-name>` prefix with cross-refs rewritten (incl.
  the `dev` dispatch table). Mechanical, no name-mapping. The embed-aware
  global `dev` (T-032) routes into these `dev-*` project skills.
- **Pinned source** — the script runs from a checkout of the toolchain
  repo at the desired ref; it copies from that tree and stamps
  `git describe --tags --always`. Drift (T-033) compares the stamp to the
  source's current `git describe`.

**Scope note.** The genericization (commit 6) operates on the *copied*
files in the target, never the global skills — no skill-edit approval gate.
Script + tests are new code.

- [x] Scaffold `scripts/vendor-toolchain.sh` (arg-parse `<target>` +
  source ref) and a test harness; failing test asserts a run creates
  `<target>/.claude/`. Implement the scaffold to pass.
- [x] Manifest-driven copy + prune: test asserts the portable rules/skills
  are present and the excluded set (`js.md`, `wallarm-*`, self-hosting) is
  absent; implement the include/exclude copy from the manifest.
- [x] Path rewrite: test asserts no `~/.claude/` reference remains except
  protected ones; implement `~/.claude/…`→`.claude/…` rewrite, protecting
  `__HOME__`/`__PROJECT_DIR__` placeholders and the `writing-skills`
  example.
- [x] `dev-*` namespacing: test asserts non-orchestrator skill dirs are
  `dev-<name>` and cross-refs (incl. `dev`'s dispatch table) resolve to the
  prefixed names; implement rename + ref rewrite.
- [x] Generic `CLAUDE.md` backbone: test asserts the emitted `CLAUDE.md`
  exists with `@`-imports of the embedded rules and the VIBE/DEV mode
  summary; implement the emit (no self-hosting content).
- [x] Genericize `verification-policy.md` (in the copy): test asserts the
  repo's Models table + effort evidence are replaced with an adopter
  model-routing slot; implement.
- [x] Version stamp: test asserts a stamp file records the source
  `git describe --tags --always`; implement.
- [x] Embedded CI subset (AC4) — **descoped to T-035** (see findings): the
  checks assume this repo's self-hosting root layout; adapting them to the
  adopter `.claude/`-rooted layout (and they need adopter-provided
  `DESIGN.md`/`plans/` absent at vendor time) is a distinct task.
- [ ] Structural end-to-end: vendor into a temp dir; assert the embedded
  `.claude/` is well-formed — no residual `~/.claude/`, skills namespaced,
  backbone + stamp present, and the manifest's portable set complete.
- [ ] Document the vendor script (usage + the pinned-source/stamp model) in
  `README.md` (or `scripts/` usage doc) — doc-before-commit for the
  user-facing surface.
- [ ] Complete the branch: re-review across all commits, cleanup, confirm
  `bash scripts/ci/run-all.sh` green, triage the findings file, mark the
  plan complete, commit.
