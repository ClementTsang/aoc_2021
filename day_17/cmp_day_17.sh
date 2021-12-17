#!/bin/bash
bh=-10000; bx=0; by=0; dist=0
tx0=235; tx1=259; ty0=-118; ty1=-62
for ((xv = 0 ; xv < 300 ; xv++)); do for ((yv = -150 ; yv < 150 ; yv++)); do
    max_y=-10000; over=0; x=0; y=0; curr_xv=xv; curr_yv=yv
    while ! [[ $x -ge $tx0 && $x -le $tx1 && $y -ge $ty0 && $y -le $ty1 ]]; do
        x=$((x + curr_xv))
        y=$((y + curr_yv))
        curr_yv=$((curr_yv - 1))
        [[ $curr_xv -gt 0 ]] && curr_xv=$((curr_xv - 1))
        [[ $curr_xv -lt 0 ]] && curr_xv=$((curr_xv + 1))
        [[ $x -gt $tx1 || $y -lt $ty0 ]] && over=1 && break
        [[ $y -gt $max_y ]] && max_y=$y
    done
    [[ $over -eq 0 ]] && dist=$((dist + 1)) && [[ $max_y -gt $bh ]] && bh=$max_y && bx=$xv && by=$yv
done done
echo "Part 1: A velocity of ($bx, $by) gives a height of $bh"
echo "Part 2: $dist dist velocities were found"