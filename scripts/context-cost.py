#!/usr/bin/env python3
"""Report what a Claude Code session's context actually cost.

The billed input for one API call is the whole window it read, not the
part of it that was new: input_tokens + cache_creation_input_tokens +
cache_read_input_tokens. Summing that across a session gives the figure
the bill tracks, which is context size multiplied by session length
rather than the size of any one document or tool result.

Attribution answers the follow-on question: which material is being
re-read, and for how many calls. A token added at call 10 of 1000 is
paid for 990 times; the same token added at call 990 is paid for 10.
That product is reported as token-turns, and it sums exactly to the
billed total, which the tool checks on every run.

Usage:
    python3 scripts/context-cost.py <transcript.jsonl>
    python3 scripts/context-cost.py --session <transcript.jsonl>
    python3 scripts/context-cost.py --last 10

--last reads the transcripts under CLAUDE_CONFIG_DIR/projects, defaulting
to the config directory this script lives in. Exit status is nonzero if any
session fails its identity check or cannot be read.
"""
import argparse
import collections
import glob
import json
import os
import sys

MODEL = "model_output"
USER = "user_turn"
PREFIX = "static_prefix"
SHRINK = "shrinkage"

Call = collections.namedtuple("Call", "context output tool reset")


def billed(usage):
    """The whole window one API call read, cached or not."""
    return sum(usage.get(k, 0) or 0 for k in (
        "input_tokens",
        "cache_creation_input_tokens",
        "cache_read_input_tokens",
    ))


def tool_of(message):
    """The tool this assistant turn issued, or None if it ended the turn."""
    for block in message.get("content") or []:
        if isinstance(block, dict) and block.get("type") == "tool_use":
            return block.get("name")
    return None


def read_calls(path):
    """One Call per billed API call, in transcript order.

    Skips every record that is not an assistant turn carrying usage: user
    turns, tool results, and the assistant records the harness writes with
    no usage block. A line that does not parse is skipped rather than
    aborting the run, since a transcript being appended to can end mid-write.
    """
    calls = []
    with open(path, errors="replace") as handle:
        for line in handle:
            line = line.strip()
            if not line:
                continue
            try:
                record = json.loads(line)
            except ValueError:
                continue
            message = record.get("message")
            if record.get("type") != "assistant" or not isinstance(message, dict):
                continue
            usage = message.get("usage")
            if not isinstance(usage, dict):
                continue
            calls.append(Call(
                context=billed(usage),
                output=usage.get("output_tokens", 0) or 0,
                tool=tool_of(message),
                reset=bool(record.get("isCompactSummary")),
            ))
    return calls


def segments(calls):
    """Index ranges between context resets, as half-open (start, end) pairs.

    A reset is the harness's own isCompactSummary marker, or an unmarked
    drop past a tenth of the preceding context. The fallback covers rewinds
    and resumed sessions, which carry no marker. It is safe because the two
    populations do not overlap: a real reset discards most of the window,
    while the shrinkage from thinking blocks falling out at a turn boundary
    is orders of magnitude smaller.
    """
    start = 0
    for i in range(1, len(calls)):
        if calls[i].reset or calls[i].context < calls[i - 1].context * 0.9:
            yield start, i
            start = i
    if calls:
        yield start, len(calls)


def attribute(calls):
    """(added, turns) per source: unique tokens, and tokens times the calls
    that re-read them. Summed over sources, turns equals the billed total."""
    added = collections.Counter()
    turns = collections.Counter()
    for start, end in segments(calls):
        added[PREFIX] += calls[start].context
        turns[PREFIX] += calls[start].context * (end - start)
        for j in range(start, end - 1):
            remaining = end - 1 - j
            delta = calls[j + 1].context - calls[j].context
            if delta < 0:
                # Context that left mid-segment, below the reset threshold:
                # thinking blocks falling out at a turn boundary. The calls
                # that follow never re-read it, so its contribution is
                # negative. Dropping the term instead inflates the total.
                turns[SHRINK] += delta * remaining
                added[SHRINK] += delta
                continue
            keep = min(calls[j].output, delta)
            turns[MODEL] += keep * remaining
            added[MODEL] += keep
            source = f"result:{calls[j].tool}" if calls[j].tool else USER
            turns[source] += (delta - keep) * remaining
            added[source] += delta - keep
    return added, turns


def subagent_paths(path):
    """Transcripts of the subagents this session dispatched.

    The harness writes them under a directory named for the session, beside
    the session's own transcript.
    """
    return sorted(glob.glob(os.path.join(path.removesuffix(".jsonl"),
                                         "subagents", "*.jsonl")))


def rank(sorted_values, quantile):
    """Nearest-rank quantile. At 0.5 over an even count this is the upper
    median, which is the conservative side for a cost figure."""
    index = min(int(len(sorted_values) * quantile), len(sorted_values) - 1)
    return sorted_values[index]


def report(path, calls):
    """Print one session's figures as greppable key/value lines. Returns the
    billed total and the attributed total for the caller's identity check."""
    total = sum(call.context for call in calls)
    print(f"== {path.rsplit('/', 1)[-1].removesuffix('.jsonl')} ==")
    print(f"calls: {len(calls)}")
    print(f"billed_context: {total}")
    print(f"output_tokens: {sum(call.output for call in calls)}")
    # Subagents spend their tokens under their own context, so they roll up
    # beside the session's figures rather than into them.
    paths = subagent_paths(path)
    sub = [call for sub_path in paths for call in read_calls(sub_path)]
    print(f"subagents: count={len(paths)} calls={len(sub)} "
          f"billed_context={sum(call.context for call in sub)}")
    if not calls:
        return total, total
    contexts = sorted(call.context for call in calls)
    print(f"ctx_median: {rank(contexts, 0.5)}")
    print(f"ctx_p90: {rank(contexts, 0.9)}")
    print(f"ctx_max: {contexts[-1]}")
    added, turns = attribute(calls)
    for source, count in turns.most_common():
        print(f"src {source}: added={added[source]} turns={count}")
    attributed = sum(turns.values())
    print(f"attributed: {attributed}")
    return total, attributed


def projects_root():
    """Where the harness keeps transcripts, honouring CLAUDE_CONFIG_DIR so a
    test can point the tool at a throwaway tree."""
    config = os.environ.get("CLAUDE_CONFIG_DIR") or os.path.dirname(
        os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(config, "projects")


def recent_sessions(count):
    """The count most recently written session transcripts, newest first."""
    paths = glob.glob(os.path.join(projects_root(), "*", "*.jsonl"))
    return sorted(paths, key=os.path.getmtime, reverse=True)[:count]


def parse_args(argv):
    parser = argparse.ArgumentParser(
        description="Report the context cost of Claude Code sessions.")
    parser.add_argument("path", nargs="?", help="transcript to report")
    parser.add_argument("--session", help="transcript to report")
    parser.add_argument("--last", type=int, metavar="N",
                        help="report the N most recently written sessions")
    args = parser.parse_args(argv)
    paths = recent_sessions(args.last) if args.last else []
    single = args.session or args.path
    if single:
        paths.append(single)
    if not paths:
        parser.error("give a transcript path, --session PATH, or --last N")
    return paths


def main(argv):
    status = 0
    for path in parse_args(argv[1:]):
        try:
            total, attributed = report(path, read_calls(path))
        except OSError as error:
            print(f"cannot read {path}: {error.strerror}", file=sys.stderr)
            status = 1
            continue
        if attributed != total:
            print(f"identity check failed for {path}: "
                  f"attributed {attributed} != billed {total}", file=sys.stderr)
            status = 1
    return status


if __name__ == "__main__":
    sys.exit(main(sys.argv))
