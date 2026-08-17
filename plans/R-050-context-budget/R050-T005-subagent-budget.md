---
task: R050-T005
type: doc
depends-on: R050-T003
---

# R050-T005 - subagent dispatch budget

Branch: `doc/subagent-budget`.

Two thirds of subagent cost is structural: the static prefix re-paid on
every call, and file reading the dispatch could have avoided by naming
the files. `auto.md § Per branch` already forbids the implementer from
reading plan files, which is why its reads are source, not plans - so
the lever is naming the source.

The budget routes an over-run into an existing stop condition rather
than inventing one: `NEEDS_CONTEXT` already halts and reports
(`branch-plan.md § Stop conditions`).

- [ ] `companions/implementer-prompt.md`: a tool-call budget in the
      dispatch template, with the instruction that an implementer which
      cannot finish inside it reports `NEEDS_CONTEXT` naming what it
      still needs, rather than continuing. Cross-reference the
      governor's subagent tier (T003) so the two numbers are read
      together.
- [ ] `companions/implementer-prompt.md` and `auto.md § Per branch`:
      the dispatch carries the explicit file list the commit item
      touches, alongside the item text and parent-chain context it
      already passes. State the fallback - an item whose file set
      cannot be named is the mechanical predicate's own signal
      (`companions/verification-policy.md § Mechanical commits` voids
      the classification on unnamed files), so it dispatches without a
      list and keeps the full spec check.
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: run the comprehension check
      (`companions/verification-policy.md § Comprehension check`) on
      one stamped plan to confirm the changed dispatch still gives a
      cold-context agent what it needs - this dispatches a subagent, so
      clear it with the user at close - then re-review docs across all
      commits, cleanup (stale/temp data), mark plan complete, commit.
