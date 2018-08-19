local Types = require('Attack')
local AtDesc = require('AttackDescription')
local enemyDesc = {}

enemyDesc.basicStats = {
    ['Basic1'] = {
        attack = 0,
        defense = 0,
        speed = 0,
        element = Types.NEUTRAL,
        HP = 1
    },

    ['Basic2'] = {
        attack = 0,
        defense = 0,
        speed = 0,
        element = Types.NEUTRAL,
        HP = 1
    },

    ['Basic3'] = {
        attack = 0,
        defense = 0,
        speed = 0,
        element = Types.NEUTRAL,
        HP = 1
    },

    ['Biped1'] = {
        HP = 80,
        attack = 75,
        defense = 80,
        speed = 56,
        element = Types.TECH,
    },

    ['Biped2'] = {
        HP = 126,
        attack = 105,
        defense = 110,
        speed = 71,
        element = Types.TECH
    },

    ['Biped3'] = {
        HP = 166,
        attack = 160,
        defense = 205,
        speed = 121,
        element = Types.TECH,
    },

    ['SeaWitch1'] = {
        HP = 56,
        attack = 80,
        defense = 75,
        speed = 80,
        element = Types.MAGE,
    },

    ['SeaWitch2'] = {
        HP = 71,
        attack = 110,
        defense = 105,
        speed = 126,
        element = Types.MAGE
    },

    ['SeaWitch3'] = {
        HP = 121,
        attack = 205,
        defense = 160,
        speed = 161,
        element = Types.MAGE,
    },

    ['Tefistar1'] = {
        HP = 80,
        attack = 80,
        defense = 75,
        speed = 56,
        element = Types.NAT,
    },

    ['Tefistar2'] = {
        HP = 126,
        attack = 110,
        defense = 105,
        speed = 71,
        element = Types.NAT
    },

    ['Tefistar3'] = {
        HP = 166,
        attack = 205,
        defense = 106,
        speed = 121,
        element = Types.NAT,
    },
}

enemyDesc.moveset = {
    ['Biped1'] = {
		AtDesc.Punch,
		AtDesc.Bubbles,
        AtDesc.Diva,
        AtDesc.Slash
    },

    ['Biped2'] = {
    },

    ['Biped3'] = {
    },

    ['SeaWitch1'] = {
		AtDesc.Slash,
    },

    ['SeaWitch2'] = {
    },

    ['SeaWitch3'] = {
    },

    ['Tefistar1'] = {
    },

    ['Tefistar2'] = {
    },

    ['Tefistar3'] = {
    },
}

return enemyDesc
