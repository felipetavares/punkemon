local Combat = {}

function Combat:new(player, character)
    local instance = {
        player = player or nil,
        character = character or nil
    }

    lang.instanceof(instance, Combat)

    return instance
end

function Combat:draw()
    clr(1)
end

function Combat:update(dt)
end

return Combat
