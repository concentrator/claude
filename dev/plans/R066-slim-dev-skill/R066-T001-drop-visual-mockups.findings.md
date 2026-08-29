# R066-T001 findings

## `/dev supervise` read set, bytes

Measured with `wc -c` at the branch base and at close:

| File | Base | Close |
|---|---|---|
| `supervise.md` | 9517 | 9517 |
| `companions/supervisor-runbook.md` | 11384 (1738 words) | 9877 (1485 words) |
| `companions/verification-policy.md` | 9285 | 9285 |
| `companions/declarations.md` | 5889 | 5889 |
| the set | 36075 | 34568 |

Deleted: `companions/visual-companion.md` 10268 bytes and
`companions/scripts/` 27800 bytes; `du -sk skills/dev` 264 → 216.

## Relocation table, checked

Each row of the branch plan's table resolved to its receiving file
(grep count of the row's phrase):

- [x] `remoteControlAtStartup` - `R040-T011-agent-channel.findings.md` (`user-scope only`: 1); runbook keeps `launch flag`: 1
- [x] `/rc active` instrument - `R040-T011-agent-channel.findings.md` (`only reliable instrument`: 1); runbook keeps `rc active`: 1
- [x] `autoUploadSessions` - runbook, one sentence (`autoUploadSessions`: 1)
- [x] both ends connected - `R040-T011-agent-channel.findings.md` (`BOTH ends`: 1); runbook keeps `both ends`: 1
- [x] classifier fails closed - runbook, one sentence (`classifier can read`: 1)
- [x] classifier transcript overflow - `R040-T011-agent-channel.findings.md` (`classifier transcript`: 1 new row); runbook keeps `not a mode`: 1
- [x] `pkill -f` self-match - `skills/worker-host/companions/pitfalls.md` (`pkill -f`: 3, one entry); runbook keeps `[r]esmon`: 1
- [x] `&` over ssh - `pitfalls.md` (`inside an ssh command`: 1)
- [x] keys during the splash - `pitfalls.md` (`during its splash`: 1); runbook keeps `prompt line`: 1
- [x] `defaultMode` written - `pitfalls.md` (`defaultMode`: 1); runbook keeps `do not stage`: 1
- [x] reset time in the account's timezone - `pitfalls.md` (`account's timezone`: 1); runbook keeps `date` on the host`: 1
- [x] resume names where the turn stopped - `R040-T011-agent-channel.findings.md` (`naming where the`: 1); runbook keeps `where the turn stopped`: 1

## Criterion 1

`git grep -l 'visual-companion\|companions/scripts\|visual-artifacts\|server.cjs' -- . ':!dev/plans/archive' ':!dev/plans/R066-slim-dev-skill'`
returns nothing. Beyond the audit's sites, the sweep found and cleared
`companions/root-migration.md` (move set and gaps),
`MAINTENANCE.md` (a housekeeping row for the directory), and the
installer assertion, which now states the property without the name
(`companions/` ships no subdirectory). The R066 plan directory names
the removed files as the record of their removal and archives with the
initiative.
