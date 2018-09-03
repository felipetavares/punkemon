--
-- PUNKÉMON
-- For the NIBBLE handheld console
--

Delayed = require('Delayed')
ParticleManager = require('ParticleManager')
DialogManager = require('./NPCSystem/DialogManager')
Dialog = require('./NPCSystem/Dialog')
NPC = require('./NPCSystem/NPC')

particleManager = ParticleManager:new()
dialogManager = DialogManager:new()

-- Imports
require('Audio')

function background_init()
end


function init()
    -- Set palette
    kernel.write(32, '\x1e\x1c\x2e\x00\x1d\x1b\x29\xff\x3c\x41\x8a\xff\x36\x4f\x8f\xff\x25\x9e\xce\xff\x66\x30\x6d\xff\x8d\x39\x7c\xff\xb6\x44\x75\xff\xdd\x80\x5d\xff\xdb\xbc\x4b\xff\xe2\xea\x5a\xff\x22\x6d\x6f\xff\x20\x91\x76\xff\x1f\x9e\x5f\xff\xff\xff\xff\xff\xff\xff\xff\xff')
    --kernel.write(32, '\x1e\x1c\x2e\xff\x1d\x1b\x29\xff\x3b\x40\x7f\xff\x29\x43\x50\xff\x66\x30\x6d\xff\x8d\x39\x7c\xff\x3b\x52\x8d\xff\x30\x66\x6d\xff\xb6\x44\x75\xff\xdd\x80\x5d\xff\x43\xa5\xcd\xff\x46\xb4\x7e\xff\xdb\xbc\x4b\xff\xe2\xea\x5a\xff\xff\xff\xff\xff\xff\xff\xff\xff')

    cppal(0, 1)
    cppal(1, 2)

    -- Color 0 is transparent
    mask(0)
    mask(3*16)

    -- Getting a seed from the OS
    -- Strange non-standard nibble
    -- function: time()
    math.randomseed( time() )

    start_recording('dialog.gif')

    -- Load all the Dialog DialogManager
    dprint(dialogManager:load('Dialog.punk'))
end

function draw()
    clr(1)
    -- Draw particles
    particleManager:draw()
end


local time = 0

function update(dt)
    time += dt
    particleManager:update(dt)
end
