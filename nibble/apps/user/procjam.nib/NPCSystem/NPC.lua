local NPC = {}

function NPC:new(x, y, kind)
    local instance = {
        name = nil,
        emotions = {},
    }

    lang.instanceof(instance, self)

    return instance
end

return Tile
