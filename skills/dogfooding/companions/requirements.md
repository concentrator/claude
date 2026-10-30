# Requirements

Each must hold before the run session is created.

| Item | Requirement | Why |
| --- | --- | --- |
| Toolset | `concentrator/claude-dev` public on GitHub, at the commit to test | The run clones it over HTTPS; a private clone needs the Claude GitHub App to cover it too |
| Target repository | A fresh GitHub repository under the user's account, one initial commit on `main`, public or covered by the Claude GitHub App | The run needs push and pull-request access; a repository the session's credential cannot see fails at `add_repo` |
| GitHub App coverage | The Claude GitHub App installation on the owner account includes the target repository (`github.com/settings/installations`, Claude, Repository access) | Making the repository public fixes reads only; pushes are refused until the app covers it |
| GitHub identity | claude.ai's GitHub connection is the repository owner | A connection to another GitHub user cannot see the owner's private repositories |
| Review session mode | `auto` permission mode, set in the app before the run session is created | A child session cannot be more permissive than its parent; a `default` child blocks on its first Write prompt |
| Run session | Cloud environment with trusted network access, model `claude-opus-5-5`, permission mode `auto`, `source_url` = the target repository | The environment API has no effort setting; high effort goes in the system prompt addition |
| Session trust | The review session must be allowed to reach the owner's other sessions (a one-time trust card the owner answers in person) | Without it the run session's `send_message` back to the review session is refused |
| Tools in the run session | `gh` is present but REST-only in cloud sessions; `gh pr` subcommands fail with HTTP 403 | The toolset's declared `gh pr` commands fail; the run records each failure (`brief.md` step 2), so the run shows whether the toolset has closed the gap |
| Tags | Not creatable from a cloud session, by git push or by `gh api` | The release tag is done by hand on a trusted machine after the run |
| Budget | About 30 USD and one hour per run at the first run's scale (4 tasks, 37 seats) | Scale the task count down for a cheaper smoke run |
