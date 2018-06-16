-- Functions to generate and control the dungeons.
-- For Room generation, see the RoomManager

	-- In Spelunky the level is made of an 4x4 grid. There are 4 different basic rooms:
 	-- 0 : A side room that is not on solution path
	-- 1 : A room that is guaranteed to have a left exit and a right exit
	-- 2 : A room that is guaranteed to have exits on the left, right and bottom. 
		--		If there's another "2" room above it, then it also is guaranteed a top exit
	-- 3 : A room that is guaranteed to have exits on the left, right and top

	--- OOOOOOR WE COULD JUST USE AND ARRAY WITH LEFT, RIGHT, TOP AND DOWN BOOLEANS!



function generateLevel(size_x, size_y)	
	local tilemap = {}

	-- Just to be safe,
	-- first we create all the rooms as an empty rooms without exits
	for row = 0, size_y - 1 do
		for column = 0, size_x - 1 do
			tilemap[row * size_x + column] = OutRoom
		end
	end
	
	-- Here we start the process to generate all the level
	row = 0
	column = size_x
	
	-- First, pick a random room on the first row to be the entrace
	column = math.random(0,size_x)
	dprint('Entrace:' .. column)

	-- putNewRoom(math.random(1,3),column,row, tilemap, size_x, size_y, direction)
	
	-- After put the first room, we decide if were should we go:
	-- 1 or 2 	: left
	-- 3 or 4 	: right
	-- 5 		: down	
	
	direction = math.random(1,5)
	dprint('Direction:' .. direction)
	
	-- When a direction is decided, then we can start to create the rooms
	while (true) do
		dprint('R:' .. row .. '\t C:' .. column .. '\t Direction:' .. direction .. '\t aPos: '.. row * size_x + column)
		
		if direction == 1 or direction == 2 then				-- left
			if column < 0 then 										-- Verify if is not out of bounds
				dprint("Error: Out of bounds negative Column")
				break
			elseif column - 1 >= 0 then
				tilemap[row * size_x + column] = math.random(1,3)
				column -= 1
				direction = chooseNewDirection(direction)
			else													-- If is on the extreme left, go down and change direction
				tilemap[row * size_x + column] = 2
				row += 1
				direction = 3
			end
			
		elseif direction == 3 or direction == 4 then			-- right
			if column + 1 > size_x then 							-- Verify if is not out of bounds
				dprint("Error: Out of bounds positive Column")
			elseif column + 1 < size_x then
				tilemap[row * size_x + column] = math.random(1,3)
				column += 1
				direction = chooseNewDirection(direction)
			else													-- If is on the extreme right, go down and change direction
				tilemap[row * size_x + column] = 2
				row += 1
				direction = 1
			end
			
		else													-- down
			if row + 1 < size_y then
				tilemap[row * size_x + column] = 2
				row += 1
				direction = math.random(1,4) 						-- Can only get down 1 level at time
			else
				dprint("Out of Bounds Row")
				break 												-- Dont you dare to put tiles out of the map limits
			end
		end
		
		if row == size_y  and (column == 0 or column == size_x) then
			break
		end
		
		dprint('NR:' .. row .. '\t NC:' .. column .. '\t Direction:' .. direction .. '\t aPos: '.. row * size_x + column)
		printTilemap(tilemap,size_x, size_y)
		
	end
	return tilemap
end

function printTilemap(tilemap, size_x, size_y)
	local s = ''
	for row = 0, size_y - 1 do
		for column = 0, size_x -1 do
			s = s .. tilemap[row * size_x + column]
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