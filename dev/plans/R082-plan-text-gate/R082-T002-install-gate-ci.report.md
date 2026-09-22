# R082-T002 report

## Implementer
### Divergences
- Item 1: the fast-tier cases live in a new
  `scripts/test/install-dev-fast-tier.test.sh`, not in
  `scripts/test/install-dev.test.sh`: appended there, the file reached
  314 lines, over the code-size gate's 300-line cap.
