---
approved: pending
kind: bug
---

# R087: Hooks run once

## Goal

A project install skips registering a hook whose script the global
settings already run, so each DEV hook fires once per event. Today a
project installed on a machine whose global settings register the same
hooks runs every one of them twice, and a blocking hook shows its
message twice.
