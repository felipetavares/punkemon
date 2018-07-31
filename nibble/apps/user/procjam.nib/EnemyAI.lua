local Character = require('Character')
local Choice = require('Choice')
local Attack = require('Attack')

EnemyAI = {}

function EnemyAI:new(controlledCharacter)
    local instance = {
    chara = controlledCharacter,
    }

    lang.instanceof(instance, EnemyAI)

    return instance
end

function EnemyAI:decision(player)
    --> Still needs to classify status bellow attack.
    --> Are status always items?
    local shield = player.equipment.SHIELD

    function classifier(attack)
        local multiplayer = 1

        if shield then
          multiplayer = Attack.elementalMultiplier[attack.element][shield.kind]
        end

        return attack.power*attack.accuracy*multiplayer
    end

    function compare(a,b)
        return classifier(a) < classifier(b)
    end

    local tackle = Attack:new('Tackle', 1, 1, Attack.TECH, 3, player, function (e)
        e.battleStats.HP = e.battleStats.HP-1
    end)

    local attacks = {tackle}

    table.sort(attacks, compare)  

    local normalized_p_hp = player.battleStats.HP/player.baseStats.HP
    local normalized_e_hp = self.chara.battleStats.HP/self.chara.baseStats.HP

    local index = 0
    
    if normalized_p_hp ~= 0 and normalized_e_hp ~= 0 then
        math.floor(1/(normalized_p_hp*normalized_e_hp)*#attacks)
    end

    return Choice:new(attacks[index+1], nil)
end

return EnemyAI
