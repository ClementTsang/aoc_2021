open Core
open Str

exception Err of string

let read_file file = In_channel.read_lines file

type fold_step = 
  | X of int
  | Y of int
;;

(* From https://stackoverflow.com/a/59302851... apparently tuples aren't valid keys by default?*)
module IntPair = struct
  module T = struct
    type t = int * int
    let compare x y = Tuple2.compare ~cmp1:Int.compare ~cmp2:Int.compare x y
    let sexp_of_t = Tuple2.sexp_of_t Int.sexp_of_t Int.sexp_of_t
    let t_of_sexp = Tuple2.t_of_sexp Int.t_of_sexp Int.t_of_sexp
    let hash = Hashtbl.hash
  end

  include T
  include Comparable.Make(T)
end

let part_one file =
  let lines = read_file file in

  let rec partition lines seen_newline dot_list fold_list = 
    match lines with
    | (head :: tail) -> (
      if seen_newline then
        let fold = match (Str.split_delim (Str.regexp " ") head) with
          | (_fold :: _along :: inst :: _) -> (
            match (Str.split_delim (Str.regexp "=") inst) with
            | (dim :: value :: _) -> (
              if String.(dim = "x") then X(int_of_string(value))
              else Y(int_of_string(value))
            )
            | _ -> raise (Err "impossible")
          )
          | _ -> raise (Err "impossible")
          in
        partition tail seen_newline dot_list (fold_list @ [fold])
      else
        if String.is_empty head then
          partition tail true dot_list fold_list
        else
          let (x, y) = match (Str.split_delim (Str.regexp ",") head) with
          | (x :: y :: _) -> (int_of_string(x), int_of_string(y))
          | _ -> raise (Err "impossible")
          in
          partition tail false (dot_list @ [(x, y)]) fold_list
    )
    | [] -> (dot_list, fold_list)
  in

  let (dot_list, fold_list) = partition lines false [] [] in


  let dot_table = Hashtbl.create (module IntPair) ~size: 1000 in
  
  let build_set table d =
    match Hashtbl.add table ~key: d ~data: "" with
    | `Ok -> ()
    | `Duplicate -> ()
  in

  List.iter ~f: (build_set dot_table) dot_list;

  let update_key instruction k =
    let (x, y) = k in
    match instruction with
    | X(value) -> (
      if value <= x then ((2 * value - x), y)
      else k
    )
    | Y(value) -> (
      if value <= y then (x, (2 * value - y))
      else k
    )
  in

  let dots = match (List.hd fold_list) with
    | Some(instruction) -> (
      Hashtbl.length (
        let h = Hashtbl.create (module IntPair) ~size: 1000 in
        List.iter ~f: (build_set h) (List.map ~f: (update_key instruction) (Hashtbl.keys dot_table));
        h
      )
    )
    | None -> raise (Err "impossible")
  in
  
  printf "Part 1: %d \n" dots;
  ()
;;

let part_two file =
  let lines = read_file file in

  let rec partition lines seen_newline dot_list fold_list = 
    match lines with
    | (head :: tail) -> (
      if seen_newline then
        let fold = match (Str.split_delim (Str.regexp " ") head) with
          | (_fold :: _along :: inst :: _) -> (
            match (Str.split_delim (Str.regexp "=") inst) with
            | (dim :: value :: _) -> (
              if String.(dim = "x") then X(int_of_string(value))
              else Y(int_of_string(value))
            )
            | _ -> raise (Err "impossible")
          )
          | _ -> raise (Err "impossible")
          in
        partition tail seen_newline dot_list (fold_list @ [fold])
      else
        if String.is_empty head then
          partition tail true dot_list fold_list
        else
          let (x, y) = match (Str.split_delim (Str.regexp ",") head) with
          | (x :: y :: _) -> (int_of_string(x), int_of_string(y))
          | _ -> raise (Err "impossible")
          in
          partition tail false (dot_list @ [(x, y)]) fold_list
    )
    | [] -> (dot_list, fold_list)
  in

  let (dot_list, fold_list) = partition lines false [] [] in


  let dot_table = Hashtbl.create (module IntPair) ~size: 1000 in
  
  let build_set table d =
    match Hashtbl.add table ~key: d ~data: "" with
    | `Ok -> ()
    | `Duplicate -> ()
  in

  List.iter ~f: (build_set dot_table) dot_list;

  let update_key instruction k =
    let (x, y) = k in
    match instruction with
    | X(value) -> (
      if value <= x then ((2 * value - x), y)
      else k
    )
    | Y(value) -> (
      if value <= y then (x, (2 * value - y))
      else k
    )
  in

  let rec process_list list set =
    match list with
    | (instruction :: tail) -> (
      let new_set = Hashtbl.create (module IntPair) ~size: 1000 in
      List.iter ~f: (build_set new_set) (List.map ~f: (update_key instruction) (Hashtbl.keys set));
      
      process_list tail new_set
    )
    | [] -> (
      let keys = Hashtbl.keys set in
      let max_x = List.fold keys ~init: 0 ~f: (fun acc b -> Int.max acc (fst b)) in
      let max_y = List.fold keys ~init: 0 ~f: (fun acc b -> Int.max acc (snd b)) in

      let rec build_display y arr =
        let rec build_row x y arr =
          if x > max_x then arr
          else (
            let s = match Hashtbl.find set (x, y) with
            | Some(_) -> "*"
            | None -> " "
            in
            build_row (x + 1) y (arr @ [s])
          )
        in

        if y > max_y then
          arr
        else (
          build_display (y + 1) (arr @ [(build_row 0 y [])])
        )
      in

      build_display 0 []
    )
  in

  let result = process_list fold_list dot_table in

  let rec print_display rows =
    let rec print_row cols = 
      match cols with
      | (h :: t) -> (
        printf "%s" h;
        print_row t
      )
      | [] -> ()
    in

    match rows with
    | (h :: t) -> (
      print_row h;
      printf "\n";
      print_display t
    )
    | [] -> ()
  in

  printf "Part 2: ====================\n";
  print_display result;
;;

let () =
  let file = "input.txt" in
  part_one file;
  part_two file;
;;
