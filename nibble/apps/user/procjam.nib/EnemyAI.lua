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
    --> Escolhe se irá usar o item carregado (se puder) ou irá atacar
    local shield = player.equipment.shield

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

    local MAGIC_NUMBER = 1

    local index = math.floor(1/(player.battleStats.HP*self.battleStats.HP)*MAGIC_NUMBER)

    local attacks = {}

    table.sort(attacks, compare)  

    return Choice:new(attacks[index], nil)
end

return EnemyAI
