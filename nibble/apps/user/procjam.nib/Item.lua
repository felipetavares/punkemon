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
    }

    lang.instanceof(instance, Item)

    return instance
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
