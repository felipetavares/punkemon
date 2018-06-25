local EnemyAI = require('EnemyAI')
local Choice = require('Choice')
local Combat = {}

PLAYER_START = 0
ENEMY_START = 1

function Combat:new(player, character, battleStarter)
    local instance = {
        player = player or nil,
        character = character or nil,
		turn = 0,
		battleStarter = PLAYER,
		
		enemyAI = EnemyAI:new(character),
    }

    lang.instanceof(instance, Combat)

    return instance
end

function Combat:draw()
    clr(1)
end

function Combat:update(dt)
	-- Passeio pela UI --
    if btp(DOWN) then
		playerChoice = Choice:new()
		enemyChoice = self.enemyAI:decision()
        self:nextTurn(playerChoice, enemyChoice)
	end
end

function Combat:nextTurn(playerChoice, enemyChoice)
	dprint('Turn:' .. tostring(self.turn))
	self.turn += 1
end 


return Combat
