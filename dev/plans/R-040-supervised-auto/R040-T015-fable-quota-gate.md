---
task: R040-T015
type: feat
---

Branch: `feat/fable-quota-gate`.

Turn a reactive model fallback into a pre-flight one, and stop spending the
Fable window on work that does not need it.

Two settings decide what a session and its review agents run on, and both
point at Fable today. The tracked project tier pins
`model: claude-fable-5[1m]`, so every session opened in this repo runs Fable
whatever it is doing. `verification-policy.md § Models` pins branch-close and
batch full-diff review to `fable`, and its capacity fallback degrades to
`opus` only once a dispatch has already failed. A session that meets the
weekly Fable window mid-review does not fail cleanly: it stops on a consent
dialog offering the swap, which is the exact failure R040-T011 exists to
remove, since a blocked supervisor reads identically to a thinking one.

The wire shape the first commit depends on comes from a live probe of the
usage endpoint on 2026-08-24, run from the operator's machine and from the
worker host over IAP. At probe time the Fable window was already exhausted,
so the gate's first real answer is the one that matters: dispatch on Opus.
Claude Code exposes no supported reader for this - there is no `claude usage`
subcommand, `/usage` is interactive, and the structured form is an SDK
control request - and the endpoint's own schema is labelled experimental in
the binary, which is why the script owes a fail-closed path more than it owes
a feature.

- [x] Add `scripts/model-quota.sh <display-name>`: read the session's OAuth
      token, GET the usage endpoint, select that model's scoped weekly
      window, and exit 0 while it has headroom, 1 at or over the 80 percent
      ceiling. Probed shape: `GET
      https://api.anthropic.com/api/oauth/usage` with `Authorization: Bearer
      <token>` and `anthropic-beta: oauth-2025-04-20` returns `limits[]`,
      whose per-model entries carry `scope.model.display_name`, `percent`,
      `severity`, `resets_at` and `is_active`. `seven_day_opus` and
      `seven_day_sonnet` are null on this plan, so the scoped entry is the
      only source, and `scope.model.id` is null too, so the server-supplied
      display name is the only selector there is. Token from
      `~/.claude/.credentials.json` (`.claudeAiOauth.accessToken`, mode 600)
      on Linux and the `Claude Code-credentials` keychain item on macOS.
      Tests stub `curl` on `PATH` as `provision-worker.test.sh` does, and
      carry a leak canary: no token value reaches output, per
      `worker-workspace.test.sh` case 23.
- [x] Fail closed on every unknown - absent credential file, non-200, absent
      scoped entry, unparseable body - each exiting 2 with a one-line reason
      on stderr. A caller treats 2 exactly as 1, because routing to Fable
      wrongly stalls a review on a dialog while routing to Opus wrongly
      costs a weaker review. The script never reads or refreshes
      `refreshToken`: rotation belongs to Claude Code, and a script racing it
      can leave the credential unusable for the session that owns it.
- [x] Make the capacity fallback in `verification-policy.md § Models`
      pre-flight: read the gate before dispatching a `fable`-pinned role,
      dispatch `fable` only on exit 0, and otherwise dispatch `opus` and
      record the substitution the section already requires. Keep the reactive
      clause, which still covers a dispatch failing on capacity below the
      ceiling.
- [x] Point the tracked project tier at Opus (`.claude/settings.json`,
      `model: claude-opus-5[1m]`), so ordinary work in this repo leaves the
      Fable window to the reviews pinned to it and the fallback target is
      what a session already runs.
- [x] Mark and commit the task `[x]` in the R's `tasks.md`.
- [ ] Complete the branch: re-review docs across all commits, add the new
      script to `DESIGN.md § Tree-map`, cleanup, mark plan complete, commit.

Relation to R-056: settings tiering owns which tier a setting lives in, and
the fourth item edits a tiered value. It is in scope here because
`DESIGN.md § Tree-map` already names `model` as the project tier's business
and the change is one value in place, not a move between tiers. A decision to
relocate the key belongs to that initiative.
