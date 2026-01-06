#!/usr/bin/python

import re
import subprocess
import sys

BATCH_SIZE = 500
TIME_LEN = 19
GRAY = b'\x1b[90m'
PREFIX = GRAY + b'               \xe2\x94\x82 ' # │

stdout = sys.stdout.buffer
ansi_re = re.compile(rb'\x1b\[[0-9;]*m')

entries = sys.stdin.buffer.read().split(b'\0')
entries.pop()

n = len(entries)
for i in range(0, n, BATCH_SIZE):
    batch = entries[i : i + BATCH_SIZE]

    times = []
    cmds = []
    num_lines = []
    for entry in batch:
        times.append(entry[:TIME_LEN])
        cmd = entry[TIME_LEN:]
        cmds.append(cmd)
        num_lines.append(cmd.count(b'\n') + 1)

    out, _ = subprocess.Popen(
        ['fish_indent', '--ansi'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,  # err comes to _
    ).communicate(input=b'\n'.join(cmds))
    lines = out.split(b'\n')

    j = 0
    color = GRAY
    for t, nl in zip(times, num_lines):
        buf = [GRAY, t]

        for _ in range(nl-1):
            line = lines[j]
            j += 1
            buf.append(line)

            m = ansi_re.findall(line)
            if m:
                color = m[-1]

            buf.append(b'\n')
            buf.append(PREFIX)
            buf.append(color)

        buf.append(lines[j])
        j += 1
        buf.append(b'\0')

        try:
            stdout.write(b''.join(buf))
        except BrokenPipeError:
            import os
            os.dup2(os.open(os.devnull, os.O_WRONLY), sys.stdout.fileno())
            sys.exit(0)
