local function cantor(x, y)
    return 1/2*(x+y)*(x+y+1)+y
end

local function nil2infinity(v)
    if v == nil then
        return 9999
    end

    return v
end

local function distance(a, b)
    local dx, dy = math.abs(a.x-b.x), math.abs(a.y-b.y)

    return dx+dy
end

local function estimate(a, b)
    local dx, dy = math.abs(a.x-b.x), math.abs(a.y-b.y)

    return dx+dy
end

local function findNeighbours(tile, tilemap, w, h)
    local neighbours = {}

    local x, y = tile.x, tile.y

    for dx=-1,1 do
        for dy=-1,1 do
            if math.abs(dx)+math.abs(dy) < 2 then
                -- Current tilex, tiley
                local tx, ty = x+dx, y+dy

                if tx >= 0 and tx < w and
                   ty >= 0 and ty < h and
                    (tilemap[ty*w+tx+1].kind == 6 or
                     tilemap[ty*w+tx+1].kind == 7) then
                        insert(neighbours, tilemap[ty*w+tx+1])
                end
            end
        end
    end

    return neighbours
end

local function generatePath(tmpPath, current)
    local path = {current}

    while tmpPath[cantor(current.x, current.y)] do
        current = tmpPath[cantor(current.x, current.y)]
        insert(path, current)
    end

    return path
end

function aStar(start, finish, tilemap, w, h)
    -- Node hash tables
    local visited = {}
    local frontier = {}
    local frontierSize = 1

    -- Add start to the frontier
    frontier[cantor(start.x, start.y)] = start

    -- Choosen connections to any given node
    local path = {}

    -- Scores for each node
    local scoreG = {}
    local scoreF = {}

    -- Initialization
    scoreG[cantor(start.x, start.y)] = 0
    scoreF[cantor(start.x, start.y)] = estimate(start, finish)

    while frontierSize > 0 do
        -- Lowest scoreF
        local lowestFrontier = nil
        for k, node in pairs(frontier) do
            if not lowestFrontier then
                lowestFrontier = k
            end

            if nil2infinity(scoreF[lowestFrontier]) > nil2infinity(scoreF[cantor(node.x, node.y)]) then
                lowestFrontier = k
            end
        end

        local current = frontier[lowestFrontier]
        frontier[lowestFrontier] = nil
        frontierSize -= 1

        if current == finish then
            return generatePath(path, finish)
        end

        visited[cantor(current.x, current.y)] = current

        for _, neighbour in ipairs(findNeighbours(current, tilemap, w, h)) do
            if not visited[cantor(neighbour.x, neighbour.y)] then
                if not frontier[cantor(neighbour.x, neighbour.y)] then
                    frontier[cantor(neighbour.x, neighbour.y)] = neighbour
                    frontierSize += 1
                end

                tentativeScoreG = nil2infinity(scoreG[cantor(current.x, current.y)]) + distance(current, neighbour)

                local neighbourIndex = cantor(neighbour.x, neighbour.y)
                if tentativeScoreG < nil2infinity(scoreG[neighbourIndex]) then
                    path[neighbourIndex] = current
                    scoreG[neighbourIndex] = tentativeScoreG
                    scoreF[neighbourIndex] = scoreG[neighbourIndex] + estimate(neighbour, finish) 
                end
            end
        end
    end

    return nil
end
