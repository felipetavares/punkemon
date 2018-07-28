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
  shield = player.equipment.shield

  function classifier(attack)
    local multiplayer = 1

    if shield then
      multiplayer = 
    end
  end

  function compare(a,b)
  end
	return Choice:new()
end

return EnemyAI