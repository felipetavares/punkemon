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

function DialogManager:Load(path) -- Parser
    local file = io.open(path, "r") -- r read mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    dprint(content)
    file:close()
    return content
end

function DialogManager:draw()
end

function DialogManager:update()
end

return DialogManager
