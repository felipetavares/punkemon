local Effects = require('Effects')

local Item = {}

function Item:new(desc)
    local instance = { 
        name = name or desc.name, 
		element = desc.element,
		description = desc.description,

        effect = desc.effect,

        -- World map
        x = x or 0,
        y = y or 0,
        -- World map sprite
        spr = lang.copy(desc.spr),

        -- Appear effect
        appear = Effects.Explosion:new()
    }

    lang.instanceof(instance, Item)

    return instance
end

function Item:draw(camera)
    camera:pspr(self.x, self.y, self.spr.x, self.spr.y, self.spr.w, self.spr.h)
end

function Item:use(target)
    self:effect(target)
end

return Item
