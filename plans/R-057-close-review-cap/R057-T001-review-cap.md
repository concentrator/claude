task: R057-T001
type: mnt

# R057-T001 - Cap the routed close review

- [x] `agents/code-reviewer.md`: pin `model: fable`, add
  `effort: medium`, and add reviewer conduct rules to the prompt - no
  subagents (never invoke `/code-review`, the Agent tool, or spawn
  reviewers), and read-only toward the repo: no writes, no `git`
  command that moves HEAD or switches branches
- [x] `branch-plan.md § Closing routine`: the three `/code-review`
  rows route to the `code-reviewer` agent; state the cap - one
  reviewer, plus one verifier dispatched only on a Critical finding -
  and name built-in `/code-review` as a manual-only escalation the
  flow may suggest, never run; stay under the file's word cap
- [x] `delegation.md`: the close-review fan-out bullet is replaced by
  the prohibition - subagents never invoke `/code-review` or spawn
  further subagents; the capped close review is dispatched by the
  session, not delegated onward
- [x] `verification-policy.md § Effort mechanics`: rewrite to state
  the present - agent frontmatter carries an effort key, so per-role
  effort routing is real (the dispatch surface still overrides model
  only); the model table and capacity fallback stay
- [ ] Mark and commit the task `[x]` in the R's `tasks.md`, plus any
  release-plan entry
- [ ] Complete the branch: re-review docs across all commits, cleanup
  (stale/temp data), mark plan complete, commit
