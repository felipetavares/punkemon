-- Functions to generate and control the dungeons.
-- For Room generation, see the RoomManager

	-- In Spelunky the level is made of an 4x4 grid. There are 4 different basic rooms:
	-- 0 : A side room that is not on solution path
	-- 1 : A room that is guaranteed to have a left exit and a right exit
	-- 2 : A room that is guaranteed to have exists on the left, right and bottom. 
	--		If there's another "2" room above it, then it also is guaranteed a top exit
	-- 3 : A room that is guaranteed to have exists on the, left, right and top

function generateLevel(size_x, size_y)	
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
	direction = math.random(1,5)
	
	-- When a direction is decided, then we can start to create the rooms
	while (true) do
		dprint('Actual Row:' .. row .. '\t Column:' .. column .. '\t Direction:' .. direction .. '\t Tile:' .. tilemap[row * size_x + column])
		if direction == 1 or direction == 2 then		-- right
			if column - 1 > 0 then
				column -= 1
				tilemap[row * size_x + column] = math.random(1,3)
			else				-- If is on the extreme right, go down and change direction
				tilemap[row * size_x + column] = 2
				row += 1
				direction = 3
			end
		elseif direction == 3 or direction == 4 then	-- left
			if column + 1 <= size_x then
				column += 1
				tilemap[row * size_x + column] = math.random(1,3)
			else				-- If is on the extreme left, go down and change direction
				tilemap[row * size_x + column] = 2 
				row += 1
				direction = 1
			end
		else											-- down
			if row < size_y then
				tilemap[row * size_x + column] = 2
				tilemap[row * size_x + column] = 2
				row += 1
			end
		end
		
		if row > size_y then
			break
		end
		
		dprint('Next Row:' .. row .. '\t Column:' .. column .. '\t Direction:' .. direction .. '\t Tile:' .. tilemap[row * size_x + column])
	end
	return tilemap
end

function isInsideMap(x, y, size_x, size_y)
	return x > 0 and x <= size_x and y > 0 and y <= size_y
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

function chooseNewDirection(actualDirection)
	local newDirection = math.random(1,5)
	while( newDirection ~= actualDirection and newDirection ~= 5) do
		newDirection = math.random(1,5)
		dprint(newDirection)
	end

	return newDirection
end
