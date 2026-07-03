task: T-044
type: refactor

# refactor/cut-over — /dev router reads skills/dev/ companions (R-021)

T-044 of `plans/R-021-command-toolset/`. **Phase B.** Rewire the `dev`
skill (`skills/dev/SKILL.md`) from dispatching to standalone skills +
citing `~/.claude/rules/…` into a **router that reads the `skills/dev/`
companions** per argument (approved design). Fix the cross-refs deferred
from T-040 so the companion set is internally consistent. The `rules/`
originals + standalone skills stay as fallback until T-045; a bad cut-over
is one revert away.

## Notes

- Router stays ≤400 words (orchestrator cap). Companions are referenced as
  siblings in `skills/dev/`.
- **Verification splits:** pre-merge = router-logic review (every flow
  mapped to a companion, refs consistent) + close review; the **runtime
  dogfood is post-merge in a fresh session** — the rewritten skill loads
  on the next `/dev` invocation. Revert if any flow misbehaves.

- [ ] Rewrite `skills/dev/SKILL.md` into the companion-reading router (per
  the approved command→companion map); remove the `<!-- dev-embed-aware -->`
  block. Keep ≤400 words.
- [ ] Fix deferred cross-refs across `skills/dev/*.md` — rewire remaining
  old skill names (`finishing-a-branch`→`finish`,
  `delegating-to-agents`→`auto`, and any others) and strip residual
  `~/.claude/rules|skills/` prefixes; grep-verify no stale refs remain.
- [ ] Complete the branch: verify router logic + close review, mark plan
  complete, commit. (Runtime dogfood post-merge, fresh session.)
