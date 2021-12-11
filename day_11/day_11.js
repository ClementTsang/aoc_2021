const fs = require("fs");

class ObjectSet extends Set {
  add(elem) {
    return super.add(typeof elem === "object" ? JSON.stringify(elem) : elem);
  }
  has(elem) {
    return super.has(typeof elem === "object" ? JSON.stringify(elem) : elem);
  }
}

let part_one = (file, steps) => {
  let arr = fs.readFileSync(file).toString().split("\n");
  let grid = [];
  for (let line of arr) {
    let row = [];
    for (let c of line) {
      row.push(parseInt(c));
    }

    grid.push(row);
  }

  const grid_height = grid.length;
  const grid_length = grid[0].length;

  let flashes = 0;

  for (let i = 0; i < steps; ++i) {
    // Increase all by 1
    for (let j = 0; j < grid_height; ++j) {
      for (let l = 0; l < grid_length; ++l) {
        grid[j][l] += 1;
      }
    }

    // Flash anything with 9, repeat until done
    let to_pulse = [];
    let seen = new ObjectSet();

    for (let j = 0; j < grid_height; ++j) {
      for (let l = 0; l < grid_length; ++l) {
        if (grid[j][l] > 9) {
          to_pulse.push([j, l]);
          seen.add([j, l]);
        }
      }
    }

    while (to_pulse.length > 0) {
      let [j, l] = to_pulse.pop();

      for (let a = -1; a <= 1; ++a) {
        for (let b = -1; b <= 1; ++b) {
          let m = a + j;
          let n = b + l;

          if (
            m >= 0 &&
            m < grid_height &&
            n >= 0 &&
            n < grid_length &&
            !(m === j && n === l)
          ) {
            grid[m][n] += 1;
            if (grid[m][n] > 9) {
              if (!seen.has([m, n])) {
                to_pulse.push([m, n]);
                seen.add([m, n]);
              }
            }
          }
        }
      }

      flashes += 1;
    }

    for (let s of seen) {
      let j = parseInt(s[1]);
      let l = parseInt(s[3]);
      grid[j][l] = 0;
    }
  }

  console.log(`Part 1 - flashes: ${flashes}`);
};

let part_two = (file, steps) => {
  let arr = fs.readFileSync(file).toString().split("\n");
  let grid = [];
  for (let line of arr) {
    let row = [];
    for (let c of line) {
      row.push(parseInt(c));
    }

    grid.push(row);
  }

  const grid_height = grid.length;
  const grid_length = grid[0].length;
  let step = 0;

  while (true) {
    step += 1;
    // Increase all by 1
    for (let j = 0; j < grid_height; ++j) {
      for (let l = 0; l < grid_length; ++l) {
        grid[j][l] += 1;
      }
    }

    // Flash anything with 9, repeat until done
    let to_pulse = [];
    let seen = new ObjectSet();

    for (let j = 0; j < grid_height; ++j) {
      for (let l = 0; l < grid_length; ++l) {
        if (grid[j][l] > 9) {
          to_pulse.push([j, l]);
          seen.add([j, l]);
        }
      }
    }

    while (to_pulse.length > 0) {
      let [j, l] = to_pulse.pop();

      for (let a = -1; a <= 1; ++a) {
        for (let b = -1; b <= 1; ++b) {
          let m = a + j;
          let n = b + l;

          if (
            m >= 0 &&
            m < grid_height &&
            n >= 0 &&
            n < grid_length &&
            !(m === j && n === l)
          ) {
            grid[m][n] += 1;
            if (grid[m][n] > 9) {
              if (!seen.has([m, n])) {
                to_pulse.push([m, n]);
                seen.add([m, n]);
              }
            }
          }
        }
      }
    }

    let count = 0;
    for (let s of seen) {
      let j = parseInt(s[1]);
      let l = parseInt(s[3]);
      grid[j][l] = 0;
      count += 1;
    }
    if (count == grid_height * grid_length) {
      console.log(`Part 2 - step ${step}`);
      return;
    }
  }
};

part_one("input.txt", 100);
part_two("input.txt");
