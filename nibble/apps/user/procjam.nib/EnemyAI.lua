local Character = require('Character')
local Choice = require('Choice')

EnemyAI = {}

function EnemyAI:new(controlledCharacter)
    local instance = {
		chara = controlledCharacter,
    }

    lang.instanceof(instance, EnemyAI)

    return instance
end

function EnemyAI:decision()
	--> Escolhe se irá usar o item carregado (se puder) ou irá atacar # Árvore de decisão
	return Choice:new()
end


return EnemyAI