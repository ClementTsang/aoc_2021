import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

class Pair {
    int start;
    int end;

    public Pair(int start, int end) {
        this.start = start;
        this.end = end;
    }
}

class Triple {
    int x;
    int y;
    int z;

    public Triple(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    @Override
    public int hashCode() {
        return (133 * x * y * z + x + y + z);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null) {
            return false;
        }

        if (this.getClass() != o.getClass()) {
            return false;
        }

        Triple other = (Triple) o;
        return (this.x == other.x && this.y == other.y && this.z == other.z);
    }
}

class Cube {
    Pair x;
    Pair y;
    Pair z;

    public Cube(Pair x, Pair y, Pair z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public ArrayList<Cube> subtract(Cube other) {
        var list = new ArrayList<Cube>();

        if (x.end >= other.x.start && x.start <= other.x.end && y.end >= other.y.start && y.start <= other.y.end
                && z.end >= other.z.start && z.start <= other.z.end) {

            var xx = new Pair(Integer.max(x.start, other.x.start), Integer.min(x.end, other.x.end));
            var yy = new Pair(Integer.max(y.start, other.y.start), Integer.min(y.end, other.y.end));
            var zz = new Pair(Integer.max(z.start, other.z.start), Integer.min(z.end, other.z.end));

            var intsersection = new Cube(xx, yy, zz);

            list.add(new Cube(this.x, this.y, new Pair(this.z.start, intsersection.z.start - 1)));
            list.add(new Cube(this.x, this.y, new Pair(intsersection.z.end + 1, this.z.end)));
            list.add(new Cube(intsersection.x, new Pair(this.y.start, intsersection.y.start - 1), intsersection.z));
            list.add(new Cube(intsersection.x, new Pair(intsersection.y.end + 1, this.y.end), intsersection.z));
            list.add(new Cube(new Pair(this.x.start, intsersection.x.start - 1), this.y, intsersection.z));
            list.add(new Cube(new Pair(intsersection.x.end + 1, this.x.end), this.y, intsersection.z));
        } else {
            list.add(this);
        }

        return list;

    }
}

class Day22 {
    static Pair parsePair(String line) {
        var vals = line.split("=")[1].split("\\.\\.");
        return new Pair(Integer.parseInt(vals[0].trim()), Integer.parseInt(vals[1].trim()));
    }

    static void part_one(String file) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line;

            HashMap<Triple, Boolean> state = new HashMap<Triple, Boolean>();

            while ((line = reader.readLine()) != null) {
                var split = line.split(" ", 2);

                var on = split[0].equals("on");
                var coords = split[1].split(",", 3);
                var x = parsePair(coords[0]);
                var y = parsePair(coords[1]);
                var z = parsePair(coords[2]);

                if (x.start < -50 || x.end > 50 || y.start < -50 || y.end > 50 || z.start < -50 || z.end > 50) {
                    continue;
                }

                for (var a = x.start; a <= x.end; ++a) {
                    for (var b = y.start; b <= y.end; ++b) {
                        for (var c = z.start; c <= z.end; ++c) {
                            var triple = new Triple(a, b, c);
                            state.put(triple, on);
                        }
                    }
                }
            }

            var count = 0;
            for (var s : state.values()) {
                if (s) {
                    count += 1;
                }
            }
            System.out.println("Part 1: " + count);

            reader.close();
        } catch (IOException e) {
            // Bah
        }
    }

    static void part_two(String file) {
        try {
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line;

            var onCubes = new ArrayList<Cube>();

            while ((line = reader.readLine()) != null) {
                var split = line.split(" ", 2);

                var on = split[0].equals("on");
                var coords = split[1].split(",", 3);
                var x = parsePair(coords[0]);
                var y = parsePair(coords[1]);
                var z = parsePair(coords[2]);

                var cube = new Cube(x, y, z);
                var newOnCubes = new ArrayList<Cube>();
                for (var c : onCubes) {
                    var results = c.subtract(cube);
                    for (var r : results) {
                        if (r.x.start <= r.x.end && r.y.start <= r.y.end && r.z.start <= r.z.end) {
                            newOnCubes.add(r);
                        }
                    }
                }

                if (on) {
                    newOnCubes.add(cube);
                }

                onCubes = newOnCubes;

            }

            long count = 0;
            for (var cube : onCubes) {
                long c = (long) Math.abs(cube.x.end - cube.x.start + 1) * (long) Math.abs(cube.y.end - cube.y.start + 1)
                        * (long) Math.abs(cube.z.end - cube.z.start + 1);
                count += c;
            }
            System.out.println("Part 2: " + count);

            reader.close();
        } catch (IOException e) {
            // Bah
        }
    }

    public static void main(String[] args) {
        var file = "input.txt";
        if (args.length >= 1) {
            file = args[0];
        }

        part_one(file);
        part_two(file);
    }
}