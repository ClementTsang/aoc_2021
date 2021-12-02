#!/usr/bin/env swipl

main :-
    open('input.txt', read, Stream),
    Posn = 0,
    Depth = 0,
    read_lines(Stream,  Posn, Depth, _, _),
    
    close(Stream).

% Line reading code based on https://stackoverflow.com/a/56025576
read_lines(S, CP, CD, NP, ND) :- 
    read_line_to_codes(S, L), 
    (
        read_line(L, CP, CD, NP, ND),
        read_lines(S, NP, ND, _, _);
        NP is CP,
        ND is CD,
        write("Position: "), write(NP), nl,
        write("Depth: "), write(ND), nl,
        Product is NP * ND,
        write("Answer: "), write(Product), nl
    ).

read_line(end_of_file, _, _, _, _) :- !, fail.
read_line(L, Posn, Depth, NewPosn, NewDepth) :-
    atom_codes(Str, L),
    split_string(Str, ' ', ' ', SplitString),
    nth0(0, SplitString, Direction),
    nth0(1, SplitString, AmountStr),
    atom_number(AmountStr, Amount),
    pilot(Direction, Amount, Posn, Depth, NewPosn, NewDepth).

pilot(Direction, Amount, Posn, Depth, NewPosn, NewDepth) :-
    Direction == "forward",
    NewPosn is Posn + Amount,
    NewDepth is Depth.

pilot(Direction, Amount, Posn, Depth, NewPosn, NewDepth) :-
    Direction == "up",
    NewPosn is Posn,
    NewDepth is Depth - Amount.

pilot(Direction, Amount, Posn, Depth, NewPosn, NewDepth) :-
    Direction == "down",
    NewPosn is Posn,
    NewDepth is Depth + Amount.