local Character = require('Character')
local Player = Character:new()

local Inventory = require('Inventory')
local Item = require('Item')

local Combat = require('Combat')
local Attack = require('Attack')

local EnemyBiped = require('EnemyBiped')
local Types = require("Attack")

local ParticleSystem = require('ParticleSystem')
require ('ParticleFunctions')

local Attacks = require('AttackDescription')

function Player:new()
    local instance = {
        x = 10, y = 7,
		
        equipment = {shield = nil, sword = nil},
	    inventories = {Inventory:new('Pouch')},
		
		moveset = {},
		oldX = x, oldY = y,

        frame = 0,
        elapsed = 0,

        direction = D_RIGHT,
        name = 'Player',

        baseStats = {},
        battleStats = {}
    }

    lang.instanceof(instance, Player)

    table.insert(instance.moveset, Attack:new(Attacks.Slash))
    table.insert(instance.moveset, Attack:new(Attacks.Scales))
    table.insert(instance.moveset, Attack:new(Attacks.Bubbles))
    table.insert(instance.moveset, Attack:new(Attacks.Diva))

    for i=1,6 do
        instance.inventories[1]:addItem(Item:new('Oyster', nil, math.floor(30*math.random())))
        instance.inventories[1]:addItem(Item:new('Magic Shit', nil, 0, math.floor(5*math.random())))
    end

    return instance
end

function Player:getCombatCenter()
    return 100, 140
end

function Player:init(room)
    self.baseStats = {
        HP = 80,
        attack = 75,
        defense = 80,
        speed = 56,
        element = Types.TECH,
    }

    self.battleStats = lang.copy(self.baseStats)

    for x=0,room.w do
        for y=0,room.h do
            if room.tilemap:get(x, y).kind == 07 then
                self.x, self.y = x, y
                return
            end
        end
    end
end 

function Player:hitEffect()
    self.ps:emitLine(2, 2, -50, -60)

    Delayed.exec(0.1, function()
        self.ps:emitLine(-2, 2, 50, -60)
    end)
end

function Player:draw(room, camera)
    if self.direction == D_LEFT then
        camera:spr(self.x*16, self.y*16, 11+self.frame, 4)
    else
        camera:spr(self.x*16, self.y*16, 11+self.frame, 5)
    end
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
        else
            room:useDecoration(x, y)
            room:step()
        end
    end
end

function Player:step(room)
    Character.step(self)

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

    if room:hasItem(self.x, self.y) then
        local item = room:getItem(self.x, self.y)

        self.inventories[1]:addItem(item)

        item.appear:start(item.x, item.y)
    end
end

function Player:update(room, dt)
    self.elapsed += dt

    if self.elapsed > 0.1 then
        self.elapsed = 0
        self.frame = (self.frame+1)%5
    end

    if btd(DOWN) and self:moveAllowed() then
        self:checkAndMove(room, 0, 1)
    elseif btd(UP) and self:moveAllowed() then
        self:checkAndMove(room, 0, -1)
    elseif btd(LEFT) and self:moveAllowed() then
        self:checkAndMove(room, -1, 0)
        self.direction = D_LEFT
    elseif btd(RIGHT) and self:moveAllowed() then
        self:checkAndMove(room, 1, 0)
        self.direction = D_RIGHT
    end
end

function Player:moveAllowed()
    if not self.lastMovedTime then
        self.lastMovedTime = clock()
        return true
    end

    if clock()-self.lastMovedTime > 0.1 then
        self.lastMovedTime = clock()
        return true
    else
        return false
    end
end

return Player
