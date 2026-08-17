#!/usr/bin/env python3
"""Report what a Claude Code session's context actually cost.

The billed input for one API call is the whole window it read, not the
part of it that was new: input_tokens + cache_creation_input_tokens +
cache_read_input_tokens. Summing that across a session gives the figure
the bill tracks, which is context size multiplied by session length
rather than the size of any one document or tool result.

Usage: python3 scripts/context-cost.py <transcript.jsonl>
"""
import json
import sys


def billed(usage):
    """The whole window one API call read, cached or not."""
    return sum(usage.get(k, 0) or 0 for k in (
        "input_tokens",
        "cache_creation_input_tokens",
        "cache_read_input_tokens",
    ))


def read_calls(path):
    """Per-call (billed context, output tokens) pairs, in transcript order.

    Skips every record that is not an assistant turn carrying usage: user
    turns, tool results, and the assistant records the harness writes with
    no usage block. A line that does not parse is skipped rather than
    aborting the run, since a transcript being appended to can end mid-write.
    """
    calls = []
    with open(path, errors="replace") as fh:
        for line in fh:
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
            calls.append((billed(usage), usage.get("output_tokens", 0) or 0))
    return calls


def rank(sorted_values, quantile):
    """Nearest-rank quantile. At 0.5 over an even count this is the upper
    median, which is the conservative side for a cost figure."""
    index = min(int(len(sorted_values) * quantile), len(sorted_values) - 1)
    return sorted_values[index]


def report(path, calls):
    """Print one session's figures as greppable key/value lines."""
    print(f"== {path.rsplit('/', 1)[-1].removesuffix('.jsonl')} ==")
    print(f"calls: {len(calls)}")
    print(f"billed_context: {sum(context for context, _ in calls)}")
    print(f"output_tokens: {sum(output for _, output in calls)}")
    if not calls:
        return
    contexts = sorted(context for context, _ in calls)
    print(f"ctx_median: {rank(contexts, 0.5)}")
    print(f"ctx_p90: {rank(contexts, 0.9)}")
    print(f"ctx_max: {contexts[-1]}")


def main(argv):
    if len(argv) != 2:
        print("usage: context-cost.py <transcript.jsonl>", file=sys.stderr)
        return 2
    report(argv[1], read_calls(argv[1]))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
