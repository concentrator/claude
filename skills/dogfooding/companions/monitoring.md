# Watching the run

The review session watches from outside through `get_session` and `list_events`;
it never messages the run session while it works. Log each item with a timestamp
into a run log, so the final judgement cites events rather than memory.

| Signal | How to read it | What to log |
| --- | --- | --- |
| Stalls | `get_session`: `status_bucket` BLOCKED or `post_turn_summary.needs_action` set | The prompt text, the tool, how long it waited; in `auto` mode a stall is a defect in the brief or the toolset |
| Permission denials | `list_events` kind `result`, field `permission_denials`; the run's own notes | Command, classifier reason, which settings tier or shipped template should have covered it |
| Autonomy stops | The run's notes and report ("autonomy stop") | What the toolset asked, the option chosen, whether the choice mattered later |
| Seat fan-out | `result.subagent_stats`: spawned, completed, failed, by type | Seats per task; a second seat for the same step is waste to name |
| Context growth | `external_metadata.context_usage.used_tokens` sampled each check | Peak context; what the run read before its first scaffold file |
| Cost | `usage.cost_usd`, `cache_read_tokens`, `cache_write_tokens`, `output_tokens` on `get_session` | Totals at the end; compare run to run at equal task count |
| Branches and PRs | `git ls-remote`, `list_pull_requests` with `base` and `head` | Stacking (a PR whose base is not `main`), merge refusals, CI red |
| CI | `pull_request_read` `get_check_runs` on each head | Any failure the run caused itself, and how many pushes it took |
| Repository hygiene | `git status --short`, `git ls-files`, untracked and ignored lists on the final tree | Stray files, wrapper scripts the toolset forced, tracked files the toolset should have ignored |
| Toolset claims | Each finding in the report that names a toolset file and section | Open the file at the tested commit; mark the claim verified or not before repeating it |

The criteria and what counts as evidence for each:

1. **Correctness:** a hook, check or gate did what its file says, or a cited
   file does not exist in the install.
2. **Non-conflicting conventions:** two shipped files that a seat had to choose
   between; name both.
3. **Sequential and clean:** a step that had to be repeated, or a defect with no
   route back to the step that owns it.
4. **No gaps:** something a mode file assumes exists (a branch, a file, a value)
   that no step creates.
5. **Docs after each change:** each merged branch touched its component doc; the
   per-branch cadence is by design.
6. **Index and new docs:** `docs/index.md` has one line per component doc; count
   both.
7. **Exact documents in tasks:** each branch plan names the doc the implementer
   reads, not "the docs home".
8. **Optimised:** files or seats that added nothing: count them and their
   tokens.
9. **Loaded when needed:** files and lines read before the first project file;
   whether the skill loaded as a skill.
10. **Tokens:** totals over all transcripts, main-session peak context, per-seat
    average; the `baseline` input is the baseline, or the last row of
    `docs/reports/dogfood-runs.md` at the same task count.
11. **Permission stops:** the denials table; zero is the target.
12. **Smooth and rapid:** wall time from session creation to report merged;
    every detour and its cause.
