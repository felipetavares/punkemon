local Attack = {}

NEUTRAL = 'NEUTRAL'
TECH = 'TECH'
NAT  = 'NAT'
MAGE = 'MAGE'

Attack.NEUTRAL = NEUTRAL
Attack.TECH = TECH
Attack.NAT = NAT
Attack.MAGE = MAGE

Attack.elementalMultiplier = {
	NEUTRAL 	= { TECH = 1, 	NAT = 1, 	MAGE = 1,   },
	TECH 	    = { TECH = 1, 	NAT = 2, 	MAGE = 0.5  },
	NAT	    	= { TECH = 0.5, NAT = 1, 	MAGE = 2	},
	MAGE		= { TECH = 2,	NAT = 0.5,  MAGE = 1 	},
}

function Attack:new(desc)
    local instance = {
        name = desc.name or '',
		power = desc.power or 10,
		accuracy = desc.accuracy or 1,
		element = desc.element or NEUTRAL,
		target = desc.target or nil,
		effect = desc.effect or nil,
        pp = desc.pp or 5,
        visualCreation = desc.visualCreation or function() end,
        visual = desc.visual or function() end
    }

    lang.instanceof(instance, Attack)

    instance:visualCreation()

    return instance
end

return Attack
