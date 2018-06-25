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
		battleStarter = player,
		
		enemyAI = EnemyAI:new(character),
    }

    lang.instanceof(instance, Combat)

    return instance
end

function Combat:draw()
	-- Draw background
	pspr(0,0 , 320,0 , 320, 240)
	-- Draw boneco
	self.character:battleDraw()
	
	-- Draw sereia comedora de cu
	self.player:battleDraw()
	
	-- Draw static UI
	
	-- Draw dynamic UI
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
	local first = playerChoice
	local second = enemyChoice
	if self.player.battleStats.speed < self.character.battleStats.speed then
		first = enemyChoice		
		second = playerChoice
	end
	self:executeChoice(first)
	self:executeChoice(second)
	self.turn += 1
end 

function Combat:executeChoice(choice)
	if choice.attack ~= nil then
		dprint('Attack')
		choice.attack.effect(choice.target)
	elseif choice.item ~= nil then
		dprint('Item')
	end
end


return Combat
