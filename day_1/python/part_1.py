#!/bin/python3

count = 0

prev = 1000000000
with open("../input.txt") as file:
    lines = file.readlines()

    for line in lines:
        val = int(line)

        if val > prev:
            count += 1

        prev = val

print(count)
