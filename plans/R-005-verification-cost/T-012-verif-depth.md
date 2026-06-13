task: T-012
type: feat
agentic: approved 2026-06-12

# feat/verif-depth — verification depth policy in delegating-to-agents (R-005)

Levers 1 + 2 and the cost-line criterion of
`plans/R-005-verification-cost/requirements.md`; lever 3 (branch-close
fold-in) is out of scope here. Constraints held throughout: SKILL.md
sits at 397 of its 400-word orchestrator cap, so all policy content
(mechanical predicate, skip semantics, routing table) lives in a new
companion `verification-policy.md` beside SKILL.md — SKILL.md gains
only pointer wording with compensating trims, and `wc -w` ≤ 400 is
verified after every SKILL.md edit. The mechanical rule is a checkable
predicate evaluated without agent judgment (acceptance criterion 2).

- [x] Effort-mechanics probe: establish whether reasoning effort is
      settable per subagent dispatch (the Agent tool exposes a `model`
      override — `sonnet`/`opus`/`haiku`/`fable` — but no effort field;
      check agent-definition frontmatter and Claude Code settings for a
      per-dispatch effort knob) and record the finding with evidence in
      a new `skills/delegating-to-agents/verification-policy.md`
      § Effort mechanics — the section states either the per-dispatch
      mechanism or "session-level only; routing degrades to model
      choice"; no SKILL.md edit.
- [x] Mechanical-commit predicate in `verification-policy.md`: a commit
      item is mechanical iff its plan text explicitly names at most 2
      files to touch and states a complete spec (testable outcome, no
      unresolved design choices) — evaluated from the item text alone
      before dispatch; plus a post-implementation guard voiding the
      classification (spec check runs after all) when the implementer's
      "Files changed" report exceeds the named set — guard input
      already exists in `implementer-prompt.md` § Report Format
      (confirm, no edit expected).
- [x] Spec-check skip semantics in `verification-policy.md`: mechanical
      commits skip the per-commit spec check, relying on the
      branch-close review to catch drift; each skip is recorded per
      commit (feeds the batch-report cost line); non-mechanical flow,
      stop conditions, and the second-rejection halt unchanged.
- [x] Per-role model routing table in `verification-policy.md`
      § Models: implementers → Opus 4.8 (`opus`, high effort);
      mechanical commits (per the predicate) → Sonnet 4.6 (`sonnet`);
      probes → Opus 4.8 (`opus`); judgment-heavy implementers and all
      reviews → Fable 5 (`fable`); effort column encoded per the
      § Effort mechanics finding from the first commit.
- [x] delegating-to-agents SKILL.md: gate the per-commit spec-check
      step on `verification-policy.md` (mechanical class skips) and
      collapse the trailing "Models:" heuristic line into the same
      pointer; compensating trims as needed; verify `wc -w` ≤ 400.
- [x] report-template.md: add a "Cost" section — total subagent tokens
      (per role where attributable), count of spec checks skipped, and
      defect outcomes, each against the B-002/B-003 baseline stated
      inline in the template (~800–900k subagent tokens / 12 commits;
      0 merge-reaching spec rejections).
- [x] Complete the branch: re-review docs across all commits, cleanup
      (stale/temp data), mark plan complete, commit.
