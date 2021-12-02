#!/usr/bin/env swipl

main :-
    open('input.txt', read, Stream),
    Posn = 0,
    Depth = 0,
    Aim = 0,
    read_lines(Stream, Posn, Depth, Aim, _, _, _),
    
    close(Stream).

% Line reading code based on https://stackoverflow.com/a/56025576
read_lines(S, CP, CD, CA, NP, ND, NA) :- 
    read_line_to_codes(S, L), 
    (
        read_line(L, CP, CD, CA, NP, ND, NA),
        read_lines(S, NP, ND, NA, _, _, _);
        NP is CP,
        ND is CD,
        NA is CA,
        write("Position: "), write(NP), nl,
        write("Depth: "), write(ND), nl,
        write("Accuracy: "), write(NA), nl,
        Product is NP * ND,
        write("Answer: "), write(Product), nl
    ).

read_line(end_of_file, _, _, _, _, _, _) :- !, fail.
read_line(L, Posn, Depth, Aim, NewPosn, NewDepth, NewAim) :-
    atom_codes(Str, L),
    split_string(Str, ' ', ' ', SplitString),
    nth0(0, SplitString, Direction),
    nth0(1, SplitString, AmountStr),
    atom_number(AmountStr, Amount),
    pilot(Direction, Amount, Posn, Depth, Aim, NewPosn, NewDepth, NewAim).

pilot(Direction, Amount, Posn, Depth, Aim, NewPosn, NewDepth, NewAim) :-
    Direction == "forward",
    NewPosn is Posn + Amount,
    NewDepth is Depth + (Aim * Amount),
    NewAim is Aim.

pilot(Direction, Amount, Posn, Depth, Aim, NewPosn, NewDepth, NewAim) :-
    Direction == "up",
    NewPosn is Posn,
    NewDepth is Depth,
    NewAim is Aim - Amount.

pilot(Direction, Amount, Posn, Depth, Aim, NewPosn, NewDepth, NewAim) :-
    Direction == "down",
    NewPosn is Posn,
    NewDepth is Depth,
    NewAim is Aim + Amount.