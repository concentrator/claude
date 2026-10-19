# `gh pr checks --watch` exit status

Probe of the GitHub CI wait, `gh pr checks <n> --watch`: it exits 0
when every check passes and non-zero when one fails. Both pull requests
were read only, their checks already finished.

## Call

```
gh pr checks 600 --watch; echo "exit=$?"
gh pr checks 14035 -R cli/cli --watch
```

The first call reads a pull request whose every check passed; the
second one whose `lint` check failed, its exit status echoed and its
failing rows printed once.

## Output

```
tier1	pass	1m49s	https://github.com/concentrator/claude/actions/runs/39136505040/job/117701975682
tier1	pass	1m49s	https://github.com/concentrator/claude/actions/runs/39136505040/job/117701975682
exit=0
lint	fail	1m11s	https://github.com/cli/cli/actions/runs/33321337572/job/99283726990
exit=1
```

Each check row holds the check name, its result, its duration and its
job URL. `exit=0` follows the passing run, `exit=1` the failing one.

## Environment

- `gh` 2.97.0 on macOS (Darwin 25.5.0)
- Run at 2026-10-19T08:42Z
- Pull requests: `concentrator/claude` 600 and `cli/cli` 14035
