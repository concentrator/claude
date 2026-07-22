task: T-076
type: fix

# fix/guard-target - judge writes by the target's owning repo (R-036)

T-076 of `plans/R-036-guard-target-scope/`. The Write/Edit arm allows any
path outside the session's cwd repo (R-034), so tracked files of a second
checkout on a trunk are writable cross-repo. Judge the physically resolved
target by its **owning repo** instead: `git -C <nearest existing ancestor>
rev-parse --show-toplevel`; owner on a trunk and target tracked-side there
(`check-ignore` exit 1 run in the owner) → deny from any cwd. Ignored
targets (memory dir), owner on a working branch, no owner, and errors stay
allowed. The cwd repo's own tracked-trunk deny is the same rule (owner =
cwd repo).

Acceptance criteria: see `requirements.md` (cross-repo trunk deny;
ignored / branch / no-repo allows; existing pins green; three new pins;
ROADMAP narrowing note - already landed with the shape PR; suites +
Tier-1 green).

- [ ] Behavior slice (tests + hook, one commit): rework the Write-arm judgment in `hooks/dev-branch-guard.sh` - resolve the target physically (existing mechanics), derive its owning repo from the nearest existing ancestor, deny when the owner's HEAD is a trunk and `git -C <owner> check-ignore` exits 1, allow otherwise; pins in `scripts/test/dev-branch-guard.test.sh` for cross-repo tracked-on-trunk (deny), ignored-in-owner (allow), owner-on-branch (allow), plus all existing pins green.
- [ ] Update the hook header comment to the target-repo semantics; live repro: the settings.json write from a foreign cwd denies while `~/.claude` is on `main`, the memory-dir write still allows.
- [ ] Complete the branch: re-review docs across all commits, cleanup, mark plan complete + bookkeeping marks, commit.
