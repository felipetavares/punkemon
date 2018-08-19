local EnemyAI = require('EnemyAI')
local Choice = require('Choice')
local CombatMenu = require('CombatMenu')
local Attack = require('Attack')
local Types = require('Attack')
local NotificationManager = require('NotificationManager')
local Notification = require('Notification')

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
    character.moveset = setMovesetTarget(character.moveset, player)

    local instance = {
        player = player or nil,
        character = character or nil,
		turn = 0,
		battleStarter = player,
        menu = CombatMenu:new(setMovesetTarget(player.moveset, character), nil),
		enemyAI = EnemyAI:new(character),
        notifications = NotificationManager:new()
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

    self.notifications:draw()
end

function Combat:update(dt)
    if self.menu.selectedAttack then
		playerChoice = Choice:new(self.menu.selectedAttack, nil)
		enemyChoice = self.enemyAI:decision(self.player)
        self:nextTurn(playerChoice, enemyChoice)

        self.menu.selectedAttack = nil
    end

    self.menu:update(dt)
    self.notifications:update(dt)
end

function Combat:nextTurn(playerChoice, enemyChoice)
	dprint('Turn:' .. tostring(self.turn))

	local first = playerChoice
    local firstCharacter = self.player
	local second = enemyChoice
    local secondCharacter = self.character

	if self.player.battleStats.speed < self.character.battleStats.speed then
		first = enemyChoice		
		second = playerChoice
        firstCharacter = self.character
        secondCharacter = self.player
        self.notifications:add(Notification:new('The enemy was faster!', 0.3))
    else
        self.notifications:add(Notification:new('You were faster!', 0.3))
	end

	Delayed.exec(0.7, function()
        self:executeChoice(first)

        Delayed.exec(0.7, function()
            if secondCharacter.battleStats.HP > 0 then
                self:executeChoice(second)
            end

            self.turn += 1

            Delayed.exec(0.7, function()
                self.menu:open()
            
                Delayed.exec(0.3, function()
                    if self.character.battleStats.HP <= 0 then
                        self.finished = true       
                    end
                end)
            end)
        end)
    end)
end 

function Combat:executeChoice(choice)
	if choice.attack ~= nil then
		dprint('Attack')
        choice.attack.target:hit(choice.attack)
        choice.attack:visual()
        self.notifications:add(Notification:new(choice.attack.name..'!', 0.3))
	elseif choice.item ~= nil then
		dprint('Item')
	end
end

function Combat:drawStats(x, y, character)
    local name_str = character.name .. ' Lvl ' .. tostring(character.level) .. ''

    local hp = character.battleStats.HP/character.baseStats.HP
    local hp_str = tostring(character.battleStats.HP) .. '/' .. tostring(character.baseStats.HP)
    local attack = character.battleStats.attack
    local defense = character.battleStats.defense
    local speed = character.battleStats.speed

    rectf(x, y+3, 94, 10, 13)
    rectf(x, y+3, math.floor(93*hp), 10, 11)
    rect(x+3, y+3, math.floor(93*hp)-2, 9, 7)
    rectf(x, y+11, math.floor(93*hp), 1, 7)

    col(7, 1)

    print(hp_str, x+47-#hp_str*4, y+4)

    print(name_str, x, y-8)

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
