task: T-014
type: refactor
depends-on: T-013
agentic: approved 2026-06-12

# refactor/slim-dispatch — pointers over pasted conventions in dispatch prompts (R-005 lever 4)

Lever 4 of `plans/R-005-verification-cost/requirements.md`: trade the
pasted conventions block in the dispatch templates for pointers to
CLAUDE.md sections the dispatched agent reads itself (its Task-tool
context already carries CLAUDE.md; Read tool as fallback). Rails held
throughout: full plan item text and acceptance criteria stay pasted in
every dispatch — the never-read rail covers plan files only, not
CLAUDE.md. Harness rails with no CLAUDE.md home (Scratch & Probe,
Plan & Findings tool rule, escalation, report format) stay pasted
verbatim. Plan-time sizes for the trade record: implementer-prompt.md
866 words, spec-reviewer-prompt.md 312 words, SKILL.md 397 of its
400-word cap — all re-measured at execution (T-012/T-013 land first
and may shift them); `wc -w` ≤ 400 verified on every SKILL.md edit.

- [x] implementer-prompt.md: replace CLAUDE.md-duplicating convention
      text with a compact `## Conventions` pointer block — "Your Job"
      step 5 commit-style prose ("single-line message, ~50 chars…") →
      pointer to CLAUDE.md § Commit Messages; step 4 docs detail →
      pointer to project CLAUDE.md docs conventions; the block also
      names § Code Comments and § Audience visibility and states the
      sections are already in the agent's loaded context (Read tool as
      fallback). Item text, Context/criteria, and Before You Begin
      stay pasted unchanged.
- [x] implementer-prompt.md: trim Code Organization to its
      dispatch-specific rails — keep the file-growth →
      DONE_WITH_CONCERNS trigger and the no-restructuring-outside-task
      line, drop the generic file-design prose; Scratch & Probe
      Scripts, Plan & Findings Files, When You're in Over Your Head,
      Self-Review, and Report Format stay verbatim (rails, no
      CLAUDE.md home).
- [x] spec-reviewer-prompt.md: add convention-drift flagging to the
      reviewer's checklist (commit-message style, docs conventions —
      checked against the CLAUDE.md sections the reviewer reads
      itself) as the rail-strength sensor for the pointer trade; sweep
      the rest for CLAUDE.md-duplicating text → pointers (none
      expected — confirm); do-not-trust protocol and the
      no-substitution command rail stay pasted.
- [x] delegating-to-agents SKILL.md per-commit dispatch bullet:
      dispatch pastes full item text + the R's `requirements.md`
      criteria / DESIGN.md excerpts; conventions arrive via the
      agent's own CLAUDE.md context per the template's pointer block;
      "never have it read plan files" kept word-for-word (the rail
      covers plan files, not CLAUDE.md); verify `wc -w` ≤ 400 after
      the edit.
- [x] Record the trade where the checkpoint compares it: extend the
      batch-report cost line (introduced by T-012 in
      report-template.md) with dispatch-prompt sizes — before from git
      history prior to this branch's first edit (`git show`), after
      from the working tree, both in `wc -w` words — plus a
      rail-strength comparison instruction: convention-drift catches
      this batch vs the B-002/B-003 baseline of zero; if any wording
      lands in SKILL.md, re-verify `wc -w` ≤ 400.
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
