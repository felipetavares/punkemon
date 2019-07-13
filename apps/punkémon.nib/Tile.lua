local Tile = {}

function Tile:new(x, y, kind)
    return new(Tile, {
        x = x or 0,
        y = y or 0,
        kind = kind or 0
    })
end

return Tile
