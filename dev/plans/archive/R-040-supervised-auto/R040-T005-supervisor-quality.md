---
task: R040-T005
type: doc
---

# R040-T005 - supervisor quality acceptance

Branch: `doc/supervisor-quality`.

- [x] `supervise.md`: a `## Question resolution` step between Monitor
      and Boundary verification - a worker halting on an
      implementation question (a NEEDS_CONTEXT, a choice between
      offered options, a spec ambiguity) gets the supervisor's
      resolution on the plan's and requirements' terms, best option
      advised where possible, and the member resumes; a question
      touching project design or architecture escalates unanswered.
      The worker records each received answer in the report's
      supervisor-decisions section as it lands. `§ Boundary
      verification`'s "a judgment the gates cannot settle is an
      escalation, not a call" is replaced by the split: the reports'
      queued implementation-level judgment calls are the supervisor's
      to resolve (ledgered); design-level ones escalate. `§ Merge or
      escalate` names design and architectural decisions in the
      escalation list. `§ Dispatch` gains the prompt constraint:
      workers start under guaranteed prompt acceptance or the
      supervisor accepts edit prompts; a prompt neither pre-accepted
      nor supervisor-acceptable halts the member and escalates.
- [x] `companions/declarations.md § Supervisor bounds`: the
      always-escalated list gains design and architectural decisions;
      `companions/report-template.md` gains `## Supervisor decisions`
      (implementation questions resolved by the supervisor, each with
      the chosen option and rationale, recorded by the worker as
      answers land; "none" when unsupervised or no questions arose).
- [x] Close-review fixes: the decision split and its
      escalate-when-unclassifiable fail-safe are defined once in the
      bounds home and cited from the loop; the grant explicitly
      includes ledgered question resolution and read-only answers
      nothing; answers are carried into the report at checkpoint (it
      does not exist mid-run); judgment calls carry decision-level
      tags; supervisor-acceptable prompts are bounded to in-repo edits
      within declared permissions; `auto.md`'s halt names the
      operator; the escalation list is single-homed.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
