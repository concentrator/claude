---
approved: pending
kind: mnt
---

# R088: Native first

## Goal

DEV runs fast and steady on Claude Code's native behavior and features,
with this repository as a light guardrail. Where a rule overrides a
default, a native setting, hook, tool or check carries its intent
instead, or the rule aligns with the default.

## Inputs and outputs

- Input: Claude Code's current defaults and documented features, and
  this repository's instructions, rules, skills, agents, hooks and
  settings.
- Output: each week's audit findings, as backlog lines in this
  initiative's `tasks.md`.

## Outcomes

1. No rule tells the model to prevail over a harness instruction; where
   the two meet, a setting, hook or check carries the intent.
2. A run keeps no record that compaction, the transcript, git or the
   task report already holds.
3. A seat with follow-up work is continued, not replaced by a fresh one.
4. Native permission modes, settings and hooks settle permissions; no
   script maintains a rule set the active mode ignores.
5. Reviews use the bundled review commands, and a change is reviewed once.
6. A small change is planned and approved in one session and delivered
   in one MR/PR.
7. Waiting on CI or an agent uses a background notification, never polling.
8. A seat loads only the text its step needs.
9. A weekly cloud routine audits the repository against the current
   defaults and docs and opens a plan MR/PR adding each new finding as a
   backlog line here; a finding already listed is not added again.
