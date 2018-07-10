local EnemyAI = require('EnemyAI')
local Choice = require('Choice')
local CombatMenu = require('CombatMenu')
local Attack = require('Attack')
local Combat = {}

PLAYER_START = 0
ENEMY_START = 1

function Combat:new(player, character, battleStarter)
    dprint('ch', character)

    -- TODO: Get attacks from the player
    local tackle = Attack:new('Tackle', 10, 1, 1, 3, character, function () end)
    local sand = Attack:new('Sand', 10, 1, 1, 5, character, function () end)
    local harden = Attack:new('Harden', 10, 1, 1, 5, player, function () end)
    local growl = Attack:new('Growl', 10, 1, 1, 5, character, function () end)

    local instance = {
        player = player or nil,
        character = character or nil,
		turn = 0,
		battleStarter = player,
        menu = CombatMenu:new({tackle,
                               sand,
                               harden,
                               growl}, nil),
		
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
    self:drawStats(206, 186, 1)
    -- Enemy stats
    self:drawStats(20, 16, 1)

    self.menu:draw()
end

function Combat:update(dt)
    if self.menu.selectedAttack then
		playerChoice = Choice:new(self.menu.selectedAttack, nil)
		enemyChoice = self.enemyAI:decision()
        self:nextTurn(playerChoice, enemyChoice)

        self.menu.selectedAttack = nil
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

function Combat:drawStats(x, y, hp)
    rectf(x, y+3, 96*hp, 10, 11)
    rect(x+3, y+3, 96*hp-5, 9, 7)
    rectf(x, y+11, 96*hp, 1, 7)

    col(7, 1)

    pspr(x+2, y+20, 49, 82, 5, 6)
    print('Shield ' .. tostring(12), x+10, y+20-1)
    pspr(x+2, y+28, 49, 90, 5, 6)
    print('Sword ' .. tostring(6), x+10, y+28-1)
    pspr(x+2, y+36, 57, 82, 5, 6)
    print('Speed ' .. tostring(2), x+10, y+36-1)

    col(7, 7)

    spr(x, y, 0, 12)
    for i=1,4 do
        x += 16
        spr(x, y, 1, 12)
    end
    spr(x+16, y, 2, 12)
end

return Combat
