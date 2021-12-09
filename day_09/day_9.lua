local function read_file(file)
    local f = io.open(file, "r")
    local graph = {}

    local row = 1
    for line in f:lines() do
        graph[row] = {}
        local col = 1
        for num in string.gmatch(line, "(%d)") do
            graph[row][col] = tonumber(num)
            col = col + 1
        end
        row = row + 1
    end

    return graph
end

local function part_one(file)
    local graph = read_file(file)

    local num_rows = #graph
    local num_cols = #graph[1]

    local sum = 0

    for row = 1, num_rows do
        for col = 1, num_cols do
            local val = graph[row][col]

            if row > 1 then
                if (graph[row - 1][col]) <= val then goto continue end
            end

            if row < num_rows then
                if (graph[row + 1][col]) <= val then goto continue end
            end

            if col > 1 then
                if (graph[row][col - 1]) <= val then goto continue end
            end

            if col < num_cols then
                if (graph[row][col + 1]) <= val then goto continue end
            end

            sum = sum + 1 + val

            ::continue::
        end
    end

    print ("Part One: " .. sum)
end

local function get_basin(row, col, graph, visited)
    local size = 0

    local num_rows = #graph
    local num_cols = #graph[1]
    local curr = graph[row][col]

    if not visited[row][col] and not(curr == 9) then
        size = 1
        visited[row][col] = true

        if row > 1 and (graph[row - 1][col] > curr) then
            size = size + get_basin(row - 1 , col, graph, visited)
        end

        if row < num_rows and (graph[row + 1][col] > curr) then
            size = size + get_basin(row + 1 , col, graph, visited)
        end

        if col > 1 and (graph[row][col - 1] > curr) then
            size = size + get_basin(row, col - 1, graph, visited)
        end

        if col < num_cols and (graph[row][col + 1] > curr) then
            size = size + get_basin(row, col + 1, graph, visited)
        end
    end

    return size
end

local function part_two(file)
    local graph = read_file(file)

    local num_rows = #graph
    local num_cols = #graph[1]

    local basins = {}

    for row = 1, num_rows do
        for col = 1, num_cols do
            local val = graph[row][col]

            if row > 1 then
                if (graph[row - 1][col]) <= val then goto continue end
            end

            if row < num_rows then
                if (graph[row + 1][col]) <= val then goto continue end
            end

            if col > 1 then
                if (graph[row][col - 1]) <= val then goto continue end
            end

            if col < num_cols then
                if (graph[row][col + 1]) <= val then goto continue end
            end

            -- Found a basin low point, so just do a graph crawl from this location outward.
            -- Also create a visited graph to ensure you don't accidentally backtrack.
            local visited = {}
            for i = 1, num_rows do
                visited[i] = {}
                for j = 1, num_cols do
                    visited[i][j] = false
                end
            end

            local size = get_basin(row, col, graph, visited)
            table.insert(basins, size)

            ::continue::
        end
    end

    table.sort(basins, function(x, y) return x > y end)
    local result = basins[1] * basins[2] * basins[3]
    print ("Part Two: " .. result)
end

local file = arg[1] or "input.txt"

part_one(file)
part_two(file)