# Verification depth policy

Companion to `SKILL.md`, consulted by the `/dev auto` controller when
deciding how much verification each commit and batch warrants. The aim
is to trim agentic verification cost (R-005) without dropping below the
floor that keeps the default branch safe. Sections below define the
knobs the controller has and when to apply them.

## Effort mechanics

Reasoning effort is **session-level only; per-dispatch routing degrades
to model choice.** No surface in this repo exposes a per-subagent effort
field: an agent definition's frontmatter carries `model:` (and `name:`,
`description:`) but no effort key, and the Task/Agent dispatch surface
exposes a `model` override (`sonnet`/`opus`/`haiku`/`fable`) with no
effort parameter. Effort is fixed for the whole session by the
`effortLevel` setting. So when the controller wants a cheaper or deeper
check for a given dispatch, the only lever it actually controls is which
model that subagent runs — routing encodes a model per role and inherits
the session effort.

Evidence:

- `agents/code-reviewer.md` frontmatter — keys present: `name`,
  `description`, `model` (value `inherit`). No effort key.
- `settings.json` — `effortLevel: "high"`: a top-level session/global
  setting, not scoped to any dispatch.
- `skills/delegating-to-agents/implementer-prompt.md` — the Task-tool
  dispatch template passes `description` and `prompt` only; no effort
  field. The Agent tool's sole per-dispatch override is `model`.

## Mechanical commits

A commit item is **mechanical** if and only if both conditions hold,
evaluated from the plan-item text alone, before dispatch:

1. **File set ≤ 2, explicitly named** — the item text names at most two
   files to touch (by path or filename). Unnamed, implied, or
   wildcard-described files do not count toward the limit and void the
   classification.
2. **Complete spec** — the item states a testable outcome and contains
   no unresolved design choices. A testable outcome means a reader can
   write a failing check before seeing the implementation. An unresolved
   design choice is any decision the implementer must make that the item
   text does not settle.

**Post-implementation guard:** after the implementer reports back, the
controller checks the "Files changed" line in the report. If the set of
files the implementer actually touched exceeds the files named in the
plan item, the mechanical classification is void and the spec check runs
after all — regardless of how the item read before dispatch.
