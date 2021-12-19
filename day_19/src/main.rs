use std::collections::HashSet;
use std::env;
use std::fs;

fn solve(filename: &str) {
    let text = fs::read_to_string(filename).expect("Couldn't read the input file!");
    let mut scans: Vec<HashSet<[i64; 3]>> = vec![];
    for l in text.lines() {
        if l.starts_with("---") {
            scans.push(HashSet::default());
        } else if !l.is_empty() {
            let p = l
                .split(",")
                .map(|x| x.parse::<i64>().unwrap())
                .collect::<Vec<_>>();
            scans.last_mut().unwrap().insert([p[0], p[1], p[2]]);
        }
    }

    let up_vec = [
        (1, 1, 1),
        (1, -1, 1),
        (1, 1, -1),
        (-1, 1, 1),
        (1, -1, -1),
        (-1, -1, 1),
        (-1, 1, -1),
        (-1, -1, -1),
    ];

    let swaps = [
        (0, 1, 2),
        (0, 2, 1),
        (1, 0, 2),
        (1, 2, 0),
        (2, 0, 1),
        (2, 1, 0),
    ];

    let mut scan_one = scans.remove(0);
    let mut scanners = vec![[0, 0, 0]];
    while !scans.is_empty() {
        'outer: for i in 0..scans.len() {
            let scan_two = &scans[i];

            for up in up_vec {
                for swap in swaps {
                    let scan_two = scan_two
                        .into_iter()
                        .map(|s| [s[swap.0] * up.0, s[swap.1] * up.1, s[swap.2] * up.2])
                        .collect::<Vec<_>>();

                    for a in &scan_one {
                        let diff_scan_one = scan_one
                            .iter()
                            .map(|s| [s[0] - a[0], s[1] - a[1], s[2] - a[2]])
                            .collect::<HashSet<_>>();

                        for b in &scan_two {
                            let diff_scan_two = scan_two
                                .iter()
                                .map(|s| [s[0] - b[0], s[1] - b[1], s[2] - b[2]])
                                .collect::<HashSet<_>>();

                            if diff_scan_one.intersection(&diff_scan_two).count() >= 12 {
                                let mut beacon_set = HashSet::new();
                                for s in &scan_one {
                                    beacon_set.insert(*s);
                                }
                                for s in diff_scan_two {
                                    beacon_set.insert([s[0] + a[0], s[1] + a[1], s[2] + a[2]]);
                                }
                                scanners.push([a[0] - b[0], a[1] - b[1], a[2] - b[2]]);
                                scan_one = beacon_set;
                                scans.remove(i);
                                break 'outer;
                            }
                        }
                    }
                }
            }
        }
    }

    println!("Part 1: {} beacons.", scan_one.len());
    println!(
        "Part 2: Max scanner distance is {}.",
        scanners
            .iter()
            .map(|a| {
                scanners
                    .iter()
                    .map(|b| (a[0] - b[0]).abs() + (a[1] - b[1]).abs() + (a[2] - b[2]).abs())
                    .max()
                    .unwrap_or(0)
            })
            .max()
            .unwrap_or(0)
    );
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let filename = if args.len() > 1 {
        &args[1]
    } else {
        "input.txt"
    };

    solve(filename);
}
