task: T-057
type: feat

# feat/verify-gate - distinct branch-close verify step (R-024)

T-057 of `plans/R-024-confirmation-gates/`. Un-bundle the verify in
`finish.md § 2`: present the outcome and a distinct verify step (live test /
results collection) before the merge options, so the verify is not glossed
past. The MR/PR still opens only on explicit choice. Verify stays an offer
(not force-run), per the requirements default.

Acceptance criteria: see `requirements.md` (finish.md § 2 presents outcome,
then a distinct verify step, then merge options; PR opens only on explicit
choice; verify not bundled or glossed).

- [x] `finish.md § 2`: restructure into distinct steps - (i) present the outcome vs the task's ACs and the verify step (offer a live run; for data tasks run the work product and show results), then (ii) present the merge / keep / discard options. Keep "MR/PR opens only on explicit choice."
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
