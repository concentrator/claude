task: T-034
type: feat
depends-on: T-031

# feat/embed-opt-in — wire embedding into scaffold/adoption (R-015)

T-034 of `plans/R-015-embeddable-dev/requirements.md` (AC8). Offer the
"embed a self-contained DEV toolchain" opt-in from `starting-a-project`
(new) and `migrating-to-dev` (existing), invoking the vendor when chosen;
default behavior is unchanged when not opted in.

**Design.** A compact opt-in bullet in each skill's relevant step runs
`~/.claude/scripts/vendor-toolchain.sh <root>` on opt-in. The why/when
detail already lives in `README.md § Embedding` + the manifest, so the
skill additions stay to ~15 words each.

**Trim approach (both skills sit at the 300-word cap).** Make room by
**pruning genuinely redundant statements** — each candidate cut tested
against the three gates (`MAINTENANCE.md § Prune dead prose`: accurate?
valuable in any real scenario? would behavior change if removed?) — not
mechanical word-chopping. Propose the prunes with the opt-in at code time
(skills gate).

- [x] `starting-a-project`: add the embed opt-in to § 3 Scaffold; prune
  redundant prose to stay ≤300 (propose cuts + opt-in for approval).
  (skill edit)
- [ ] `migrating-to-dev`: add the embed opt-in to § 5 Quality
  infrastructure; prune redundant prose to stay ≤300 (propose cuts +
  opt-in for approval). (skill edit)
- [ ] Complete the branch: confirm the opt-in is present in both skills,
  default-off behavior unchanged, caps green; re-review, triage findings,
  mark the plan complete, commit.
