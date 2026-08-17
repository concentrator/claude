---
task: R040-T011
type: feat
depends-on: R040-T002
---

Branch: `feat/file-channel`.

Give the operator and the supervisor a channel that survives being
ignored. Today the exchange is keystrokes typed into a terminal pane,
and the pilot showed three distinct costs: an escalation printed into
scrollback sat unread for roughly an hour while the supervisor's own
last line still read as working; a blocked supervisor and a thinking one
are indistinguishable from outside; and the auto-mode classifier twice
refused the keystroke injection on a pattern it had allowed a dozen
times in the same session, leaving the operator to run the command by
hand.

Three files per scope, on the filesystem both roles already share, and
outside any repo so no checkout is dirtied:

```
<channel-root>/<scope>/
  inbox     operator -> supervisor, append-only
  outbox    supervisor -> operator, append-only
  status    one line, overwritten in place
```

Not a mail system. There is no transport, no daemon and no delivery
semantics to get wrong: records are appended with `>>` and read with
`grep`. The worker host has no MTA at all, since `harden` purges exim4.

- [ ] Define the record format and write it down once. An append-only
      record carries a monotonic id, an ISO-8601 timestamp and the
      writer, so a reply can cite the id it answers and either side can
      tell what it has already consumed:
      `--- 004 2026-08-17T13:44:12+07:00 OPERATOR ---` followed by the
      body. Ids are per scope, not global.
- [ ] `status` is state, not history, so it is overwritten rather than
      appended: one line of `<state> <iso-timestamp>`, where state is
      `working`, `waiting:<id>`, `blocked:<id>` or `done`. This is the
      whole answer to "is anything waiting on me", and it is what a
      terminal pane cannot provide - a pane shows the last thing printed,
      which is not the same as the current state.
- [ ] An escalation is an `outbox` record plus `status` set to
      `blocked:<id>`. Unanswered means an id in `outbox` with no `inbox`
      record citing it, which makes "what is outstanding" a comparison
      rather than a judgement.
- [ ] Teach `supervise.md § Merge or escalate` and `§ Monitor` to use it,
      replacing "print a line and stop". Escalations stay artifacts read
      back rather than a parallel store: the channel carries the pointer
      and the state, never a copy of the plan or the diff.
- [ ] State the limit in the doc rather than discovering it later: a
      Claude Code session acts only when handed a turn, so a file the
      supervisor never reads changes nothing. Writing to `inbox` still
      needs a nudge. What this buys is that the substance no longer
      travels as keystrokes - the nudge is a bare `Enter` or three words,
      which a classifier judges trivially - and a supervisor already
      mid-run reads `inbox` between steps with no nudge at all.
- [ ] Leave the supervisor-to-worker half on keystrokes and say why: the
      worker is a TUI session that must be handed a turn, and that
      channel did not fail during the pilot. Changing it would be a
      rewrite justified by nothing measured.
- [ ] Acceptance, each able to fail. Write an escalation and show
      `status` reports `blocked` with that id; answer it and show the
      outstanding set become empty. Then kill the supervisor session and
      show the escalation still readable - the property scrollback does
      not have, and the reason this task exists. A test that only proves
      a file can be written proves nothing about durability.
- [ ] Complete the branch: gates green, mark this plan's checkboxes, and
      route what the build turns up. Closure is checkbox-only; R040-T011
      does not close R-040.

Relation to `R040-T003`: that task carries the remote transport, where
the two roles sit on different machines and need a channel over the
wire. This one is the co-located case, where the channel is a shared
filesystem and needs no transport at all. Co-location was the pilot's
arrangement and is the cheaper of the two to make reliable, so it lands
first.
