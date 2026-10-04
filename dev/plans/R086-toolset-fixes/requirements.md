---
approved: pending
kind: mnt
---

# R086: Toolset fixes from project use

## Goal

Remove three kinds of wasted work that projects running the toolset hit:

- A requirements file states its outcomes as the template's numbered
  list, never as checkboxes, and a check fails on a checkbox in a living
  requirements file. The roadmap mark stays the only closure record.
- A project install skips registering a hook whose script the global
  settings already run, so each hook fires once per event and a blocking
  hook shows its message once.
- An agent creates its working branch before the first edit, told so by
  the branch-state hook and by a guard refusal that names the command;
  and the post-merge sync updates the default branch without switching
  onto a tree dirty with changes the branch did not make.
