task: R066-T001
type: refactor

# The visual companion leaves the skill; the runbook keeps only steps

`companions/visual-companion.md` and `companions/scripts/` are deleted
with every site that offers, lists or exempts them, and
`supervisor-runbook.md § Remote Control` and `§ Failure modes` shrink
to the instructions a supervisor follows; each observation they drop
already has, or receives, one home (table below). Branch:
`refactor/drop-visual-mockups`.

## Relocation table

Each observation the runbook drops, where it lives afterwards
(R066 acceptance criterion 2). "Already" means the receiving file
records the fact today and the runbook copy is the duplicate.

| Runbook text | Kind | Home after |
|---|---|---|
| `remoteControlAtStartup` honoured at user scope only; the flag is the better shape | measurement | already `R040-T011-agent-channel.findings.md` ("user-scope only"); runbook keeps the instruction: join by launch flag |
| `/rc active` footer is the reliable instrument; `daemon status` and the splash tip lie | measurement | already `R040-T011-agent-channel.findings.md` ("only reliable instrument"); runbook keeps: confirm via the footer marker |
| `autoUploadSessions` mirrors sessions view-only, data-egress consequence | instruction with reason | stays, one sentence |
| host session visible in `ListAgents` only with both ends connected; `isolatePeerMachines` gates cross-machine sends | measurement | already `R040-T011-agent-channel.findings.md` ("BOTH ends"); runbook keeps the instruction: the operator's session joins too |
| classifier fails closed on opaque commands | instruction | stays, one sentence: write commands the classifier can read |
| auto mode reverts to prompting when the classifier transcript overflows | measurement | `R040-T011-agent-channel.findings.md` (new row under "What is settled"); runbook keeps: reappearing prompts mean this, not a mode change |
| `pkill -f` self-matches over ssh, exit 255 | measurement | `skills/worker-host/companions/pitfalls.md` (new entry; the exit-255 first-contact entry there is a different fault) |
| `&` inside an ssh command drops the connection; use `tmux` | measurement | `skills/worker-host/companions/pitfalls.md` (new entry) |
| a fresh session ignores keys sent during its splash | measurement | already `R040-T011-agent-channel.findings.md` ("can drop its submit"); runbook keeps: wait for the prompt line |
| Claude Code writes `defaultMode` into the tracked `settings.json` | measurement | `skills/worker-host/companions/pitfalls.md` (new entry) |
| usage-limit reset time is in the account's timezone | measurement | already `R040-T011-agent-channel.findings.md` ("usage limit stops a supervisor mid-turn"); runbook keeps: run `date` on the host before resuming |
| a turn ending between steps leaves no record of which | measurement | already `R040-T011-agent-channel.findings.md` (same row); runbook keeps: tell a resumed session where to resume |

## Commits

- [x] Delete `companions/visual-companion.md` and `companions/scripts/`;
  drop the offer at `brainstorm.md` step 3 and the `server.cjs` line
  in `scripts/ci/code-size-allow.txt`
- [ ] Drop `dev/plans/visual-artifacts/` from `layout.md` (tree and the
  lazy-files list) and "mockup scripts" from the `DESIGN.md` tree-map
  companions line
- [ ] `scripts/test/install-dev.test.sh` asserts the `--project` target
  has no `skills/dev/companions/scripts/`
- [ ] `supervisor-runbook.md § Remote Control` reduced to its four
  instructions (table rows 1-4)
- [ ] `supervisor-runbook.md § Failure modes` reduced to its
  instructions; the three host pitfalls become
  `skills/worker-host/companions/pitfalls.md` entries and the
  classifier-overflow row joins `R040-T011-agent-channel.findings.md`
  (table rows 5-12)
- [ ] `R066-T001-drop-visual-mockups.findings.md`: byte sizes of the
  `/dev supervise` read set at the branch base and at close, the
  relocation table checked row by row (grep per receiving file), and
  the `git grep` of criterion 1
- [ ] Mark and commit the task `[x]` in `tasks.md`
- [ ] Complete the branch: re-review docs across all commits, cleanup,
  mark plan complete, commit
