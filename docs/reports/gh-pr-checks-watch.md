# `gh pr checks --watch` exit status

Probe of the GitHub CI wait, `gh pr checks <n> --watch`: it exits 0
when every check passes and non-zero when one fails. Both pull requests
were read only, their checks already finished.

## Call

```
gh pr checks 600 --watch; echo "exit=$?"
gh pr checks 14035 -R cli/cli --watch; echo "exit=$?"
```

The first call reads a pull request whose every check passed, the
second one whose `lint` check failed; each echoes its exit status.

## Output

```
tier1	pass	1m49s	https://github.com/concentrator/claude/actions/runs/39136505040/job/117701975682
tier1	pass	1m49s	https://github.com/concentrator/claude/actions/runs/39136505040/job/117701975682
exit=0
lint	fail	1m11s	https://github.com/cli/cli/actions/runs/33321337572/job/99283726990
CodeQL	pass	2s	https://github.com/cli/cli/runs/99283816229
CodeQL-Build (actions, none, security-and-quality)	pass	47s	https://github.com/cli/cli/actions/runs/33321337570/job/99283727072
CodeQL-Build (go, manual, ./.github/codeql/codeql-config.yml)	pass	2m34s	https://github.com/cli/cli/actions/runs/33321337570/job/99283727142
build (macos-latest)	pass	7m34s	https://github.com/cli/cli/actions/runs/33321337587/job/99283727103
build (ubuntu-latest)	pass	5m10s	https://github.com/cli/cli/actions/runs/33321337587/job/99283727156
build (windows-latest)	pass	10m14s	https://github.com/cli/cli/actions/runs/33321337587/job/99283727260
govulncheck	pass	16s	https://github.com/cli/cli/actions/runs/33321337572/job/99283727084
integration-tests (macos-latest)	pass	1m11s	https://github.com/cli/cli/actions/runs/33321337587/job/99283727097
integration-tests (ubuntu-latest)	pass	1m25s	https://github.com/cli/cli/actions/runs/33321337587/job/99283727021
integration-tests (windows-latest)	pass	2m10s	https://github.com/cli/cli/actions/runs/33321337587/job/99283727179
(the same eleven rows printed a second time)
exit=1
```

Each check row holds the check name, its result, its duration and its
job URL. On checks already finished, `--watch` prints the check table
twice, once as it starts and once as it exits: hence the repeated
`tier1` row and the second copy of the eleven `cli/cli` rows. `exit=0`
follows the passing run, `exit=1` the failing one.

## Environment

- `gh` 2.97.0 on macOS (Darwin 25.5.0)
- Run at 2026-10-19T09:39Z
- Pull requests: `concentrator/claude` 600 and `cli/cli` 14035
