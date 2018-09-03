local NPC = require('./NPCSystem/NPC')
local Dialog = {}

function Dialog:new()
    local instance = {
        idDialog = nil,
        character = nil,
        emotionId = nil,
        text = nil,
        choice = {}
    }

    lang.instanceof(instance, self)

    return instance
end

return Dialog
