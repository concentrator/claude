# R048-T001 findings

- [ ] Placeholder spelling is split by artifact class: living docs say
  `batch/R<NNN>-B-XXX` / `pre-R<NNN>-B-XXX` (dominant `XXX` style),
  while the R-048 plan artifacts and `check-batch-tags.sh`'s header
  comment spell `B-<MMM>`. Converge in R048-T002, which touches the
  gate's comment header anyway: use the docs' `B-XXX` style in the
  script's comment and messages.
