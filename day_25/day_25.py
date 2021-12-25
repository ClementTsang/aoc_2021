#!/bin/python3

import sys


def part_one(f: str):
    with open(f) as file:
        lines = file.readlines()

        height = len(lines)
        width = 0
        right = set()
        down = set()

        for (r, line) in enumerate(lines):
            line = line.strip()
            width = len(line)
            if width == 0:
                height -= 1
            for (c, ch) in enumerate(line):
                if ch == ">":
                    right.add((r, c))
                elif ch == "v":
                    down.add((r, c))

        count = 0
        while True:
            count += 1
            new_right = set()
            remove_right = set()
            new_down = set()
            remove_down = set()

            for (r, c) in right:
                new_val = (r, c + 1) if (c + 1) < width else (r, 0)
                if new_val not in right and new_val not in down:
                    new_right.add(new_val)
                    remove_right.add((r, c))

            right = right - remove_right
            right = right.union(new_right)

            for (r, c) in down:
                new_val = (r + 1, c) if (r + 1) < height else (0, c)
                if new_val not in right and new_val not in down:
                    new_down.add(new_val)
                    remove_down.add((r, c))

            down = down - remove_down
            down = down.union(new_down)

            if len(new_right) == 0 and len(new_down) == 0:
                print(count)
                break


f = sys.argv[1] if len(sys.argv) > 1 else "input.txt"
print(f)

part_one(f)
