local Item = {}

function Item:new(kind, hpRestoration, ppRestoration, attackEffect, defenseEffect, description)
    local instance = { 
		name = '',
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
	dprint('Bling Bling -> Item using')
end

return Item