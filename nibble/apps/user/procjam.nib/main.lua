local mapManager = require('MapManager')

--function generateLevel(size_x, size_y)
--	local row, column
--	local tilemap = {}
--	for
--end

local tilemap = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 0,
    0, 1, 1, 1, 2, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 0,
    0, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
}

local tile_w, tile_h = 16, 16
local tilemap_w, tilemap_h = 20, 15 

local tileset_w = 4
local tileset_x, tileset_y = 6, 0

local player_x, player_y = tilemap_w/2*tile_w, tilemap_h/2*tile_h
local player_speed = 30

local check_x1, check_y1 = 0, 0
local check_x2, check_y2 = 0, 0
local check_x3, check_y3 = 0, 0
local check_x4, check_y4 = 0, 0

function tile_at(x, y)
    local position = y*tilemap_w+x+1

    if position > 0 and position <= tilemap_w*tilemap_h then
        return tilemap[position]
    end

    return 0
end

-- Check each corner of a tile_wxtile_h rectangle
-- at to_x, to_y against the tilemap
function can_move(to_x, to_y)
    local x1, y1 = math.floor(to_x/tile_w), math.floor(to_y/tile_h)
    local x2, y2 = x1+1, y1
    local x3, y3 = x1+1, y1+1
    local x4, y4 = x1, y1+1

    check_x1, check_y1 = x1, y1
    check_x2, check_y2 = x2, y2
    check_x3, check_y3 = x3, y3
    check_x4, check_y4 = x4, y4

    return tile_at(x1, y1) == 1 and
           tile_at(x2, y2) == 1 and
           tile_at(x3, y3) == 1 and
           tile_at(x4, y4) == 1
end

function init()
    -- Color 0 is transparent
    mask(0)
end

function draw()
    local x, y = 0, 0

    -- Draws tilemap
    for _, tile in ipairs(tilemap) do
        local tile_x = tile%tileset_w+tileset_x
        local tile_y = tile/tileset_w+tileset_y

        spr(x, y, tile_x, tile_y)

        x += tile_w

        if x >= tilemap_w*tile_w then
            x = 0
            y += tile_h
        end
    end

    -- Draws player
    spr(player_x, player_y, 6, 1)

    -- Draws collision check
    rect(check_x1*tile_w, check_y1*tile_h, tile_w, tile_h, 15)
    rect(check_x2*tile_w, check_y2*tile_h, tile_w, tile_h, 15)
    rect(check_x3*tile_w, check_y3*tile_h, tile_w, tile_h, 15)
    rect(check_x4*tile_w, check_y4*tile_h, tile_w, tile_h, 15)

    -- Debug info
    print(tostring(math.floor(player_x)) .. ', ' .. tostring(math.floor(player_y)), 0, 0)
end

function update(dt)
    local movement = dt*player_speed 

    if btd(UP) then
        if can_move(player_x, player_y-movement) then
            player_y -= movement
        end
    end

    if btd(DOWN) then
        if can_move(player_x, player_y+movement) then
            player_y += movement
        end
    end

    if btd(LEFT) then
        if can_move(player_x-movement, player_y) then
            player_x -= movement
        end
    end

    if btd(RIGHT) then
        if can_move(player_x+movement, player_y) then
            player_x += movement
        end
    end
end
