open System.Collections.Generic

let buildCrossed old x y =
    let rec readCols row x y (acc: list<_>) =
        match row with
        | head :: tail -> readCols tail (x - 1) y (acc @ [ head || ((x = 0) && (y = 0)) ])
        | [] -> acc

    let rec readRows crossed x y (acc: list<list<_>>) =
        match crossed with
        | head :: tail -> readRows tail x (y - 1) (acc @ [ readCols head x y [] ])
        | [] -> acc

    readRows old x y []

type Board(dict: Dictionary<_, _>, s: int) =
    let values: Dictionary<int, (int * int)> = new Dictionary<_, _>(dict)

    let mutable crossedRow: list<list<bool>> =
        [ for _ in 1 .. 5 -> [ for _ in 1 .. 5 -> false ] ]

    let mutable crossedCol: list<list<bool>> =
        [ for _ in 1 .. 5 -> [ for _ in 1 .. 5 -> false ] ]

    let mutable sum: int = s

    member this.Sum = sum

    member this.SeeIfWon =
        let rec allTrue lst =
            match lst with
            | head :: tail -> head && (allTrue tail)
            | [] -> true

        let rec findTrueRow lst =
            match lst with
            | head :: tail ->
                match (allTrue head) with
                | true -> true
                | false -> findTrueRow tail
            | [] -> false

        (findTrueRow crossedRow)
        || (findTrueRow crossedCol)

    member this.AddValue(num: int) =
        match this.SeeIfWon with
        | true -> false
        | false ->
            match values.TryGetValue num with
            | true, (x, y) ->
                sum <- sum - num
                crossedRow <- buildCrossed crossedRow x y
                crossedCol <- buildCrossed crossedCol y x
                this.SeeIfWon
            | _ -> false




let readLines filePath = System.IO.File.ReadLines(filePath)

let buildBoard lines =
    let rec readCols lines (values: Dictionary<_, _>) sum row col =
        match lines with
        | head :: tail ->
            if head.Equals("") then
                (values, sum)
            else
                let num = head |> int
                values.Add(num, (row, col))
                readCols tail values (sum + num) row (col + 1)
        | [] -> (values, sum)

    let rec readRows lines values sum row =
        match lines with
        | head :: tail ->
            let (v, s) =
                readCols (Seq.toList head) values sum row 0

            readRows tail v s (row + 1)
        | [] -> (values, sum)

    let values = new Dictionary<_, _>()
    let (v, s) = readRows lines values 0 0

    Board(v, s)

let partOne =
    let rec findWinningBoard numbers (boards: list<Board>) =
        let rec tryAllBoards num (boards: list<Board>) =
            match boards with
            | board :: tail ->
                match (board.AddValue num) with
                | true ->
                    printfn "Part 1: %d" (board.Sum * num)
                    true
                | false -> tryAllBoards num tail
            | [] -> false

        match numbers with
        | num :: tail ->
            match (tryAllBoards num boards) with
            | true -> ()
            | false -> findWinningBoard tail boards
        | [] -> ()

    let lines = List()

    for line in readLines "input.txt" do
        if
            not
                (
                    line.Equals("\n")
                    || line.Equals("")
                    || line.Equals(" ")
                )
        then
            lines.Add(line)

    let numbers =
        Seq.toList (
            lines.[0].Split([| ',' |])
            |> Seq.map (fun x -> x |> int)
        )


    let boards =
        Seq.toList (
            lines :> seq<string>
            |> Seq.skip 1
            |> Seq.map (fun x -> x.Split [| ' ' |])
            |> Seq.map (fun x -> x |> Array.map (fun y -> y.Trim()))
            |> Seq.map (fun x -> x |> Array.filter (fun y -> not (y.Equals(""))))
            |> Seq.chunkBySize 5
            |> Seq.map (fun x -> buildBoard (Seq.toList x))
        )

    findWinningBoard numbers boards

let partTwo =
    let rec findLastBoard numbers (boards: list<Board>) current =
        let rec tryAllBoards num (boards: list<Board>) current =
            match boards with
            | board :: tail ->
                match (board.AddValue num) with
                | true -> tryAllBoards num tail (board.Sum * num)
                | false -> tryAllBoards num tail current
            | [] -> current

        match numbers with
        | num :: tail -> findLastBoard tail boards (tryAllBoards num boards current)
        | [] -> printfn "Part 2: %d" current

    let lines = List()

    for line in readLines "input.txt" do
        if
            not
                (
                    line.Equals("\n")
                    || line.Equals("")
                    || line.Equals(" ")
                )
        then
            lines.Add(line)

    let numbers =
        Seq.toList (
            lines.[0].Split([| ',' |])
            |> Seq.map (fun x -> x |> int)
        )


    let boards =
        Seq.toList (
            lines :> seq<string>
            |> Seq.skip 1
            |> Seq.map (fun x -> x.Split [| ' ' |])
            |> Seq.map (fun x -> x |> Array.map (fun y -> y.Trim()))
            |> Seq.map (fun x -> x |> Array.filter (fun y -> not (y.Equals(""))))
            |> Seq.chunkBySize 5
            |> Seq.map (fun x -> buildBoard (Seq.toList x))
        )

    findLastBoard numbers boards 0

let _ = partOne
let _ = partTwo
