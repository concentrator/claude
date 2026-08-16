---
task: R040-T009
type: doc
---

Branch: `doc/verification-that-can-fail`.

The pilot's central result, spread across four texts. Stage 2 ran eight
independent spec checks over eight authored docs; all passed, every
project gate stayed green, and the per-claim verification gate then
found 29 false claims and 12 provenance overstatements. The gates were
not weak - they answered questions other than the one that mattered.

- [ ] `verification-policy.md § Models`: add a capacity fallback. The
      table pins spec checks and both reviews to one model with no
      second choice, so a rate limit becomes a user escalation rather
      than a documented degrade. It happened on both pilot batches, and
      the supervisor can resolve it in neither direction - substituting
      a model defies a written rule, halting stops delivery over
      something unrelated to the work. Name the fallback and require
      the substitution be recorded, so it degrades on a path instead of
      being negotiated per batch. Note in the same place that the
      rationale for accepting a substitution does not transfer between
      batches: the first was mechanical work pinned by deterministic
      gates, the second was judgment-heavy authoring where the gates
      proved nothing.
- [ ] `verification-policy.md`: add the two rules the pilot earned.
      **Unit of check** - a check must count the unit of the thing it
      claims to check. One error recurred three times: exemptions drawn
      per file when the exempted thing was an entry, twice, then a site
      count taken per line when the counted thing was an occurrence.
      Each passed its own verification and each hid live breakage.
      **Discrimination** - an execution whose inputs cannot distinguish
      the documented behaviour from its fallback is a demonstration,
      not a verification. A cache-shape cell was marked `verified` on a
      run using a hand-written scratch file containing the very keys
      under test; three `ipGate` cells were verified against a template
      value-identical to the default. Both were corrected by re-running
      with inputs that would have differed had the claim been wrong.
      (`layout.md § Docs` already carries the discrimination rule for
      the provenance column - cite it rather than restating it.)
- [ ] `companions/documentation.md`: the verification gate reads a
      doc's `§ Parameters` preamble before its table. A doc that
      restates or narrows the provenance vocabulary passes a compliance
      check trivially, because the reviewer measures the table against
      the doc's own wording. One realigned doc declared `verified` to
      mean "a cited test or a cited line of shipped source", then
      marked four cells `verified` on source reading alone.
      `layout.md § Docs` now forbids the restatement; this is the gate
      step that catches a doc doing it anyway.
- [ ] The dispatch prompts (`companions/implementer-prompt.md` and the
      reviewer prompts): state that an agent verifies a correction
      before applying it and reports back one it judges wrong. Twice in
      stage 2 the worker's own corrections were wrong - a cited line
      range pointing at prose rather than the table it named, and a
      replacement asserting two templates are shared at every grouping
      level when one level keys on joined raw forms - and both were
      caught by fixer agents that executed the case instead of applying
      the instruction. Every layer produced errors; the ones that
      survived longest were issued with the most authority. Make the
      licence to refuse explicit rather than incidental.
- [ ] Complete the branch: `bash scripts/ci/run-all.sh` green, then mark
      this plan's checkboxes and commit. Closure is checkbox-only.
      R040-T009 does not close R-040 - T003's transport question and
      the untested multi-project criterion remain.
