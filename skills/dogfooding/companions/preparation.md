# Preparation

Steps 1 to 4 are the owner's, done once per run; the rest the review
session does.

1. **Create the target repository** on GitHub: `tmp-dev-<slug>` under
   the owner account, private or public, "Add a README" ticked so `main`
   exists. Record its URL.
2. **Cover it with the Claude GitHub App:**
   `github.com/apps/claude/installations/select_target`, pick the owner
   account, Repository access, add the repository, save. Check that
   claude.ai's GitHub connection is that same owner.
3. **Put the review session in `auto` mode** in the app's mode selector
   before anything else. Changing it later restarts the session's worker
   and loses nothing, but the run session cannot be created in `auto`
   until this is done.
4. **Install the toolset from the setup script** of a cloud environment,
   and make that environment the account's default, so the run session
   starts in it. Resolve `toolset_commit` to its full 40-character sha; a
   branch resolves with

   ```bash
   git ls-remote https://github.com/concentrator/claude-dev refs/heads/<branch> | cut -f1
   ```

   and a full sha is its own (an abbreviated sha fails the fetch). Write
   that sha for `<TOOLSET_SHA>`:

   ```bash
   set -e
   git clone -q --depth 1 --no-checkout https://github.com/concentrator/claude-dev ~/src/claude-dev
   cd ~/src/claude-dev
   git fetch -q --depth 1 origin <TOOLSET_SHA>
   git checkout -q --detach FETCH_HEAD
   bash scripts/install-dev.sh
   ```

   The script runs before the session starts, so no command of the
   session installs the toolset, the commands `auto` refused
   (`pitfalls.md`). The clone sits outside `~/.claude`, since the install
   refuses a target inside the checkout it runs from. Resolve and write
   the sha each run: the environment reruns its setup script only when
   the script changes, and starts later sessions from the first run's
   cached result, so a branch name would keep that run's commit.
5. **Attach the repository** from the review session: `add_repo` with
   `access: push`, then `check_repo_access`; both must report push ok. A
   `not_found_or_no_access` result means step 2 or the identity is
   wrong; a `push_check: refused` after a successful attach means step 2
   alone.
6. **Confirm session trust** once: the first `send_message` to another
   session returns a `content_digest`; pass it to
   `confirm_repository_trust`, and the owner answers the card in person.
   Skip this and the run session's summary never arrives.
7. **Record the toolset commit** to test:
   `git -C <claude-dev clone> rev-parse HEAD`, and that it equals the
   sha step 4 wrote into the setup script.
8. **Create the run session** with `create_session`: `source_url` = the
   repository, `model: claude-opus-5-5`, `permission_mode: auto`, a tag
   such as `dogfood-<date>`, the system prompt addition and the prompt
   from `brief.md`, with the review session's id substituted into the
   prompt's delivery step.
9. **Arm a safety-net check-in** with `send_later`, 90 minutes, naming
   the run session id, so a stalled run is noticed without polling.
   Delete it when the summary arrives.
10. **Clone the repository locally** in the review session as well,
   shallow, for the verification step at the end.

The owner's part (repository, app coverage, `auto` mode, trust) is the
same each time. A reusable repository reset to its initial commit
removes steps 1 and 2 from every later run, if the owner accepts
force-pushing `main` of a throwaway repository on a trusted machine.
