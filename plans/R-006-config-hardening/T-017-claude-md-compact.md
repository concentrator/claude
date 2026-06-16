task: T-017
type: refactor
depends-on: T-016

# refactor/claude-md-compact — compact CLAUDE.md, add verify-before-stating (R-006)

T-017 of `plans/R-006-config-hardening/requirements.md`. T-016 already
extracted the git prose to `rules/git-workflow.md` and left the pointer.
This task finishes the CLAUDE.md cleanup: removes the temp-files
duplication, replaces the Structured-Data section with a
verify-before-stating rule, relocates the Agent-toolchain declaration
rule, and adds the operative-only authoring rules — all keeping
CLAUDE.md ≤ 400w (`wc -w`) and `rules/claude-md.md` ≤ 200 lines.

Pre-specified wording lives in
`R-006-config-hardening/T-016-tbd-foundation.findings.md` (the R-006
follow-ups) — use it verbatim where quoted there.

Not architecture-changing: T-016 (architecture-changing) already updated
DESIGN.md for the TBD model; T-017 only relocates/renames behavior rules.

Decisions carried from `/dev plan all` review:
- The `## Agent toolchain` self-hosting block stays in CLAUDE.md but is
  **truncated** to its essential operative declaration; it grows as
  tools are defined. Only the generic *declaration rule* (the
  Session-Workflow prose) moves to `rules/claude-md.md`.
- `## Verify before stating` **subsumes** `## Structured Data / API
  parameters` (single merged section, net words out).
- The anti-rationale rule lands in **both** `rules/claude-md.md` and
  `rules/skills.md`.

- [x] Rename `## Structured Data / API parameters` → `## Verify before
      stating` in CLAUDE.md; fold the read-the-reference-first content
      into it. Wording per T-016 findings: "Before asserting a fact,
      confirm it against an authoritative source you can point to. No
      source → verify it, or say you're unsure; never present a guess as
      confirmed. Schemas, configs, API shapes: read the reference
      first." Touches: CLAUDE.md.
- [x] Remove `## Temporary Files` from CLAUDE.md (duplicate of
      `rules/planning.md § Where things live`); relocate the unique
      "never use `docs/`" guard into that section. Touches: CLAUDE.md,
      rules/planning.md.
- [x] Move the Agent-toolchain *declaration rule* (Session-Workflow
      prose, "Projects run via `/dev auto` declare … toolchain") out of
      CLAUDE.md into `rules/claude-md.md`; truncate the `## Agent
      toolchain` self-hosting block to its essential operative
      declaration (to grow as tools are defined). Verify the
      `skills/delegating-to-agents/toolchain.md` cross-ref still resolves
      (grep). Touches: CLAUDE.md, rules/claude-md.md.
- [x] Add the anti-rationale rule to `rules/claude-md.md`: operative
      instructions only; no rationale, framing, or transplanted
      conversational wording (the "why" goes in requirements/DESIGN).
      Touches: rules/claude-md.md.
- [x] Add the same anti-rationale rule to `rules/skills.md § Content`.
      Touches: rules/skills.md.
- [x] Add the operative-only compaction criterion to `rules/claude-md.md
      § Content`: strip rationale/framing, operative-only — not merely
      `wc -w` ≤ 400. Touches: rules/claude-md.md (verify `wc -l` ≤ 200).
- [x] Write the rule-preservation mapping into
      `T-017-claude-md-compact.findings.md` (every CLAUDE.md rule touched
      → kept-in-place / relocated-where / explicitly-dropped), mirroring
      the T-016 mapping-table format. Touches: findings file.
- [x] Complete the branch: re-review CLAUDE.md + touched rules across all
      commits, confirm `wc -w CLAUDE.md` ≤ 400 and `wc -l
      rules/claude-md.md` ≤ 200, grep-sweep moved references for
      staleness, verify the rule-preservation mapping is complete
      (nothing dropped silently), cleanup, mark plan complete, commit.
