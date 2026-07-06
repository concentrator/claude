task: T-053
type: feat

# feat/writing-conv - writing-conventions doc (R-026)

T-053 of `plans/R-026-writing-conventions/`. A shipped convention doc stating
the three writing rules: no em dashes (any tracked file, hard-enforced by the
T-055 check), plus write-like-a-human and no-repetition (prose, Tier-2
review). The doc describes the em-dash rule in words (never the literal
character), so it does not trip its own gate.

Acceptance criteria: see `requirements.md` (a shipped convention doc states
the three rules; AI-tells + repetition recorded as Tier-2 review criteria).

- [x] Write `skills/dev/writing.md` (shipped companion): no em dashes - use a hyphen; applies to every tracked file, code included, gate-enforced by `check-no-em-dash`. Write like a human - avoid the AI-tell words ("delve", "leverage", "seamless", "robust", "comprehensive", "streamline") and filler. No repetition - do not restate a point already made. Mark the prose rules as Tier-2 (judgment), the em-dash rule as hard. Refer to the em dash by name / `U+2014`, never the literal character.
- [x] Wire the prose clauses into `MAINTENANCE.md § Tier-2` review criteria (AI-tell words + no-repetition on changed prose).
- [ ] Complete the branch: re-review docs, cleanup, mark plan complete, commit.
