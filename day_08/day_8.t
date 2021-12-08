% AoC Day 8

type DigitSet : set of 'a' .. 'g'

function get_digit (input : DigitSet, map : array 1 .. 10 of DigitSet) : int
    for i : 1 .. upper (map)
	if map (i) = input then
	    if i = 10 then
		result 0
	    else
		result i
	    end if
	end if
    end for
end get_digit


procedure part_one
    var stream : int
    var line := ""
    var delim : string := " | "
    var digit_count : int := 0

    open : stream, "input.txt", get

    loop
	exit when eof (stream)
	get : stream, line : *

	for i : 1 .. (length (line) - length (delim) + 1)
	    if line (i .. i + length (delim) - 1) = delim then

		var outputs := Str.Trim (line ((i + length (delim)) .. length (line)))
		var start : int := 1

		for k : 1 .. length (outputs)
		    if outputs (k) = " " then
			var s : string := outputs (start .. k - 1)
			if length (s) = 2 or length (s) = 4 or length (s) = 8 or length (s) = 3 then
			    digit_count := digit_count + 1
			end if

			start := k + 1
		    elsif k = length (outputs) then
			var s : string := outputs (start .. k)

			if length (s) = 2 or length (s) = 4 or length (s) = 8 or length (s) = 3 then
			    digit_count := digit_count + 1
			end if
		    end if
		end for
		exit
	    end if
	end for
    end loop

    put "Part 1: ", digit_count

    close : stream
end part_one

procedure part_two
    var stream : int
    var line := ""
    var delim : string := " | "
    var sum : int := 0

    open : stream, "input.txt", get

    loop
	exit when eof (stream)
	get : stream, line : *

	for i : 1 .. (length (line) - length (delim) + 1)
	    if line (i .. i + length (delim) - 1) = delim then

		var signals := Str.Trim (line (1 .. (i - 1)))
		var outputs := Str.Trim (line ((i + length (delim)) .. length (line)))
		var local_sum := 0

		% We need to determine the signal mapping...
		%
		% Note we treat 0 as 10 here, just for easier mapping.
		var max_digit := 0

		var map : array 1 .. 10 of DigitSet
		var length_fives : array 1 .. 3 of DigitSet
		var length_sixes : array 1 .. 3 of DigitSet

		var five_counter := 1
		var six_counter := 1

		var start := 1
		for k : 1 .. length (signals)
		    if signals (k) = " " then
			var s : string := signals (start .. k - 1)
			if length (s) = 2 then
			    map (1) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (1) := map (1) + DigitSet (ch)
			    end for
			elsif length (s) = 3 then
			    map (7) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (7) := map (7) + DigitSet (ch)
			    end for
			elsif length (s) = 4 then
			    map (4) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (4) := map (4) + DigitSet (ch)
			    end for
			elsif length (s) = 7 then
			    map (8) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (8) := map (8) + DigitSet (ch)
			    end for
			elsif length (s) = 5 then
			    length_fives (five_counter) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				length_fives (five_counter) := length_fives (five_counter) + DigitSet (ch)
			    end for
			    five_counter := five_counter + 1
			elsif length (s) = 6 then
			    length_sixes (six_counter) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				length_sixes (six_counter) := length_sixes (six_counter) + DigitSet (ch)
			    end for
			    six_counter := six_counter + 1
			end if

			start := k + 1
		    elsif k = length (signals) then
			var s : string := signals (start .. k)
			if length (s) = 2 then
			    map (1) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (1) := map (1) + DigitSet (ch)
			    end for
			elsif length (s) = 3 then
			    map (7) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (7) := map (7) + DigitSet (ch)
			    end for
			elsif length (s) = 4 then
			    map (4) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (4) := map (4) + DigitSet (ch)
			    end for
			elsif length (s) = 7 then
			    map (8) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				map (8) := map (8) + DigitSet (ch)
			    end for
			elsif length (s) = 5 then
			    length_fives (five_counter) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				length_fives (five_counter) := length_fives (five_counter) + DigitSet (ch)
			    end for
			    five_counter := five_counter + 1
			elsif length (s) = 6 then
			    length_sixes (six_counter) := DigitSet ()
			    for t : 1 .. length (s)
				var ch : char := s (t)
				length_sixes (six_counter) := length_sixes (six_counter) + DigitSet (ch)
			    end for
			    six_counter := six_counter + 1
			end if
		    end if
		end for

		var six_index := 0
		var c_sub : char
		for k : 1 .. upper (length_sixes)
		    var tmp := map (1) - length_sixes (k)
		    var tmp_two := length_sixes (k) + map (1)
		    if tmp_two not= length_sixes (k) then
			six_index := k
			if 'a' in tmp then
			    c_sub := 'a'
			elsif 'b' in tmp then
			    c_sub := 'b'
			elsif 'c' in tmp then
			    c_sub := 'c'
			elsif 'd' in tmp then
			    c_sub := 'd'
			elsif 'e' in tmp then
			    c_sub := 'e'
			elsif 'f' in tmp then
			    c_sub := 'f'
			elsif 'g' in tmp then
			    c_sub := 'g'
			end if
			map (6) := length_sixes (k)
			exit
		    end if
		end for

		var zero_index := 0
		for k : 1 .. upper (length_sixes)
		    if k not= six_index then
			var tmp := length_sixes (k) + map (4)
			if tmp not= length_sixes (k) then
			    zero_index := k
			    map (10) := length_sixes (k)
			    exit
			end if
		    end if
		end for

		for k : 1 .. upper (length_sixes)
		    if (k not= six_index and k not= zero_index) then
			map (9) := length_sixes (k)
			exit
		    end if
		end for

		var three_index := 0
		for k : 1 .. upper (length_fives)
		    var tmp := length_fives (k) + map (1)
		    if length_fives (k) = tmp then
			three_index := k
			map (3) := length_fives (k)
		    end if
		end for

		for k : 1 .. upper (length_fives)
		    if (k not= three_index) then
			if c_sub in length_fives (k) then
			    map (2) := length_fives (k)
			else
			    map (5) := length_fives (k)
			end if
		    end if
		end for

		start := 1
		for k : 1 .. length (outputs)
		    if outputs (k) = " " then
			var s : string := outputs (start .. k - 1)
			var s_set := DigitSet ()
			for t : 1 .. length (s)
			    var ch : char := s (t)
			    s_set := s_set + DigitSet (ch)
			end for
			var digit := get_digit (s_set, map)
			local_sum := local_sum * 10 + digit
			start := k + 1
		    elsif k = length (outputs) then
			var s : string := outputs (start .. k)
			var s_set := DigitSet ()
			for t : 1 .. length (s)
			    var ch : char := s (t)
			    s_set := s_set + DigitSet (ch)
			end for
			var digit := get_digit (s_set, map)
			local_sum := local_sum * 10 + digit
		    end if
		end for

		sum := sum + local_sum
	    end if

	end for
    end loop

    put "Part 2: ", sum

    close : stream
end part_two

part_one
part_two
