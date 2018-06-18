-- Imports
require('MapManager')
require('Room')
local Boid = require('Boid')
local BoidManager = require('BoidManager')
local TilemapBuilder = require('TilemapBuilder')

-- Singletons
local boidManager = BoidManager:new()

local tile_w, tile_h = 16, 16
local tilemap_w, tilemap_h = 20, 14 

local room_w, room_h = 16, 16
local dungeon_w, dungeon_h = 10, 30

local tileset_w = 5
local tileset_x, tileset_y = 5, 0

local dungeon_w = 5
local dungeon_x, dungeon_y = 5, 0

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
    -- Set palette
    kernel.write(32, '\x1e\x1c\x2e\xff\x1d\x1b\x29\xff\x3b\x40\x7f\xff\x29\x43\x50\xff\x66\x30\x6d\xff\x8d\x39\x7c\xff\x3b\x52\x8d\xff\x30\x66\x6d\xff\xb6\x44\x75\xff\xdd\x80\x5d\xff\x43\xa5\xcd\xff\x46\xb4\x7e\xff\xdb\xbc\x4b\xff\xe2\xea\x5a\xff\x00\x00\x00\xff\xff\xff\xff\xff')
	
    -- Color 0 is transparent
    -- mask(0)

	-- Getting a seed from the OS
    -- Strange non-standard nibble
    -- function: time()
	math.randomseed( time() )
	
	-- math.randomseed(114)
	
	dungeon = generateLevel(dungeon_w, dungeon_h)
	
    local tilemapBuilder = TilemapBuilder:new()
    tilemapBuilder:fill(1001)
    tilemap = g_room(tilemapBuilder, true, true, true, true):tilemap()

    -- Creates fish
    local colors = {
        {8, 9},
        {12, 13},
        {7, 11},
        {6, 10},
        {4, 11}
    }
    
    for i=1,60 do
        local c = math.random(1, #colors)

        boidManager:add(Boid:new(colors[c][1], colors[c][2]))
    end

    start_recording('fishes.gif')
end

function draw()
	local x = 0
	local y = 0
	
	--drawDungeon()
	drawRoom()

    -- Draws player
    --spr(player_x, player_y, 6, 1)

    -- Draws fishes
    boidManager:draw()
end

function drawRoom()
	local x, y = 0,0
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

end

function drawDungeon()
	local x, y = 0,0
	for _, room in ipairs(dungeon) do
        local room_x = room%dungeon_w+dungeon_x
        local room_y = room/dungeon_w+dungeon_y
		
        spr(x, y, room_x, room_y)

       x += room_w

		if x >= dungeon_w * dungeon_w then
            x = 0
            y += dungeon_h
		end
    end
end

function update(dt)
    boidManager:update(dt)

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
