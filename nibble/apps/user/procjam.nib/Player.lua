local Player = {}

function Player:new()
    local instance = {
    }

    lang.instanceof(instance, Player)

    return instance
end

function Player:draw()

end

return Player
