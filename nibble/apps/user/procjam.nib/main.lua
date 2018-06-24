-- Imports
local Player = require('Player')
player = Player:new()

local Dungeon = require('Dungeon')

local Particle = require('Particle')
local ParticleSystem = require('ParticleSystem')
local ParticleManager = require('ParticleManager')

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
	
    local colors = {
        {8, 9},
        {12, 13},
        {7, 11},
        {6, 10},
        {4, 11}
    }
	local c = math.random(1, #colors)
	local ps = ParticleSystem:new(10, {x = 10, y = 10}, colors[c][2], colors[c][1], { x = 1, y = 2})
	
	ps:emit()
	particleManager:add(ps)

    --start_recording('fishes.gif')
end

function draw()
    -- Draws dungeon
    dungeon:draw()
	
	-- Draw particles
	particleManager:draw()
end

function update(dt)
	particleManager:update(dt)
    dungeon:update(dt)
end
