#!/bin/bash

solve() {
    best_height=-10000
    best_x=0
    best_y=0
    distinct_vels=0

    target_x0=235
    target_x1=259
    target_y0=-118
    target_y1=-62

    for ((x_vel = 0 ; x_vel < 300 ; x_vel++)); do
        for ((y_vel = -150 ; y_vel < 150 ; y_vel++)); do
            max_y=-10000
            overshot=0
            x=0
            y=0
            curr_x_vel=x_vel
            curr_y_vel=y_vel

            while ! [[ $x -ge $target_x0 && $x -le $target_x1 && $y -ge $target_y0 && $y -le $target_y1 ]]; do
                x=$((x + curr_x_vel))
                y=$((y + curr_y_vel))
                if [[ $curr_x_vel -gt 0 ]]; then
                    curr_x_vel=$((curr_x_vel - 1))
                elif [[ $curr_x_vel -lt 0 ]]; then
                    curr_x_vel=$((curr_x_vel + 1))
                fi
                curr_y_vel=$((curr_y_vel - 1))

                if [[ $x -gt $target_x1 || $y -lt $target_y0 ]]; then
                    overshot=1
                    break
                fi

                if [[ $y -gt $max_y ]]; then
                    max_y=$y
                fi
            done

            if [[ $overshot -eq 0 ]]; then
                distinct_vels=$((distinct_vels + 1))
                if [[ $max_y -gt $best_height ]]; then
                    best_height=$max_y
                    best_x=$x_vel
                    best_y=$y_vel
                fi
            fi
            
        done
    done

    echo "Part 1: A velocity of ($best_x, $best_y) gives a height of $best_height"
    echo "Part 2: $distinct_vels distinct velocities were found"
}


solve