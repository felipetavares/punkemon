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
    NEUTRAL = { TECH = 1,   NAT = 1,    MAGE = 1,   NEUTRAL = 1},
    TECH    = { TECH = 1,   NAT = 2,    MAGE = 0.5, NEUTRAL = 1},
    NAT     = { TECH = 0.5, NAT = 1,    MAGE = 2,   NEUTRAL = 1},
    MAGE    = { TECH = 2,   NAT = 0.5,  MAGE = 1,   NEUTRAL = 1},
}

Attack.ElementSprites = {
    NEUTRAL = {x = 72, y = 104, w = 8, h = 8},
    NAT = {x = 64, y = 96, w = 8, h = 8},
    TECH = {x = 64, y = 104, w = 8, h = 8},
    MAGE = {x = 72, y = 96, w = 8, h = 8}
}

function Attack:new(desc)
    local instance = new(Attack, {
        name = desc.name or '',
        power = desc.power or 10,
        accuracy = desc.accuracy or 1,
        element = desc.element or NEUTRAL,
        targetDescription = desc.target or nil,
        target = nil,
        effect = desc.effect or nil,
        basePP = desc.pp or 5,
        pp = desc.pp or 5,
        visualCreation = desc.visualCreation or function() end,
        visual = desc.visual or function() end
    })

    instance:visualCreation()

    return instance
end

function Attack.changeStat(table, member, delta)
    if table[member] + delta >= 0 then
        table[member] += delta
    end
end

function Attack:use()
    if self.pp > 0 then
        self.pp -= 1
    end
end

function Attack:loaded()
    return self.pp > 0
end

return Attack
