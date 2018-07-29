local EnemyAI = require('EnemyAI')
local Choice = require('Choice')
local CombatMenu = require('CombatMenu')
local Attack = require('Attack')
local Combat = {}

PLAYER_START = 0
ENEMY_START = 1

local function setMovesetTarget(moveset, target)
    for _, move in ipairs(moveset) do
        move.target = target
    end

    return moveset
end

function Combat:new(player, character, battleStarter)
    local instance = {
        player = player or nil,
        character = character or nil,
		turn = 0,
		battleStarter = player,
        menu = CombatMenu:new(setMovesetTarget(player.moveset, character), nil),
		
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

    -- Player stats
    self:drawStats(206, 186, self.player)
    -- Enemy stats
    self:drawStats(20, 16, self.character)

    self.menu:draw()
end

function Combat:update(dt)
    if self.menu.selectedAttack then
		playerChoice = Choice:new(self.menu.selectedAttack, nil)
		enemyChoice = self.enemyAI:decision(self.player)
        self:nextTurn(playerChoice, enemyChoice)

        self.menu.selectedAttack = nil
    end

    if self.character.battleStats.HP <= 0 then
        self.finished = true       
    end
	
    self.menu:update()
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
        dprint(choice.attack.target)
		choice.attack.effect(choice.attack.target)
	elseif choice.item ~= nil then
		dprint('Item')
	end
end

function Combat:drawStats(x, y, character)
    local hp = character.battleStats.HP/character.baseStats.HP
    local attack = character.battleStats.attack
    local defense = character.battleStats.defense
    local speed = character.battleStats.speed

    rectf(x, y+3, 94, 10, 13)
    rectf(x, y+3, math.floor(93*hp), 10, 11)
    rect(x+3, y+3, math.floor(93*hp)-2, 9, 7)
    rectf(x, y+11, math.floor(93*hp), 1, 7)

    col(7, 1)

    pspr(x+2, y+20, 49, 82, 5, 6)
    print('ATTACK ' .. tostring(attack), x+10, y+20-1)
    pspr(x+2, y+28, 49, 90, 5, 6)
    print('DEFENSE ' .. tostring(defense), x+10, y+28-1)
    pspr(x+2, y+36, 57, 82, 5, 6)
    print('SPEED ' .. tostring(speed), x+10, y+36-1)

    col(7, 7)

    spr(x, y, 0, 12)
    for i=1,4 do
        x += 16
        spr(x, y, 1, 12)
    end
    spr(x+16, y, 2, 12)
end

return Combat
