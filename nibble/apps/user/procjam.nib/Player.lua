local Character = require('Character')
local Player = Character:new()

local Inventory = require('Inventory')

local Combat = require('Combat')
local Attack = require('Attack')

local EnemyBiped = require('EnemyBiped')

function Player:new()
    local instance = {
        x = 10, y = 7,
		
		equipment = { SWORD = nil, SHIELD = nil	},
		
		moveset = {},
		oldX = x, oldY = y,

        frame = 0,
        elapsed = 0
    }

    lang.instanceof(instance, Player)

    local tackle = Attack:new('Tackle', 10, 1, 1, 3, nil, function (e)
        e.battleStats.HP = e.battleStats.HP-1
    end)
    local sand = Attack:new('Sand', 10, 1, 1, 5, nil, function () end)
    local harden = Attack:new('Harden', 10, 1, 1, 5, nil, function () end)
    local growl = Attack:new('Growl', 10, 1, 1, 5, nil, function () end)

    table.insert(instance.moveset, tackle)
    table.insert(instance.moveset, sand)
    table.insert(instance.moveset, harden)
    table.insert(instance.moveset, growl)

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
    spr(self.x*16, self.y*16, 10+self.frame, 3)
end

local t = 0
function Player:battleDraw()
    t += 1/30

    local deltay = math.sin(t*2)*6
    local deltax = math.cos(t*2)*3

	-- Draw sword
	pspr(100+deltax, 75+deltay, 0, 208, 48, 80)

	-- Draw sereia comedora de cu
	pspr(10+deltax, 75+deltay, 320,240, 128,128)
	
	-- Draw shield
    pspr(112+deltax, 130+deltay, 0, 112, 48, 80)
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

    --enemy = EnemyBiped:new(nil)

    if enemy then
        local combat = Combat:new(self, enemy)

        room.dungeon:startCombat(combat)
    end
end

function Player:update(room, dt)
    self.elapsed += dt

    if self.elapsed > 0.1 then
        self.elapsed = 0
        self.frame = (self.frame+1)%5
    end

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
