# R044-T001 findings

- [x] `batch/B-XXX` branch refs share the flat per-initiative collision
  the tag rename fixes, and unlike the tag the branch is pushed at
  accept. R-044's non-goal excludes the branch on the premise that the
  tag is the only global namespace - branch refs are equally flat.
  Surfaced by this branch's close review. Promoted to R-048.
- [x] R-004's `requirements.md` referenced the flat anchor form at its
  rails and acceptance criteria; updated in this branch (commit
  `eca5cde`) as part of the no-flat-form sweep - reference-form update,
  no decision touched.
- [x] Nothing repo-wide specifies who writes `permission_prompts.jsonl`
  or what it stamps into `batch`. Won't fix here: pre-existing, and the
  writer stamps the tag it creates, so writer and reader move together
  through the rename.
