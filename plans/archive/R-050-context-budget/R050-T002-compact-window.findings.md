# R050-T002 findings

Decision evidence for this branch.

## The value

The close review re-derived 200000 rather than trusting the shape-round
estimate, which had been computed on the pre-correction figures. Replaying
25 sessions and 21,563 calls with compaction modelled - billing the
summarization and resetting context to prefix plus summary - puts the
saving at 73%, against the 55% the initiative was shaped on. The model
reproduces actual billing to within 0.8% when replayed at the full window.

200000 is the knee, on two independent grounds. Marginal saving per extra
compaction falls roughly tenfold in the first step below it, from 8.5M at
200k to 3.6M at 150k. And observed post-compaction context reached 98,431,
so a 100k cap would leave that session under 2k of working room and
re-compact at once; at 200k even a p90 summary leaves 62% of the window
productive. Compaction overhead is 1.8% of the capped bill, so token cost
is not what argues against going lower.

## The residual deviation

The plan asks the section to state that the harness enforces the window
"while this initiative's hooks observe". The delivered text states the
first half - "Enforcement is the harness's: the gates above judge changes,
not sessions" - and omits the second, because no such hook exists yet and
`writing.md § State the present` has a living document describe today.
R050-T003 adds the clause with the governor it introduces.

## Routed onward

The review found the enforcement point ungated: no Tier-1 check reads
`settings.json`, so the key could be dropped or `autoCompactEnabled`
flipped with the gate still green. That is R050-T008, planned rather than
absorbed here, because a new check and its test are their own deliverable.

The subagent evidence bears on R050-T003: only 1% of 495 subagent
transcripts peak above 200k, median peak 42,759. Its planned 80k advisory
tier would almost never fire, and the thresholds want revisiting when that
task is detailed.
