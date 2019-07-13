local Character = require('Character')
local Choice = require('Choice')
local Attack = require('Attack')

EnemyAI = {}

function EnemyAI:new(controlledCharacter)
    return new(EnemyAI, {
        chara = controlledCharacter,
    })
end

function EnemyAI:decision(player)
    --> Still needs to classify status bellow attack.
    --> Are status always items?
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

    local attacks = {}

    for _, move in ipairs(self.chara.moveset) do
        if move:loaded() then
            insert(attacks, move)
        end
    end

    sort(attacks, compare)

    terminal_print('Sorted attacks:')

    for i, atk in ipairs(attacks) do
        terminal_print(i, atk.name)
    end

    local normalized_p_hp = player.battleStats.HP/player.baseStats.HP
    local normalized_e_hp = self.chara.battleStats.HP/self.chara.baseStats.HP

    local index = 0

    if normalized_p_hp ~= 0 and normalized_e_hp ~= 0 then
        index = math.min(math.floor(math.min(normalized_p_hp/normalized_e_hp, 1.5)/1.5*#attacks), #attacks-1)
    end

    terminal_print('Choosing ', index+1, attacks[index+1])

    return Choice:new(attacks[index+1], nil)
end

return EnemyAI
