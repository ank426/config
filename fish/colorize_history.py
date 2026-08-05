#!/usr/bin/python3

import os
import re
import secrets
import subprocess
import sys

BATCH_SIZE = 500
TIME_LEN = 19
GRAY = b'\x1b[90m'
PREFIX = GRAY + b'               \xe2\x94\x82 ' # │

DELIM = b'# __HIST_DELIM_' + secrets.token_hex(8).encode() + b'__'

stdout = sys.stdout.buffer
ansi_re = re.compile(rb'\x1b\[[0-9;]*m')


def visible(line):
    return ansi_re.sub(b'', line)


entries = sys.stdin.buffer.read().split(b'\0')
entries.pop() # trailing empty from NUL terminator


def indent_batch(cmds):
    joined = (b'\n\n' + DELIM + b'\n').join(cmds)
    out = subprocess.run(
        ['fish_indent', '--ansi'],
        input=joined,
        capture_output=True,
    ).stdout

    # fish_indent leaves a blank line around the delimiter; skip blanks
    # immediately after each delimiter, then trim trailing blanks per chunk.
    chunks = [[]]
    skip_blank = False
    for line in out.split(b'\n'):
        stripped = visible(line).rstrip()
        if stripped == DELIM:
            chunks.append([])
            skip_blank = True
        elif skip_blank and not stripped:
            continue
        else:
            chunks[-1].append(line)
            skip_blank = False

    for ch in chunks:
        while len(ch) > 1 and not visible(ch[-1]).strip():
            ch.pop()

    return chunks


def emit(time, lines):
    buf = [GRAY, time]
    color = GRAY
    for k, line in enumerate(lines):
        if k > 0:
            buf.extend((b'\n', PREFIX, color))
        buf.append(line)
        m = ansi_re.findall(line)
        if m:
            color = m[-1]
    buf.append(b'\0')

    try:
        stdout.write(b''.join(buf))
    except BrokenPipeError:
        # redirect stdout so interpreter shutdown flush doesn't re-raise
        os.dup2(os.open(os.devnull, os.O_WRONLY), sys.stdout.fileno())
        sys.exit(0)


for i in range(0, len(entries), BATCH_SIZE):
    batch = entries[i : i + BATCH_SIZE]
    times = [e[:TIME_LEN] for e in batch]
    cmds = [e[TIME_LEN:] for e in batch]

    chunks = indent_batch(cmds)

    # Fallback: a malformed entry corrupted the split. Re-indent individually
    # so one bad entry only affects itself.
    if len(chunks) != len(cmds):
        chunks = [indent_batch([cmd])[0] for cmd in cmds]

    for t, ch in zip(times, chunks):
        emit(t, ch)
