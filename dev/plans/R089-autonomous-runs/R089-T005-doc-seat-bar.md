---
task: R089-T005
type: mnt
mode: normal
---

- [ ] A feature doc states each failure behavior once: in its input's `on
  invalid/missing` cell when one input triggers it, else in § Behavior, and
  an error code's values once in § Reference data, which the other two
  name rather than restate. Approach: `skills/dev/layout.md § Docs`, its
  skeleton's Behavior and Parameters rows and a sentence after the template.
- [ ] The doc writer and the docs verifier hold one bar, `documentation.md
  § Detail bar`: the planner lists a claim per input, output and failure
  behavior of each surface the branch's docs add or change, and the writer
  writes to that section as the verifier's check 3 reads it. Approach:
  `documentation.md § Claims`, then `agents/dev-doc-writer.md` § Steps 3.
- [ ] One rule in `documentation.md § Sources` says a doc seat may run the
  project's own code to check a sentence, leaving the checkout unchanged
  and calling no external system; the run is no source, so a mismatch it
  shows is reported, never written. Approach: the rule, then the writer's
  step 3, the verifier's step 2, gate check 1 and `docs-adoption.md § Audit`
  cite it in place of "probing nothing".
- [ ] Complete the branch: cleanup (stale/temp data), mark plan complete,
  mark the task `[x]` in the R's `tasks.md` plus any release-plan entry,
  commit, the resolved task report included. (Batch members: the task
  mark rides the batch branch.)

## Claims

- none

## Proven

- none
