#!/bin/bash

part_1() {
    while IFS= read -r line || [ -n "$line" ]; do
        echo "$line"
    done < "$1"
}

part_1 $1