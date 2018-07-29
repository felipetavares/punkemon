require('MapManager')
require('RoomGenerator')

local Room = require('Room')
local TilemapBuilder = require('TilemapBuilder')
local Boid = require('Boid')
local BoidManager = require('BoidManager')

local Dungeon = {}

function Dungeon:new()
    local instance = {
        combat = nil,
        current = 1,
        rooms = {},
        w = 2,
        h = 3,
        stage = 1,
        boidManager = BoidManager:new()
    }

    lang.instanceof(instance, Dungeon)

    instance:generate()

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
        instance.boidManager:add(Boid:new(colors[c][1], colors[c][2]))
    end

    -- Jellyfish
    for i=1,5 do
        instance.boidManager:add(Boid:new(nil, nil, {{10, 0}, {11, 0}, {12, 0}, {13, 0}}))
    end

    return instance
end

function Dungeon:generate()
	local dungeon = generateLevel(self.w, self.h)

	for row = 0, self.h - 1 do
		for column = 0, self.w - 1 do
            local tile = dungeon[row * self.w + column]

            if tile ~= EMPTY then
                local tilemapBuilder, doormap = TilemapBuilder:new(), TilemapBuilder:new()

                tilemapBuilder:fill(1001)
                doormap:fill(1001)

                local _, _, w, h, doors = g_room(tilemapBuilder, doormap, (tile & D_TOP) ~= 0,
                                                                          (tile & D_BOTTOM) ~= 0,
                                                                          (tile & D_LEFT) ~= 0,
                                                                          (tile & D_RIGHT) ~= 0)

                local room = Room:new(tilemapBuilder, doormap, doors, w, h, self, stage)

                table.insert(self.rooms, room)

                dprint('Room ' .. tostring(column) .. ',' .. tostring(row) .. ' generated')

                coroutine.yield(0)
                --coroutine.yield((row*self.w+column)/(self.w*self.h))
            else
                table.insert(self.rooms, false)
            end
        end
	end

    for k, v in ipairs(self.rooms) do
        if v ~= false then
            self.current = k
            dprint('olá não tao bonitos')
            player:init(self.rooms[self.current])
            break
        end
    end
end

function Dungeon:startCombat(combat)
    self.combat = combat
end

function Dungeon:move(dx, dy)
    local room = self.rooms[self.current+dx+dy*self.w]

    if room then
        local prev = self.current
        self.current = self.current+dy*self.w+dx

        dprint('Changing from room ' .. tostring(prev) .. ' to ' .. tostring(self.current))
    end

    return self.rooms[self.current]
end

function Dungeon:drawMap()
    local room_h = 12
    local room_w = 12

    for y=0,self.h-1 do
        for x=0,self.w-1 do
            local room = self.rooms[y*self.w+x+1]

            if room ~= false then
                if room == self.rooms[self.current] then
                    rectf(x*room_w, y*room_h+1, room_w+1, room_h+1, 12)
                else
                    rect(x*room_w+1, y*room_h+1, room_w, room_h, 12)
                end
            end
        end
    end
end

function Dungeon:draw()
    if self.combat then
        self.combat:draw()
    else
        self.rooms[self.current]:draw()
        -- Draws fishes
        self.boidManager:draw()
    end

    self:drawMap()

--    if btp(DOWN) and self.current < #self.rooms then
--        for i=self.current+1,#self.rooms do
--            if self.rooms[i] ~= false then
--                self.current = i
--                break
--            end
--        end
--    end
--
--    if btp(UP) and self.current > 1 then
--        for i=self.current-1,1,-1 do
--            if self.rooms[i] ~= false then
--                self.current = i
--                break
--            end
--        end
--    end
end

function Dungeon:update(dt)
    if self.combat then
        self.combat:update(dt)

        if self.combat.finished then
            self.combat = nil
        end
    else
        self.rooms[self.current]:update(dt)
        self.boidManager:update(dt)
    end
end

return Dungeon
