#!/usr/bin/php

<?php

function partOne($filename) {
    $file = new SplFileObject($filename);

    $overlap = 0;
    $seen = array();

    while (!$file->eof()) {
        $line = trim($file->fgets());
        if ($line == '') {
            continue;
        }
        [$start, $end] = explode('->', $line, 2);
        [$x1, $y1] = array_map('trim', explode(",", $start, 2));
        [$x2, $y2] = array_map('trim', explode(",", $end, 2));

        if ($x1 != $x2 && $y1 != $y2) {
            continue;
        }

        $x_range = range($x1, $x2);
        $y_range = range($y1, $y2);

        foreach ($x_range as $x) {
            foreach ($y_range as $y) {
                if (isset($seen[$x][$y])) {
                    $seen[$x][$y] += 1;
                } else {
                    $seen[$x][$y] = 0;
                }

                if ($seen[$x][$y] == 1) {
                    $overlap += 1;
                }
            }
        }
    }

    echo "Part 1: $overlap\n";

    $file = null;
}

function partTwo($filename) {
    $file = new SplFileObject($filename);

    $overlap = 0;
    $seen = array();

    while (!$file->eof()) {
        $line = trim($file->fgets());
        if ($line == '') {
            continue;
        }
        [$start, $end] = explode('->', $line, 2);
        [$x1, $y1] = array_map('trim', explode(",", $start, 2));
        [$x2, $y2] = array_map('trim', explode(",", $end, 2));

        $x_range = range($x1, $x2);
        $y_range = range($y1, $y2);

        if ($x1 != $x2 && $y1 != $y2) {
            $ranges = array_combine($x_range, $y_range);

            foreach ($ranges as $x => $y) {
                if (isset($seen[$x][$y])) {
                    $seen[$x][$y] += 1;
                } else {
                    $seen[$x][$y] = 0;
                }
    
                if ($seen[$x][$y] == 1) {
                    $overlap += 1;
                }
            }
        }
        else {    
            foreach ($x_range as $x) {
                foreach ($y_range as $y) {
                    if (isset($seen[$x][$y])) {
                        $seen[$x][$y] += 1;
                    } else {
                        $seen[$x][$y] = 0;
                    }
    
                    if ($seen[$x][$y] == 1) {
                        $overlap += 1;
                    }
                }
            }
        }
    }

    echo "Part 2: $overlap\n";

    $file = null;
}


$filename = "";
if ($argc != 2) {
    $filename = "input.txt";
}
else {
    $filename = $argv[1];
}
echo "File name: $filename\n";

partOne($filename);
partTwo($filename);

?>
