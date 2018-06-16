-- Functions to generate and control the dungeons.
-- For Room generation, see the RoomManager

	-- In Spelunky the level is made of an 4x4 grid. There are 4 different basic rooms:
 	-- 0 : A side room that is not on solution path
	-- 1 : A room that is guaranteed to have a left exit and a right exit
	-- 2 : A room that is guaranteed to have exits on the left, right and bottom. 
		--		If there's another "2" room above it, then it also is guaranteed a top exit
	-- 3 : A room that is guaranteed to have exits on the left, right and top

	--- OOOOOOR WE COULD JUST USE AND ARRAY WITH LEFT, RIGHT, BOTTOM AND TOP BOOLEANS FOR EACH EXIT!
local Rooms = { {0,0,0,0},
				{1,1,0,0},
				{1,1,1,0},
				{1,1,0,1},
				{1,1,1,1}
				}
				
local left, right, bottom, top = 1, 2, 3, 4


function generateLevel(size_x, size_y)	
	local tilemap = {}
	
	-- Just to be safe,
	-- first we create all the rooms as an empty rooms without exits
	for row = 0, size_y - 1 do
		for column = 0, size_x - 1 do
			tilemap[row * size_x + column] = Rooms[1]
		end
	end
	
	createRooms(tilemap, size_x, size_y)
	printTilemap(tilemap,size_x, size_y)
	
	dprint ('\n\nCLEANING TOP AND BOTTOM EDGES \nNOT IMPLEMENTED YET')
	for column = 0 , size_x - 1 do
		tilemap[column][top] = 0 -- QUE PORRA TÁ ROLANDO AQUI?
		tilemap[ (size_y-2) * size_x + column][bottom] = 0
	end
	printTilemap(tilemap,size_x, size_y)
	
	dprint ('\n\nCLEANING THE LEFT AND RIGHT EDGES \nNOT IMPLEMENTED YET')
	--for row = 0, size_y - 1 do
		--tilemap[row * size_x][left] = 0
		--tilemap[row * size_x + size_x - 1][right] = 0
	--end 
	
	dprint('\n\nFINAL DUNGEON')
	printTilemap(tilemap,size_x, size_y)
	return tilemap
end

function createRooms(tilemap,size_x, size_y)

	-- First, pick a random room on the first row to be the entrace
	local entrance = math.random(0,size_x - 1)
	dprint('Entrace:' .. entrance)

	-- After put the first room, we decide if were should we go:
	-- 1 or 2 	: left
	-- 3 or 4 	: right
	-- 5 		: down	
	
	direction = math.random(1,5)
	dprint('Direction:' .. direction)

	local row = 0
	local column = entrance
	-- When a direction is decided, then we can start to create the rooms
	while (true) do
		--dprint('R:' .. row .. '\t C:' .. column .. '\t Direction:' .. direction .. '\t aPos: '.. row * size_x + column)
		
		if direction == 1 or direction == 2 then				-- left
			if column < 0 then 										-- Verify if is not out of bounds
				dprint('Error: Out of bounds negative Column')
				break
			elseif column - 1 >= 0 then
				tilemap[row * size_x + column] = Rooms[math.random(2,4)]
				column -= 1
				direction = chooseNewDirection(direction)
			else													-- If is on the extreme left, go down and change direction
				tilemap[row * size_x + column] = Rooms[3]
				row += 1
				direction = 3
	--			--dprint ('Extreme Left, lets go down')
			end
	--		
		elseif direction == 3 or direction == 4 then			-- right
			--if column + 1 >= size_x then 							-- Verify if is not out of bounds
			--	dprint('Error: Out of bounds positive column')
			if column < size_x - 1 then
				tilemap[row * size_x + column] = Rooms[math.random(2,4)]
				column += 1
				direction = chooseNewDirection(direction)
			elseif column == size_x - 1 then						-- If is on the extreme right, go down and change direction
				tilemap[row * size_x + column] = Rooms[3]
				row += 1
				direction = 1
				--dprint ('Extreme right, lets go down')
			end
		else													-- down
			if row + 1 < size_y then
				tilemap[row * size_x + column] = Rooms[3]
				row += 1
				direction = math.random(1,4) 						-- Can only get down 1 level at time
			else
				dprint('Out of Bounds Row, ending this now\n\n')
				break 												-- Dont you dare to put tiles out of the map limits
			end
		end
		
		if row == size_y  and (column == 0 or column == size_x) then
			break
		end
		
		--dprint('NR:' .. row .. '\t NC:' .. column .. '\t Direction:' .. direction .. '\t aPos: '.. row * size_x + column)
		--printTilemap(tilemap,size_x, size_y)
	end
end


function printTilemap(tilemap, size_x, size_y)
	local s = ''
	for row = 0, size_y - 1 do
		for column = 0, size_x - 1 do
			s = s .. '('
			local e = tilemap[row * size_x + column][1]
			for exits = 2, 4 do
				e = e .. ','.. tilemap[row * size_x + column][exits] 
			end
			s = s .. e .. ')'
		end
		dprint (s)
		s = ''
	end
end

function chooseNewDirection(actualDirection)
	if math.random(50)%5 ~= 0 then
		return actualDirection
	else
		return 5	
	end

end