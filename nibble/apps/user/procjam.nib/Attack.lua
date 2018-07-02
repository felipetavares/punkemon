local Attack = {}

NEUTRAL = 0
PIERCING = 1
TANK = 2
SCOUT = 3

elementalMultiplier = {
	NEUTRAL 	= { PIERCING = 1, 	TANK = 1, 	SCOUT = 1, },
	PIERCING 	= { PIERCING = 1, 	TANK = 2, 	SCOUT = 0.5},
	TANK		= { PIERCING = 0.5, TANK = 1, 	SCOUT = 2	},
	SCOUT		= { PIERCING = 2,	TANK = 0.5, SCOUT = 1 	},
}

function Attack:new(name, power, accuracy, element, pp, target, effect)
    local instance = {
        name = name or '',
		power = power or 10,
		accuracy = accuracy or 1,
		element = element or NEUTRAL,
		target = target or nil,
		effect = effect or nil,
        pp = pp or 5
    }

    lang.instanceof(instance, Attack)

    return instance
end

return Attack
