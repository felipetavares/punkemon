local Lexer = require('NPCSystem/Lexer')
local Parser = require('NPCSystem/Parser')

local DialogManager = {}

function DialogManager:new()
    local instance = {
        Dialogs = {}, -- id -> Dialog
        NPCs = {}, -- characterId -> Character
        backgroundSprites = {},
        
        dialogEffects = {}, -- idEffect -> function

        actualDialog = nil,

        -- Rendering variables
    }

    lang.instanceof(instance, self)

    return instance
end

function DialogManager:load(path) -- Parser
    local lexer = Lexer:new(path)
    local parser = Parser:new(lexer)
    local rawDialogs = parser:parse()
    lexer:close()

    -- Just use rawDialogs
    -- the formatting is on Discord ;)
end

function DialogManager:draw()
end

function DialogManager:update()
end

return DialogManager
