task: T-023
type: feat

# feat/automerge-policy — plan/ PRs auto-merge on a green gate (R-010)

T-023 of `plans/R-010-ledger-automerge/requirements.md`. Documents the
auto-merge policy in `git-workflow.md § Trunk` (the no-cap home) with the
operative agent-merge fallback step; `finishing-a-branch` references it
without growing (it sits at 298/300w). Host-neutral; applies to `plan/`
doc PRs — batch/code PRs keep their checkpoint/review (no
`delegating-to-agents` change). Soft-ordered after T-022 so it rides the
union ledger, but no hard dependency.

- [ ] Add the auto-merge policy to `git-workflow.md § Trunk`: preference
      order — (1) native host auto-merge on a green gate where available;
      (2) the operator/agent merges `plan/` PRs as a fallback when the
      host can't gate (no branch protection), confirming the green gate
      first; `feat`/`fix`/`refactor` PRs always keep user review + merge;
      the fallback lapses to native once available. Reconcile the
      existing "PR review and merge stay the user's call" line (scope it
      to code PRs). Host-neutral (no host hardcode); include the
      `~/.claude` agent-merge mechanic (confirm `tier1` green → `gh pr
      merge`) as the fallback instance.
- [ ] Reword `finishing-a-branch § 3 Execute` (Push + PR) to reference
      `git-workflow.md § Trunk` for `plan/`-PR auto-merge — net-neutral;
      body stays ≤ 300w (`wc -w`).
- [ ] Complete the branch: re-review both files for host-neutrality +
      consistency, confirm caps, mark the plan complete (incl. the stamp
      checkbox), commit; stamp follows per the ledger protocol; hand off
      to `finishing-a-branch`.
