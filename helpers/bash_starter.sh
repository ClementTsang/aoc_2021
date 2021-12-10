#!/bin/bash

part_1() {
    result=0

    while IFS= read -r line || [ -n "$line" ]; do
        IFS=' '
        read -ra split <<< "$line"
        for i in "${split[@]}"; do
            echo "$i" | xargs
        done
    done < "$1"

    echo "Part 1: $result"
}

part_2() {
    result=0
    echo "Part 2: $result"
}

part_1 $1
part_2 $1