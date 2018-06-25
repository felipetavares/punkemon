local Character = require('Character')
local Player = Character:new()

local Inventory = require('Inventory')

local Combat = require('Combat')

function Player:new()
    local instance = {
        x = 10, y = 7,
		
		equipment = { SWORD = nil, SHIELD = nil	},
		
		moveset = {},
		oldX = x, oldY = y,
    }

    lang.instanceof(instance, Player)

    return instance
end

function Player:init(room)
    for x=0,room.w do
        for y=0,room.h do
            if room.tilemap:get(x, y).kind == 07 then
                self.x, self.y = x, y
                return
            end
        end
    end
end

function Player:draw(room)
    spr(self.x*16, self.y*16, 10, 3)
end

function Player:checkAndMove(room, dx, dy)
    local x, y = self.x+dx, self.y+dy

    if room.tilemap:get(x, y).kind == 07 or
       room.tilemap:get(x, y).kind == 06 or
       room.tilemap:get(x, y).kind == 2000 then
        if not room:hasDecoration(x, y) then
			self.oldX , self.oldY = self.x , self.y
            self.x += dx
            self.y += dy
            room:step()
        end
    end
end

function Player:step(room)
    -- Move right
    if self.x >= room.w then
        local room = room.dungeon:move(1, 0)

        self.x = room.doors[D_LEFT].x
        self.y = room.doors[D_LEFT].y
    -- Move left
    elseif self.x < 0 then
        local room = room.dungeon:move(-1, 0)

        self.x = room.doors[D_RIGHT].x
        self.y = room.doors[D_RIGHT].y
    -- Move top
    elseif self.y < 0 then
        local room = room.dungeon:move(0, -1)

        self.x = room.doors[D_BOTTOM].x
        self.y = room.doors[D_BOTTOM].y
    -- Move bottom
    elseif self.y >= room.h then
        local room = room.dungeon:move(0, 1)

        self.x = room.doors[D_TOP].x
        self.y = room.doors[D_TOP].y
    end

    local enemy = room:getCharacter(self.x, self.y) or room:getCharacter(self.oldX, self.oldY)

    if enemy then
        local combat = Combat:new(self, enemy)

        room.dungeon:startCombat(combat)
    end
end

function Player:update(room, dt)
    if btp(DOWN) then
        self:checkAndMove(room, 0, 1)
    elseif btp(UP) then
        self:checkAndMove(room, 0, -1)
    elseif btp(LEFT) then
        self:checkAndMove(room, -1, 0)
    elseif btp(RIGHT) then
        self:checkAndMove(room, 1, 0)
    end
end

return Player
