---
approved: 2026-08-11
kind: feat
---

# R-045: DEV artifacts root

## Motivation

Claude Code guards `<project>/.claude/**`: edits there need interactive
confirmation, and the guard sits above the permission allowlist - an
explicit `Edit(//<project>/.claude/plans/**)` allow rule does not clear
it.

Every DEV planning artifact lives under `.claude/` (`layout.md
§ Layout`), so a headless `/dev auto` worker cannot write a checkbox, a
findings file, or `B-XXX.report.md`, and `auto.md § Checkpoint` makes
that report a precondition for accept. Auto mode therefore cannot
complete in an adopter project; manual `/dev code` survives only
because a human clears each prompt.

The guard is right: agents must not rewrite their own permissions,
hooks, or instructions. The error is that DEV put the files agents
write every run in the same directory as the files agents must never
write.

## Goals

- A declared artifacts root, default `dev/`, holding what agents
  author. Config that instructs agents stays in `.claude/` and stays
  guarded.
- The root is configurable per project, so this repo - whose artifacts
  already sit at its own root - follows the same rule as adopters
  instead of being a special case.
- `migrate` adopts an existing project onto the declared root,
  including one already on the `.claude/` layout.
- An adopter's move is planned before it is executed: the paths that
  move and the references that must follow them are written down
  first.

## Non-goals

- Relocating `.claude/` config. Settings, hooks, agents, commands, and
  project skills and rules stay where they are and stay guarded.
- Moving this repo's own artifacts. They already sit at the repo root;
  the work here edits the DEV system source that prescribes the
  convention, and relocates nothing.
- Fixing this repo's own headless case. `~/.claude` is guarded in its
  entirety, independent of the `<project>/.claude/**` rule, so no
  relocation helps; its workers run from a worktree.
- Changing the planning hierarchy, ids, or file formats. Only locations
  move.

## User experience

- A project declares its artifacts root in `CLAUDE.md § Agent
  toolchain`, beside the existing toolchain declarations. No
  declaration resolves to `dev/`.
- Skills resolve artifact paths against the declared root rather than a
  fixed `.claude/` prefix.
- `start` scaffolds a new project onto the declared root, so a fresh
  project never needs the adoption path.
- `migrate` on a `.claude/`-layout project reports the paths it will
  move and the references it will rewrite before touching anything.
- A headless worker writes plans, findings, and reports without an
  interactive prompt.

## Acceptance criteria

- [ ] A headless session writes a plan artifact and a batch report in
      an adopter-shaped fixture with no interactive prompt
- [ ] The declared root is honoured, and its absence resolves to `dev/`
- [ ] Paths under `.claude/` are unchanged and still refuse headless
      edits
- [ ] A project scaffolded by `start` runs auto mode with no adoption
      step
- [ ] `migrate` moves a `.claude/`-layout project and leaves no stale
      reference
- [ ] The move inventory exists, and each entry is either carried out
      or deferred with a stated reason
- [ ] Tier-1 green

## Constraints

- One declaration home; skills never guess the root.
- `check-plan-integrity` and `check-references` resolve the declared
  root.
- The vendor transform carries the root through to embedded copies.

## Open questions

- Do `references/` and `adr/` move with the work products or stay?
  Both are agent-written, but neither is written during a batch, so
  neither blocks auto mode.

## References

- R-040: headless workers, the case that surfaced this.
- R-044: its gate resolves paths this initiative changes.
- R-015: the vendor transform that carries the convention to adopters.
- R-017: legacy migration, the sibling adoption path.
