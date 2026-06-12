# Batch report template

Written by the checkpoint to `plans/R-XXX-<slug>/batches/B-XXX.report.md`
BEFORE the accept/reject offer. Accept is invalid without it. Fill every
section; write "none" rather than omitting one — an empty heading reads
as a skipped step.

```markdown
# B-XXX report — <one-line batch theme>

batch-branch: batch/B-XXX
base: <default branch>@<sha at pre-flight>
state: <branches merged>/<branches planned>, tests <green|red>, lint <green|red>

## Branches

### <prefix>/<slug> (T-XXX)
- commits: <n> (<first sha>..<last sha>)
- tests: <command + summary line, e.g. "npm test: 124 pass / 0 fail">
- spec checks: <n> passed, <n> rejected→fixed
- review findings: <each finding + resolution: fixed in <sha> |
  queued judgment call | dismissed (reason); or "folded into batch review (small branch)">
- findings file: <open items count, or "none">

## Batch review (full diff vs base, most capable model)

- cross-branch findings: <interactions invisible to per-branch review:
  semantic conflicts, duplicated helpers, divergent conventions —
  each + resolution; findings in folded branches attributed per branch>
- fixes applied on batch branch: <shas + one-liners, or "none">
- tests + lint after fixes: <results>

## Docs coherence

- CHANGELOG: <entries from all branches read as one release block?
  reworded items, dedupes>
- README / extended docs: <surface changes consistent?>

## Cost

- total subagent tokens: <N> (implementer: <n> / spec-check: <n> /
  reviews: <n> / other: <n> — attribute where logs distinguish roles;
  collapse unattributable into "other")
  B-002/B-003 baseline: ~800–900k subagent tokens / 12 commits
- spec checks skipped: <count> (<per-commit skip records per
  verification-policy.md § Spec-check skip, or "none">)
- dispatch-prompt sizes (wc -w): implementer-prompt.md <before> → <after>;
  spec-reviewer-prompt.md <before> → <after>
  (lever-4 baseline, pre-T-014: implementer 866, spec-reviewer 312)
- convention drift flagged by spec checks: <n> (B-002/B-003 baseline: 0)
- defect outcomes: spec rejections reaching merge: <n>
  (B-002/B-003 baseline: 0 merge-reaching spec rejections);
  review findings surfaced: <n> fixed / <n> queued / <n> dismissed

## R acceptance criteria

<per criterion of this R's `requirements.md`: verified (one-line
evidence) | still pending (which event verifies it); or "all
previously verified">

## Prompt friction

<summary of permission_prompts.jsonl grouped by root cause, with
proposed rail/allowlist fixes; or "log empty — zero prompts". Truncate
the log after writing this section.>

## Judgment calls for checkpoint

<numbered list of decisions deferred to the user, each with options
and a recommendation; or "none">
```
