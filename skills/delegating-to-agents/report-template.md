# Batch report template

Written by the checkpoint to `plans/batches/B-XXX.report.md` BEFORE the
accept/reject offer. Accept is invalid without it. Fill every section;
write "none" rather than omitting one — an empty heading reads as a
skipped step.

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
  queued judgment call | dismissed (reason)>
- findings file: <open items count, or "none">

## Batch review (full diff vs base, most capable model)

- cross-branch findings: <interactions invisible to per-branch review:
  semantic conflicts, duplicated helpers, divergent conventions —
  each + resolution>
- fixes applied on batch branch: <shas + one-liners, or "none">
- tests + lint after fixes: <results>

## Docs coherence

- CHANGELOG: <entries from all branches read as one release block?
  reworded items, dedupes>
- README / extended docs: <surface changes consistent?>

## Prompt friction

<summary of permission_prompts.jsonl grouped by root cause, with
proposed rail/allowlist fixes; or "log empty — zero prompts". Truncate
the log after writing this section.>

## Judgment calls for checkpoint

<numbered list of decisions deferred to the user, each with options
and a recommendation; or "none">
```
