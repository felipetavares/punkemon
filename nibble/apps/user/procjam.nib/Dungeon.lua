require('MapManager')
require('RoomGenerator')

local Room = require('Room')
local TilemapBuilder = require('TilemapBuilder')
local Dungeon = {}

function Dungeon:new()
    local instance = {
        current = 1,
        rooms = {},
        w = 4,
        h = 4
    }

    lang.instanceof(instance, Dungeon)

    instance:generate()

    return instance
end

function Dungeon:generate()
	local dungeon = generateLevel(self.w, self.h)

	for row = 0, self.w - 1 do
		for column = 0, self.h - 1 do
            local tile = dungeon[row * self.w + column]

            if tile ~= EMPTY then
                local tilemapBuilder, doormap = TilemapBuilder:new(), TilemapBuilder:new()

                tilemapBuilder:fill(1001)
                doormap:fill(1001)

                local _, _, w, h, doors = g_room(tilemapBuilder, doormap, (tile & TOP) ~= 0,
                                                                          (tile & BOTTOM) ~= 0,
                                                                          (tile & LEFT) ~= 0,
                                                                          (tile & RIGHT) ~= 0)

                local room = Room:new(tilemapBuilder, doormap, doors, w, h)

                table.insert(self.rooms, room)

                dprint('Room ' .. tostring(column) .. ',' .. tostring(row) .. ' generated')
            else
                table.insert(self.rooms, false)
            end
        end
	end

    for k, v in ipairs(self.rooms) do
        if v ~= false then
            self.current = k
            break
        end
    end
end

function Dungeon:draw()
    self.rooms[self.current]:draw()

    print(tostring(self.current%self.w) .. ', ' .. tostring(math.floor(self.current/self.w)), 0, 0)

    if btp(DOWN) and self.current < #self.rooms then
        for i=self.current+1,#self.rooms do
            if self.rooms[i] ~= false then
                self.current = i
                break
            end
        end
    end

    if btp(UP) and self.current > 1 then
        for i=self.current-1,1,-1 do
            if self.rooms[i] ~= false then
                self.current = i
                break
            end
        end
    end
end

return Dungeon
