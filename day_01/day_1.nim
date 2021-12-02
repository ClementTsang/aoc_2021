import strutils

proc sum(arr: seq[int]) : int =
    var sum = 0
    for val in arr:
        sum += val
    return sum

proc part_1() =
    var 
        f: File
        line: string
        count = 0
        prev = 10000000

    if open(f, "input.txt"):
        while f.readLine(line):
            var val = parseInt(line)

            if val > prev:
                count += 1
            
            prev = val

        close(f)

    echo "Part 1: $1" % [$count]

proc part_2() =
    var 
        f: File
        line: string
        count = 0
        window = newSeq[int](0)

    if open(f, "input.txt"):
        while f.readLine(line):
            var val = parseInt(line)

            if window.len == 3:
                var prev = sum(window)
                window.add(val)
                window.delete(0)
                var now = sum(window)

                if now > prev:
                    count += 1
            else:
                window.add(val)

        close(f)

    echo "Part 2: $1" % [$count]



part_1()
part_2()
