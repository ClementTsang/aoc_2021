import 'dart:convert';
import 'dart:io';

import 'dart:math';

const encoding = {
  "0": "0000",
  "1": "0001",
  "2": "0010",
  "3": "0011",
  "4": "0100",
  "5": "0101",
  "6": "0110",
  "7": "0111",
  "8": "1000",
  "9": "1001",
  "A": "1010",
  "B": "1011",
  "C": "1100",
  "D": "1101",
  "E": "1110",
  "F": "1111",
};

void part_one(path) {
  new File(path)
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .forEach((line) {
    var code = line.split("").map((s) {
      return encoding[s];
    }).join();

    var ptr = 0;
    var version_sum = 0;

    while (ptr < code.length && (code.length - ptr > 6)) {
      version_sum += int.parse(code.substring(ptr, ptr + 3), radix: 2);
      ptr += 3;
      var packet_type = int.parse(code.substring(ptr, ptr + 3), radix: 2);
      ptr += 3;

      if (packet_type == 4) {
        for (; ptr < code.length; ptr += 5) {
          if (code.substring(ptr, ptr + 1) == "0") {
            break;
          }
        }
        ptr += 5;
      } else {
        var length_type_id = int.parse(code.substring(ptr, ptr + 1), radix: 2);
        ptr += 1;
        if (length_type_id == 0) {
          ptr += 15;
        } else {
          ptr += 11;
        }
      }
    }

    print("Part 1 - version sum is ${version_sum}");
  });
}

class Pointer {
  int itx = 0;
}

void part_two(path) {
  new File(path)
      .openRead()
      .map(utf8.decode)
      .transform(LineSplitter())
      .forEach((line) {
    var c = line.split("").map((s) {
      return encoding[s];
    }).join();

    int evaluate(String code, Pointer ptr) {
      var result = 0;
      ptr.itx += 3;
      var pt = int.parse(code.substring(ptr.itx, ptr.itx + 3), radix: 2);
      ptr.itx += 3;

      List<int> val = List.empty(growable: true);

      if (pt != 4) {
        var lt = code.substring(ptr.itx, ptr.itx + 1);
        ptr.itx += 1;
        if (lt == "0") {
          // 15 bits for length
          var len = int.parse(code.substring(ptr.itx, ptr.itx + 15), radix: 2);
          ptr.itx += 15;

          var new_pointer = Pointer();
          var ss = code.substring(ptr.itx, ptr.itx + len);
          while (new_pointer.itx < len) {
            val.add(evaluate(ss, new_pointer));
          }

          ptr.itx += len;
        } else {
          // 11 bits for number of sub-packets
          var num = int.parse(code.substring(ptr.itx, ptr.itx + 11), radix: 2);
          ptr.itx += 11;

          for (int i = 0; i < num; ++i) {
            val.add(evaluate(code, ptr));
          }
        }
      }

      switch (pt) {
        case 0:
          result += val.reduce((v, e) => v + e);
          break;
        case 1:
          result += val.reduce((v, e) => v * e);
          break;
        case 2:
          result += val.reduce((v, e) => min(v, e));
          break;
        case 3:
          result += val.reduce((v, e) => max(v, e));
          break;
        case 4:
          var val = List.empty(growable: true);
          for (; ptr.itx < code.length; ptr.itx += 5) {
            var bits = code.substring(ptr.itx + 1, ptr.itx + 5).split("");
            val.addAll(bits);
            if (code.substring(ptr.itx, ptr.itx + 1) == "0") {
              break;
            }
          }
          ptr.itx += 5;
          ptr.itx = min(ptr.itx, code.length);
          result += int.parse(val.join(), radix: 2);
          break;
        case 5:
          if (val[0] > val[1]) {
            result += 1;
          }
          break;
        case 6:
          if (val[0] < val[1]) {
            result += 1;
          }
          break;
        case 7:
          if (val[0] == val[1]) {
            result += 1;
          }
          break;
        default:
      }

      return result;
    }

    print("Part 2 - expression is ${evaluate(c, Pointer())}");
  });
}

void main() {
  part_one("input.txt");
  part_two("input.txt");
}
