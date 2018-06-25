local Item = {}

function Item:new(kind, hpRestoration, ppRestoration, attackEffect, defenseEffect)
    local instance = { 
		name = '',
		kind = kind,
		
		hpRestoration = hpRestoration,
		ppRestoration = ppRestoration,
		attackEffect = attackEffect,
		defenseEffect = defenseEffect,
		
    }

    lang.instanceof(instance, Item)

    return instance
end

return Item