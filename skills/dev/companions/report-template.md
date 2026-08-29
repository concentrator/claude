# Batch report template

Written by the checkpoint to `dev/plans/R<NNN>-<slug>/batches/R<NNN>-B<NNN>.report.md`
(timing + no-report-no-accept: `auto.md § Checkpoint`). Fill every
section; write "none" rather than omitting one - an empty heading reads
as a skipped step.

```markdown
# R<NNN>-B<NNN> report - <one-line batch theme>

batch-branch: batch/R<NNN>-B<NNN>
base: <default branch>@<sha at pre-flight>
state: <branches merged>/<branches planned>, tests <green|red>, lint <green|red>

## Branches

### <prefix>/<slug> (<task-id>)
- commits: <n> (<first sha>..<last sha>)
- tests: <command + summary line, e.g. "npm test: 124 pass / 0 fail">
- spec checks: <n> passed, <n> rejected→fixed
- review findings: <each finding + resolution: fixed in <sha> |
  queued judgment call | dismissed (reason); or "folded into batch review (small branch)">
- findings file: <open items count, or "none">

## Batch review (full diff vs base, most capable model)

- cross-branch findings: <interactions invisible to per-branch review:
  semantic conflicts, duplicated helpers, divergent conventions -
  each + resolution; findings in folded branches attributed per branch>
- fixes applied on batch branch: <shas + one-liners, or "none">
- tests + lint after fixes: <results>

## Docs coherence

- CHANGELOG: <entries from all branches read as one release block?
  reworded items, dedupes>
- README / extended docs: <surface changes consistent?>

## Cost

- total subagent tokens: <N> (implementer: <n> / spec-check: <n> /
  reviews: <n> / other: <n> - attribute where logs distinguish roles;
  collapse unattributable into "other")
  prior-batch baseline: <tokens> / <commits>
- spec checks skipped: <count> (<per-commit skip records per
  verification-policy.md § Spec-check skip, or "none">)
- dispatch-prompt sizes (wc -w): implementer-prompt.md <before> → <after>;
  spec-reviewer-prompt.md <before> → <after>
  (prior-batch baseline: <implementer> / <spec-reviewer>)
- convention drift: <n> by spec-check sensor + <n> by close/batch review
  = <total> (prior-batch baseline: <n>). The sensor is blind on
  spec-check-skipped commits, so close/batch-review drift is counted too
  to complete the picture (verification-policy.md § Convention drift outcome)
- defect outcomes: spec rejections reaching merge: <n>
  (prior-batch baseline: <n> merge-reaching spec rejections);
  review findings surfaced: <n> fixed / <n> queued / <n> dismissed

## R acceptance criteria

<per criterion of this R's `requirements.md`: verified (one-line
evidence) | still pending (which event verifies it); or "all
previously verified">

## Supervisor decisions

<implementation questions and queued calls resolved by the
supervisor, each with the chosen option and rationale - answers
carried in by the worker at checkpoint; or "none" - unsupervised runs
or no questions asked>

## Judgment calls for checkpoint

<numbered list of deferred decisions, each tagged implementation or
design, with options and a recommendation; implementation-tagged
calls a supervisor may resolve into `## Supervisor decisions`,
design-tagged await the user; or "none">
```
