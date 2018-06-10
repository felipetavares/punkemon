local MapManager = {}

function MapManager:new(text, x, y)
    local instance = {
        text = text or "",
        x = x or 0, y = y or 0,
        palette = 0,
        color = 15,
        background_color = 0,
        bold = 0,
        underline = false,
        align = 0
    }

    lang.instanceof(instance, self)

    return instance
end


return MapManager


--MapManager
--RoomManager
--	tileManager

--ParticleManager

--Entity
--Enemy
--Player
--Item
