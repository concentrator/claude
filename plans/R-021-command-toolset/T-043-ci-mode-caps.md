task: T-043
type: feat

# feat/ci-mode-caps - CI covers skills/dev/ companions (R-021)

T-043 of `plans/R-021-command-toolset/`. Extend Tier-1 to the new
`skills/dev/` companion mode files so the gate governs them. Under the
skill-router pivot there are **no new top-level dirs** (`hooks/` entered the
tree-map in T-039; companions live under `skills/dev/`), so `check-stray`
needs no change.

**Cap decision:** `skills/dev/*.md` companion mode files are read-on-demand
reference material → **1500-word cap** (matches the reference-skill tier;
the largest, `branch-plan.md`, is ~1462w). `skills/dev/companions/*` are
sub-references, exempt from the word cap.

- [x] `check-caps.sh` - cap `skills/dev/*.md` companions at 1500 words
  (exclude `SKILL.md`, already handled by the skill rule; exclude
  `companions/`). Confirm all current companions pass.
- [x] `DESIGN.md` - represent `skills/dev/` compactly as router +
  mode-file companions (stay within the DESIGN word cap; full enumeration
  deferred to the T-045 cleanup, when the originals are removed).
- [x] Run the full gate with the companions present; confirm green.
- [x] Complete the branch: mark plan complete, commit.
