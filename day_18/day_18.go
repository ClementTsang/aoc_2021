package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

type Node struct {
	left   *Node
	right  *Node
	parent *Node
	value  int
}

type Pair struct {
	value int
	depth int
}

func string_to_tree(root *Node, text string) {
	if len(text) == 0 {
		return
	}

	var s = string(text[0])
	var rest = ""
	if len(text) >= 2 {
		rest = text[1:]
	}

	if s == "[" {
		new_node := &Node{
			parent: root,
		}
		root.left = new_node
		string_to_tree(new_node, rest)

	} else if s == "," {
		new_node := &Node{
			parent: root,
		}
		root.right = new_node
		string_to_tree(new_node, rest)

	} else if s == "]" {
		string_to_tree(root.parent, rest)
	} else {
		val, err := strconv.Atoi(s)
		if err == nil {
			root.value = val
		}
		string_to_tree(root.parent, rest)
	}
}

func print_tree(root *Node, depth int) {
	if root.left != nil && root.right != nil {
		print_tree(root.left, depth+1)
		print_tree(root.right, depth+1)
	} else {
		print(strings.Repeat("->", depth))
		println(root.value)
	}
}

func flatten_tree(root *Node, depth int) []Pair {
	arr := make([]Pair, 0)

	if root.left != nil && root.right != nil {
		arr = append(arr, flatten_tree(root.left, depth+1)...)
		arr = append(arr, flatten_tree(root.right, depth+1)...)
	} else {
		arr = append(arr, Pair{
			value: root.value,
			depth: depth,
		})
	}

	return arr
}

func print_flat(arr []Pair) {
	for _, p := range arr {
		fmt.Printf("%d -> %d\n", p.value, p.depth)
	}
}

func clean_explosion(arr []Pair, start int, end int, depth int) []Pair {
	s := make([]Pair, len(arr[:start]))
	copy(s, arr[:start])
	e := make([]Pair, len(arr[end+1:]))
	copy(e, arr[end+1:])
	return append(append(s, Pair{
		value: 0,
		depth: depth - 1,
	}), e...)
}

func try_explode(arr []Pair) (bool, []Pair) {
	l := len(arr)
	for i := 0; i < (l - 1); i++ {
		a := arr[i]
		b := arr[i+1]

		if a.depth >= 5 && a.depth == b.depth {
			// Flatten!
			if i > 0 {
				arr[i-1].value += a.value
			}

			if (i + 1) < (l - 1) {
				arr[i+2].value += b.value
			}

			return true, clean_explosion(arr, i, i+1, a.depth)
		}
	}

	return false, arr
}

func clean_split(arr []Pair, index int, depth int, left int, right int) []Pair {
	new_vals := []Pair{
		{
			value: left,
			depth: depth + 1,
		},
		{
			value: right,
			depth: depth + 1,
		},
	}
	s := make([]Pair, len(arr[:index]))
	copy(s, arr[:index])
	e := make([]Pair, len(arr[index+1:]))
	copy(e, arr[index+1:])
	return append(append(s, new_vals...), e...)
}

func try_split(arr []Pair) (bool, []Pair) {
	l := len(arr)
	for i := 0; i < l; i++ {
		a := arr[i]

		if a.value >= 10 {
			left := a.value / 2
			right := (a.value + 2 - 1) / 2

			return true, clean_split(arr, i, a.depth, left, right)
		}
	}

	return false, arr
}

func combine_tree(root []Pair, src []Pair) []Pair {
	was_empty := len(root) == 0
	res := append(root, src...)

	if !was_empty {
		l := len(res)
		for i := 0; i < l; i++ {
			res[i].depth += 1
		}
	}

	return res
}

func clean_magnitude(arr []Pair, index int, depth int, value int) []Pair {
	s := make([]Pair, len(arr[:index]))
	copy(s, arr[:index])
	e := make([]Pair, len(arr[index+2:]))
	copy(e, arr[index+2:])
	return append(append(s, Pair{
		value: value,
		depth: depth - 1,
	}), e...)
}

func magnitude(root []Pair) int {
	for {
		changed := false
		l := len(root)

		for i := 0; i < (l - 1); i++ {
			a := root[i]
			b := root[i+1]

			if a.depth == b.depth {
				root = clean_magnitude(root, i, a.depth, (a.value*3 + b.value*2))
				changed = true
				// This break ASSUMES that starting from the top is valid... this is jank, could fix but it works so...?
				break
			}
		}

		if !changed {
			break
		}
	}

	return (root[0].value)
}

func part_one(file string) {
	f, err := os.Open(file)
	if err != nil {
		return
	}

	scanner := bufio.NewScanner(f)
	root_arr := make([]Pair, 0)
	numbers := make([][]Pair, 0)
	for scanner.Scan() {
		root := &Node{}
		string_to_tree(root, scanner.Text())
		arr := flatten_tree(root, 0)

		arr_copy := make([]Pair, len(arr))
		copy(arr_copy, arr)
		numbers = append(numbers, arr_copy)

		root_arr = combine_tree(root_arr, arr)

		for {
			exploded, new_arr := try_explode(root_arr)
			root_arr = new_arr

			if !exploded {
				split, new_arr := try_split(root_arr)
				root_arr = new_arr
				if !split {
					break
				}
			}
		}
	}
	fmt.Printf("Part 1 - %d\n", magnitude(root_arr))

	num_copies := len(numbers)
	mags := make([]int, 0)
	for i := 0; i < num_copies; i++ {
		for j := 0; j < num_copies; j++ {
			if i != j {
				a := make([]Pair, len(numbers[i]))
				b := make([]Pair, len(numbers[j]))

				copy(a, numbers[i])
				copy(b, numbers[j])

				tree := combine_tree(a, b)

				for {
					exploded, new_arr := try_explode(tree)
					tree = new_arr

					if !exploded {
						split, new_arr := try_split(tree)
						tree = new_arr
						if !split {
							break
						}
					}
				}

				mags = append(mags, magnitude(tree))
			}
		}
	}
	max_val := mags[0]
	for _, v := range mags {
		if v > max_val {
			max_val = v
		}
	}
	fmt.Printf("Part 2 - %d\n", max_val)
}

func main() {
	var file = "input.txt"
	if len(os.Args) > 1 {
		file = os.Args[1]
	}
	part_one(file)
}
