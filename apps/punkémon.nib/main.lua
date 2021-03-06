--
-- PUNKÉMON
-- For the NIBBLE handheld console
--

Delayed = require('Delayed')
ParticleManager = require('ParticleManager')
DialogManager = require('./NPCSystem/DialogManager')
--
-- PUNKÉMON
-- For the NIBBLE handheld console
--

Delayed = require('Delayed')
ParticleManager = require('ParticleManager')
particleManager = ParticleManager:new()

-- Imports
require('Audio')

local Player = require('Player')
player = Player:new()

local Dungeon = require('Dungeon')

local TitleScreen = require('TitleScreen')

-- Singletons
local dungeon = nil

-- Scene management
-- 'title'
-- 'loading'
-- 'game'
-- 'death'
local scene = 'title'

function background_init()
    dungeon = Dungeon:new()
end

local bg_init = coroutine.create(background_init)

function init()
    -- Set palette
    write(0, '\x1e\x1c\x2e\x00\x1d\x1b\x29\xff\x3c\x41\x8a\xff\x36\x4f\x8f\xff\x25\x9e\xce\xff\x66\x30\x6d\xff\x8d\x39\x7c\xff\xb6\x44\x75\xff\xdd\x80\x5d\xff\xdb\xbc\x4b\xff\xe2\xea\x5a\xff\x22\x6d\x6f\xff\x20\x91\x76\xff\x1f\x9e\x5f\xff\xff\xff\xff\xff\xff\xff\xff\xff')
    --kernel.write(32, '\x1e\x1c\x2e\xff\x1d\x1b\x29\xff\x3b\x40\x7f\xff\x29\x43\x50\xff\x66\x30\x6d\xff\x8d\x39\x7c\xff\x3b\x52\x8d\xff\x30\x66\x6d\xff\xb6\x44\x75\xff\xdd\x80\x5d\xff\x43\xa5\xcd\xff\x46\xb4\x7e\xff\xdb\xbc\x4b\xff\xe2\xea\x5a\xff\xff\xff\xff\xff\xff\xff\xff\xff')

    copy_palette(0, 1)
    copy_palette(1, 2)

    -- Color 0 is transparent
    mask_color(0)
    mask_color(3*16)

    -- Getting a seed from the OS
    -- Strange non-standard nibble
    -- function: time()
    math.randomseed( time() )

    --start_recording('combat.gif')
end

local completed = 0
local time = 0
local dumb_messages = {
    "Creating evil Gods",
    "Gods are having sex",
    "Dinossaurs are evolving into chicken",
    "Mermaids are ruling",
    "Fishes are swiming",
    "Killing crabs",
    "Breaking rocks",
    "Adding rum",
    "Raining a bit",
    "Sleeping",
    "Crabs are fighting back",
    "Crabs have taken over",
    "Satan is being summoned",
    "Mermaids are shining",
    "Spreading glitter all around",
    "Drawing whales",
}

function draw()
    if scene == 'title' then
        TitleScreen.draw_title_screen()
    elseif scene == 'loading' then
        clear(1)

        _, percent = coroutine.resume(bg_init)

        if percent then
            completed = percent

            local i = math.random(1, #dumb_messages)
            bottom_msg = "" .. dumb_messages[i] .. ""

            if #dumb_messages > 1 then
                remove(dumb_messages, i)
            end
        end

        for i=1,8 do
            local t = time*i
            local x = math.cos(t)*20
            local y = math.sin(t)*20

            fill_circ(x+160, y+120, 3, i+4)
        end

        if completed and type(completed) == "string" then
            debug(completed)
        end

        local str = tostring(math.floor(completed*100)) .. '%'
        --local str = ""
        print(str, 160-4*#str, 120-4)

        local top_msg = "Eroding deep sea caves..."
        print(top_msg, 160-4*#top_msg, 60)

        if bottom_msg then
            local bottom_intro = "Presently:"
            print(bottom_intro, 160-4*#bottom_intro, 170)

            swap_colors(14, 13)
            print(string.upper(bottom_msg), 160-4*#bottom_msg, 190)
            swap_colors(14, 14)
        end

        if dungeon then
            scene = 'game'
        end
    elseif scene == 'game' then
        -- Draws dungeon
        dungeon:draw()

        if dungeon.finished then
            scene = 'death'
        end
    elseif scene == 'death' then
        clear(1)

        local startMessage = 'Press \09 to continue'

        if math.floor(clock()*8)%2 == 0 then
            swap_colors(7, 1)
            print(startMessage, 160-4*#startMessage, 210)
            swap_colors(7, 7)
        end

        if btp(RED) then
            scene = 'title'
        end
    end

    -- Draw particles
    particleManager:draw()
end

function update(dt)
    time += dt

    if scene == 'title' then
        TitleScreen.update_title_screen(dt)

        if TitleScreen.done then
            scene = 'loading'
            TitleScreen.done = false
            completed = 0
            bg_init = coroutine.create(background_init)
            dungeon = nil
            player = Player:new()
        end
    elseif scene == 'loading' then
    elseif scene == 'game' then
        dungeon:update(dt)
    elseif scene == 'death' then
    end

    particleManager:update(dt)
    Delayed.update()
end
