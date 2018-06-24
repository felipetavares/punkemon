-- Functions to generate and control the dungeons.
-- For Room generation, see the RoomManager

	-- In Spelunky the level is made of an 4x4 grid. There are 4 different basic rooms:
 	-- 0 : A side room that is not on solution path
	-- 1 : A room that is guaranteed to have a left exit and a right exit
	-- 2 : A room that is guaranteed to have exits on the left, right and bottom. 
		--		If there's another "2" room above it, then it also is guaranteed a top exit
	-- 3 : A room that is guaranteed to have exits on the left, right and top

	--- OOOOOOR WE COULD JUST USE AND ARRAY WITH LEFT, RIGHT, BOTTOM AND TOP BOOLEANS FOR EACH EXIT!

-- Bit definitions
EMPTY = 0

TOP = (1<<0)
LEFT = (1<<1)
RIGHT = (1<<2)
BOTTOM = (1<<3)

local ALL = TOP+BOTTOM+LEFT+RIGHT

-- This function returns true if the room
-- at the given position exists
function tileExists(dungeon, size_x, size_y, x, y)
    -- Check if it is out of bounds
    if x < 0 or x >= size_x or
       y < 0 or y >= size_y then
       return false
    end

    return dungeon[y*size_x+x] ~= 0
end

function checkDoors(dungeon, size_x, size_y)
    for row=0,size_y-1 do
        for column=0,size_x-1 do
            local index = row*size_x+column

            if (dungeon[index]&TOP) ~= 0 then
                if not tileExists(dungeon, size_x, size_y, column, row-1) then
                    dungeon[index] = dungeon[index] & (~TOP)
                end
            end

            if (dungeon[index]&BOTTOM) ~= 0 then
                if not tileExists(dungeon, size_x, size_y, column, row+1) then
                    dungeon[index] = dungeon[index] & (~BOTTOM)
                end
            end 

            if (dungeon[index]&LEFT) ~= 0 then
                if not tileExists(dungeon, size_x, size_y, column-1, row) then
                    dungeon[index] = dungeon[index] & (~LEFT)
                end
            end

            if (dungeon[index]&RIGHT) ~= 0 then
                if not tileExists(dungeon, size_x, size_y, column+1, row) then
                    dungeon[index] = dungeon[index] & (~RIGHT)
                end
            end
        end
    end
end

function generateLevel(size_x, size_y)	
	local dungeon = {}
	
	-- Just to be safe,
	-- first we create all the rooms as an empty rooms without exits
	for row = 0, size_y - 1 do
		for column = 0, size_x - 1 do
			dungeon[row * size_x + column] = EMPTY
		end
	end
	
	createRooms(dungeon, size_x, size_y)
    checkDoors(dungeon, size_x, size_y)
	
	dprint('\n\nFINAL DUNGEON')
	printDungeon(dungeon,size_x, size_y)
	return dungeon
end

function createRooms(dungeon, size_x, size_y)
	-- First, pick a random room on the first row to be the entrace
	local entrance = math.random(0, size_x - 1)
	dprint('Entrace:' .. entrance)

	-- After put the first room, we decide if were should we go:
    -- LEFT
    -- RIGHT
    -- BOTTOM
	
	direction = 1<<math.floor((math.random(1, 5)+1)/2)

	dprint('Direction:' .. direction)

	local row = 0
	local column = entrance
	-- When a direction is decided, then we can start to create the rooms
	while (true) do
		if direction == LEFT then				                    -- left
			if column - 1 >= 0 then
				dungeon[row * size_x + column] = ALL
				direction = chooseNewDirection(direction)

				column -= 1
			else													-- If is on the extreme left, go down and change direction
				dungeon[row * size_x + column] = ALL
                direction = RIGHT

				row += 1
			end
        elseif direction == RIGHT then			                    -- right
			if column < size_x - 1 then
				dungeon[row * size_x + column] = ALL
				direction = chooseNewDirection(direction)

				column += 1
			elseif column == size_x - 1 then						-- If is on the extreme right, go down and change direction
				dungeon[row * size_x + column] = ALL
				direction = LEFT

				row += 1
			end
        else		    											-- down
			if row + 1 < size_y then
				dungeon[row * size_x + column] = ALL

                direction = ({RIGHT, LEFT})[math.random(1, 2)]

				row += 1
			else
				dprint('Out of Bounds Row, ending this now\n\n')
				break 												-- Dont you dare to put tiles out of the map limits
			end
		end
		
		if row == size_y  and (column == 0 or column == size_x) then
			break
		end
	end
end

function printDungeon(dungeon, size_x, size_y)
	local s = ''
	for row = 0, size_y - 1 do
		for column = 0, size_x - 1 do
            local tile = dungeon[row * size_x + column]

            local t = ({'_', 'T'})[(tile & TOP)+1]
            local l = ({'_', 'L'})[((tile & LEFT)>>1)+1]
            local r = ({'_', 'R'})[((tile & RIGHT)>>2)+1]
            local d = ({'_', 'D'})[((tile & BOTTOM)>>3)+1]

			s = s .. t .. d .. l .. r .. ' '
        end
		dprint (s)
		s = ''
	end
end

function chooseNewDirection(currentDirection)
	if math.random(5) ~= 1 then
		return currentDirection
	else
		return BOTTOM
	end

end
