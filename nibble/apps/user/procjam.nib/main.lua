local mapManager = require('MapManager')

function generateLevel(size_x, size_y)	
	-- In Spelunky the level is made of an 4x4 grid. There are 4 different basic rooms:
	-- 0 : A side room that is not on solution path
	-- 1 : A room that is guaranteed to have a left exit and a right exit
	-- 2 : A room that is guaranteed to have exists on the left, right and bottom. 
	--		If there's another "2" room above it, then it also is guaranteed a top exit
	-- 3 : A room that is guaranteed to have exists on the, left, right and top
	
	local tilemap = {}
	
	-- Just to be safe,
	-- first we create all the rooms as an empty rooms without exits
	for row = 0, size_y do
		for column = 0, size_x do
			tilemap[row * size_x + column] = 0
		end
	end
	
	-- Here we start the process to generate all the level
	row = 0
	column = 0
	
	-- First, pick a random room on the first row to be the entrace
	column = math.random(0,size_x)
	dprint('Entrace:' .. column)
	tilemap[column] = math.random(1,2)
	
	-- After put the first room, we decide if were should we go:
	-- 1 or 2 	: right
	-- 3 or 4 	: left
	-- 5 		: down	
	-- When a direction is decided, then we can start to create the rooms
	direction = math.random(1,5)
	while (true) do
		if direction == 1 or direction == 2 then		-- right
			if column - 1 > 0 then
				column -= 1
			else				-- If is on the extreme right, go down and change direction
				tilemap[row * size_x + column] = 2
				row += 1
				direction = 3
			end
		elseif direction == 3 or direction == 4 then	-- left
			if column + 1 < size_x then
				column += 1
			else				-- If is on the extreme left, go down and change direction
				tilemap[row * size_x + column] = 2 
				row += 1
				direction = 1
			end
		else											-- down
			if row + 1 < size_y then
				row += 1
			else			-- Then just create the end room
				break
			end
		end
		tilemap[row * size_x + column] = 1 -- Jus putting 1 while dont run smoothly
	end
	
	return tilemap
end

function isInsideMap(x, y, size_x, size_y)
	return x > 0 and x < size_x and y > 0 and y < size_y
end


function printTilemap(t, size_x, size_y)
	local s = ''
	for row = 0, size_y do
		for column = 0, size_x do
			s = s .. tilemap[row * size_x + column]
		end
		dprint (s)
		s = ''
	end
end

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
	
	-- Getting a seed from the OS
	math.randomseed( 100 )
	
	tilemap = generateLevel(20,15)
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
