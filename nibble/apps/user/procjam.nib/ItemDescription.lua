local Attack = require('Attack')

local ItemDescriptions = {
    ['Oyster'] = {
        name = 'Oyster',
        description = 'Restores health',
        element = Attack.NAT,

        effect = function (self, target)
            local baseHP = target.baseStats.HP
            local battleHP = target.battleStats.HP
            
            target.battleStats.HP = math.min(baseHP, battleHP + 30)
        end,

        spr = {
            x = 192,
            y = 16,
            w = 16,
            h = 16
        }
    },

    ['IncreasePP'] = {
        name = 'Oil',
        description = 'Restores PP of TECH moves',
        element = Attack.TECH,

        effect = function (self, target)
            for i, move in ipairs(target.moveset) do
                if self.element == move.element then
                    move.pp = math.min(move.basePP, move.pp+3)
                end
            end
        end,

        spr = {
            x = 192,
            y = 16,
            w = 16,
            h = 16
        }
    }
}

return ItemDescriptions
