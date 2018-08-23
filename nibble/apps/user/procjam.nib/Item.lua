local Effects = require('Effects')

local Item = {}

function Item:new(name, kind, hpRestoration, ppRestoration, attackEffect, defenseEffect, description)
    local instance = { 
		name = name or '', 
		kind = kind,
		description = description,
		
		hpRestoration = hpRestoration,
		ppRestoration = ppRestoration,
		attackEffect = attackEffect,
		defenseEffect = defenseEffect,

        -- World map
        x = x or 0,
        y = y or 0,
        -- World map sprite
        spr = {x = 192, y = 16, w = 16, h = 16},
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
    -- HP
    if self.hpRestoration then
        target.battleStats.HP = math.min(target.battleStats.HP+self.hpRestoration, target.baseStats.HP)
    end

    -- PP
    if self.ppRestoration then
        for i, move in ipairs(target.moveset) do
            move.pp = move.pp+self.ppRestoration
        end
    end
end

return Item
