local Attack = {}

NEUTRAL = 0
TECH = 1
NAT  = 2
MAGE = 3

elementalMultiplier = {
	NEUTRAL 	= { TECH = 1, 	NAT = 1, 	MAGE = 1,   },
	TECH 	    = { TECH = 1, 	NAT = 2, 	MAGE = 0.5  },
	NAT	    	= { TECH = 0.5, NAT = 1, 	MAGE = 2	},
	MAGE		= { TECH = 2,	NAT = 0.5,  MAGE = 1 	},
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
