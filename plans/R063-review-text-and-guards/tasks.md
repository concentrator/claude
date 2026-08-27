# R063: Tier-2 review text and guard fail-closed - tasks

Draft; the detail round confirms once `requirements.md` is approved.

- [ ] R063-T001 [doc]: rewrite `MAINTENANCE.md § Tier-2 AI review` per
  the acceptance criteria on the review text
- [ ] R063-T002 [fix]: `settings.json` hook paths resolve from any
  working directory; `dev-secrets-guard.sh` fails closed with one
  stderr line when its library is missing
