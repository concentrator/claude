# R070-T001 findings

- [x] (promoted to R071) `install-dev.sh` ships a named subset of Tier-1 checks
  (code-size, no-em-dash, accretion, batch-tags) and does not copy
  `check-archival.sh`; adopter projects follow the same
  `plan.md § Archival` rule, so shipping the gate (plus its
  `install-dev.test.sh` assertion) is a candidate.
