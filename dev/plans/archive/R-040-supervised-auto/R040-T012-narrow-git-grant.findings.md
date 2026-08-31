# R040-T012 findings

## Inventory

Two sources, per the plan's § Terms. Toolset: every `git <sub>` in
`skills/dev/*.md`, `skills/dev/companions/*.md`, `hooks/*.sh` and
`scripts/**/*.sh`, prose words after `git` dropped by hand. Sessions:
the ten most recently written transcripts of this repo
(`projects/-Users-skywalker--claude/`, oldest 2026-08-20), every `git
<sub>` at the start of a Bash command or after `;`, `&&`, `|` or `(`,
since a compound command is permission-checked per segment.
`scripts/context-cost.py --last 10` was the plan's pointer, but it
ranks sessions across every project and five of its ten were another
repo's. `git ls` appeared once and is not a subcommand.

| Subcommand | Toolset files | Sessions of 10 |
|---|---|---|
| add | 14 | 6 |
| branch | 3 | 7 |
| cat-file | - | 1 |
| check-ignore | 6 | 3 |
| checkout | 7 | 6 |
| cherry | - | 1 |
| cherry-pick | - | 2 |
| clone | 3 | 2 |
| commit | 8 | 6 |
| commit-tree | 1 | - |
| config | 10 | 4 |
| describe | 1 | - |
| diff | 2 | 8 |
| fetch | 2 | 6 |
| for-each-ref | 1 | 2 |
| grep | 2 | 6 |
| init | 14 | 4 |
| log | 6 | 7 |
| ls-files | 12 | 5 |
| ls-remote | - | 2 |
| ls-tree | 1 | 2 |
| merge | 1 | 3 |
| merge-base | 1 | 2 |
| mv | 3 | 4 |
| pull | 1 | 7 |
| push | 10 | 6 |
| reflog | - | 2 |
| remote | 3 | 4 |
| reset | - | 2 |
| restore | - | 2 |
| rev-list | - | 4 |
| rev-parse | 33 | 5 |
| rm | - | 2 |
| show | 2 | 6 |
| show-ref | 3 | - |
| stash | 1 | 4 |
| status | 4 | 7 |
| switch | 2 | 5 |
| symbolic-ref | 5 | - |
| tag | 4 | 1 |
| worktree | - | 1 |

Every git subcommand the per-project template grants
(`companions/auto-permissions.template.json`) is among them, so on a
host carrying this config the template's git list is still fully
covered by the global grant; a placed-versus-missing test
discriminates only on a host without it. The template keeps its list
for that host.

## Prompts under the narrowed grant

The branch's own close, in this repo, on the session that made the
change. Git commands run after the grant landed: `add`, `commit`,
`log`, `status`, `check-ignore`, `diff`; the pre-push hook and the
gate run `rev-parse`, `ls-files`, `for-each-ref`, `show-ref`,
`symbolic-ref`, `fetch` from inside scripts, which the Bash grant
does not judge. No git prompt was raised. Two limits on that
evidence: the session runs in auto mode, where a rule miss goes to
the classifier rather than to a prompt, and whether a running session
reloads `settings.json` is not observable from inside it. The push
and the PR open run after this record; a prompt there adds its
subcommand to the grant before the PR opens.
