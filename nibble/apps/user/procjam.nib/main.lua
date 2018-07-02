-- Imports
require('Audio')

local Player = require('Player')
player = Player:new()

local Dungeon = require('Dungeon')

local Particle = require('Particle')
local ParticleSystem = require('ParticleSystem')
local ParticleManager = require('ParticleManager')
require ('ParticleFunctions')

-- Singletons
local dungeon = Dungeon:new()
local particleManager = ParticleManager:new()

function init()
    -- Set palette
    kernel.write(32, '\x1e\x1c\x2e\xff\x1d\x1b\x29\xff\x3b\x40\x7f\xff\x29\x43\x50\xff\x66\x30\x6d\xff\x8d\x39\x7c\xff\x3b\x52\x8d\xff\x30\x66\x6d\xff\xb6\x44\x75\xff\xdd\x80\x5d\xff\x43\xa5\xcd\xff\x46\xb4\x7e\xff\xdb\xbc\x4b\xff\xe2\xea\x5a\xff\xff\xff\xff\xff\xff\xff\xff\xff')

    cppal(0, 1)
    cppal(1, 2)
	
    -- Color 0 is transparent
    mask(0)

	-- Getting a seed from the OS
    -- Strange non-standard nibble
    -- function: time()
	math.randomseed( time() )
	
	local bubbles = ParticleSystem:new(5,  {x = 128, y = 128}, 2, true, bubbleCreate, bubbleUpdate, bubbleDraw)
	local tinyBubbles = ParticleSystem:new(5, {x = 64, y = 128}, 2, true, bubbleCreate, bubbleUpdate, tinyBubbleDraw)
	
	bubbles:emit()
	tinyBubbles:emit()
		
	particleManager:add(bubbles)
	particleManager:add(tinyBubbles)
	
	--Heal Particles
	local heal = ParticleSystem:new(40, {x = 148, y = 128}, 0, false, healCreate, healUpdate, healDraw)
	local healBlink = ParticleSystem:new(15, {x = 148, y = 128}, 0, false, healCreate, healUpdate)
    
	heal:emitInsideRect(100,64)
	healBlink:emitInsideRect(100,64)
	
	particleManager:add(heal)
	particleManager:add(healBlink)
	
	-- Sand Attack Particles
	local sandAttack =  ParticleSystem:new(40, {x = 148, y = 128}, 0, false, sandAttackCreate , sandAttackUpdate)
	
	sandAttack:emit()
	
	particleManager:add(sandAttack)
	
	-- Hit Particles
	local hitAttack =  ParticleSystem:new(40, {x = 64, y = 128}, 0, false, hitCreate, hitUpdate, hitDraw)
	
	hitAttack:emit()
	
	particleManager:add(hitAttack)
	
    --start_recording('mermaids.gif')
end

function draw()
	clr(1)
    -- Draws dungeon
    dungeon:draw()
	
	-- Draw particles
	particleManager:draw()
end

function update(dt)
	particleManager:update(dt)
    dungeon:update(dt)
end
