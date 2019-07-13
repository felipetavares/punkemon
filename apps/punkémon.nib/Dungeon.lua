require('MapManager')
require('RoomGenerator')

local Room = require('Room')
local TilemapBuilder = require('TilemapBuilder')
local Boid = require('Boid')
local BoidManager = require('BoidManager')
local Camera = require('Camera')
local Easing = require('Easing')
local ParticleManager = require('ParticleManager')

local Dungeon = {}

function Dungeon:new()
    local instance = {
        combat = nil,
        current = 1,
        rooms = {},
        w = 3,
        h = 3,
        level = 1,
        boidManager = BoidManager:new(),
        finished = false,
        camera = Camera:new(),

        welcome_message = 'Cave ' .. tostring(1)
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

    Delayed.exec(3, function()
        instance.welcome_message = ''
    end)

    return instance
end

function Dungeon:generate()
    coroutine.yield()

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

                local x, y = column*320, row*240
                local room = Room:new(tilemapBuilder, doormap, doors, w, h, x, y, self, stage)

                table.insert(self.rooms, room)

                dprint('Room ' .. tostring(column) .. ',' .. tostring(row) .. ' generated')

                coroutine.yield((row*self.w+column)/(self.w*self.h))
            else
                table.insert(self.rooms, false)
            end
        end
	end

    for k, v in ipairs(self.rooms) do
        if v ~= false then
            self.current = k
            local room = self.rooms[self.current]
            self.camera:translate(room.x, -480,
                                  0, Easing.InOutCubic)

            Delayed.exec(1, function()
                self.camera:translate(room.x, room.y,
                                      1, Easing.InOutCubic)
            end)

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
        prev = self.current
        self.current = self.current+dy*self.w+dx

        dprint('Changing from room ' .. tostring(prev) .. ' to ' .. tostring(self.current))

        self.camera:translate(room.x, room.y,
                              0.3, Easing.InOutCubic)
    end

    return self.rooms[self.current]
end

function Dungeon:drawMap()
    local room_h = 12
    local room_w = 12

    local ox = 160-room_w*self.w/2
    local oy = 120-room_h*self.h/2

    local title_str = 'The Purple Caves'

    print(title_str, 160-#title_str*4, oy-room_h*self.h)

    for y=0,self.h-1 do
        for x=0,self.w-1 do
            local room = self.rooms[y*self.w+x+1]

            if room ~= false then
                if room == self.rooms[self.current] then
                    rectf(ox+x*room_w, oy+y*room_h+1, room_w+1, room_h+1, 12)
                else
                    rect(ox+x*room_w+1, oy+y*room_h+1, room_w, room_h, 12)
                end
            end
        end
    end
end

function Dungeon:draw()
    if self.combat then
        self.combat:draw()
    else
        if btd(RED) then
            clr(1)
            self:drawMap()
        else
            clr(1)

            local x, y = math.floor(self.camera.x/320+0.5), math.floor(self.camera.y/240+0.5)

            if self.camera.interpolation.to.t > clock() then
                for dx=-1,1 do
                    for dy=-1,1 do
                        local room = self.rooms[(dy+y)*self.w+x+dx+1]
                        if room then
                            room:draw(self.camera)
                        end
                    end
                end
            else
                self.rooms[self.current]:draw(self.camera)
            end

            -- Draws fishes
            self.boidManager:draw(self.camera)

        end
    end

    print(self.welcome_message, 160-#self.welcome_message*4, 120-4)
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
        self.camera:update(dt)
    end

    if player.battleStats.HP <= 0 then
        self.finished = true
    end
end

return Dungeon
