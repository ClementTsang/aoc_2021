#!/bin/python3

count = 0

window = []
with open("input.txt") as file:
    lines = file.readlines()

    for line in lines:
        val = int(line)

        if len(window) == 3:
            prev = sum(window)
            window.append(val)
            window.pop(0)
            now = sum(window)

            if now > prev:
                count += 1
        else:
            window.append(val)


print(count)
