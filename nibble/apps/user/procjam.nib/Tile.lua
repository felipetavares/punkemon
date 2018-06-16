local Tile = {}

function Tile:new(x, y, kind)
    local instance = {
        x = x or 0,
        y = y or 0,
        kind = kind or 0
    }

    lang.instanceof(instance, self)

    return instance
end

return Tile
