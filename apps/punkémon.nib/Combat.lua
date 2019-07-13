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

local function setMovesetTarget(moveset, self, enemy)
    for _, move in ipairs(moveset) do
        if move.targetDescription == 'self' then
            move.target = self
        else
            move.target = enemy
        end
    end

    return moveset
end

function Combat:new(player, character, battleStarter)
    character.moveset = setMovesetTarget(character.moveset, character, player)

    return new(Combat, {
        player = player or nil,
        character = character or nil,
        turn = 0,
        battleStarter = player,
        menu = CombatMenu:new(setMovesetTarget(player.moveset, player, character), player.inventories),
        enemyAI = EnemyAI:new(character),
        notifications = NotificationManager:new()
    })
end

function Combat:draw()
    -- Draw background
    custom_sprite(0,0 , 320,0 , 320, 240)
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
    elseif self.menu.selectedItem then
        playerChoice = Choice:new(nil, self.menu.selectedItem, self.player)
        enemyChoice = self.enemyAI:decision(self.player)
        self:nextTurn(playerChoice, enemyChoice)

        self.menu.selectedItem = nil
    end

    self.menu:update(dt)
    self.notifications:update(dt)
end

function Combat:nextTurn(playerChoice, enemyChoice)
    terminal_print('Turn:' .. tostring(self.turn))

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
                                                                        if self.character.battleStats.HP <= 0 or self.escape then
                                                                            self.finished = true

                                                                            self.player.battleStats.speed = self.player.baseStats.speed
                                                                            self.player.battleStats.attack = self.player.baseStats.attack
                                                                            self.player.battleStats.defense = self.player.baseStats.defense
                                                                        end
                                                       end)
                                      end)
                     end)
    end)
end

function Combat:executeChoice(choice)
    if choice.attack ~= nil then
        if choice.attack == true then
            self.notifications:add(Notification:new('Running Away!', 0.6))
            self.escape = true
        else
            terminal_print('Attack')
            choice.attack:use()
            choice.attack:effect()
            choice.attack.target:hit(choice.attack)
            choice.attack:visual()
            self.notifications:add(Notification:new(choice.attack.name..'!', 0.3))
        end
    elseif choice.item ~= nil then
        self.notifications:add(Notification:new(choice.item.name, 0.3))
        choice.item:use(choice.target)
    end
end

function Combat:drawStats(x, y, character)
    local name_str = character.name .. ' (' .. tostring(character.level) .. ')'

    local hp = character.battleStats.HP/character.baseStats.HP
    local hp_str = tostring(character.battleStats.HP) .. '/' .. tostring(character.baseStats.HP)

    local attack = character.battleStats.attack
    local defense = character.battleStats.defense
    local speed = character.battleStats.speed

    local attack_delta = attack-character.baseStats.attack
    local defense_delta = defense-character.baseStats.defense
    local speed_delta = speed-character.baseStats.speed

    local life_bar_length = 98

    fill_rect(x, y+3, life_bar_length+1, 10, 10)
    fill_rect(x, y+3, math.floor(life_bar_length*hp), 10, 13)
    rect(x+3, y+3, math.floor(life_bar_length*hp)-2, 9, 11)
    fill_rect(x, y+11, math.floor(life_bar_length*hp), 1, 11)

    swap_colors(11, 1)

    print(hp_str, x+47-#hp_str*4, y+4)

    if character.baseStats.element then
        local elementSpr = Attack.ElementSprites[character.baseStats.element]
        custom_sprite(x, y-8, elementSpr.x, elementSpr.y, elementSpr.w, elementSpr.h)
        print(name_str, x+16, y-8)
    else
        print(name_str, x, y-8)
    end

    function drawStat(x, y, statName, drawName, spr)
        function plusSign(str)
            if #str > 0 and str:sub(1, 1) ~= '-' then
                return '+'..str
            end

            return str
        end

        local statBase = character.baseStats[statName]
        local statBattle = character.battleStats[statName]
        local statDelta = statBattle-statBase
        local upColor = 13
        local downColor = 9

        custom_sprite(x, y, spr.x, spr.y, spr.w, spr.h)
        if statDelta ~= 0 then
            print(drawName, x+8, y-1)

            if statDelta > 0 then
                swap_colors(0, upColor)
            else
                swap_colors(0, downColor)
            end

            print(tostring(statBase) .. plusSign(tostring(statDelta)), x+8+(#drawName+1)*8, y-1)

            swap_colors(0, 0)
        else
            print(drawName .. ' ' .. tostring(statBase), x+8, y-1)
        end
    end

    -- Stats BG
    fill_rect(x+1, y+17, 100, 26, 3)
    rect(x+1, y+17, 100, 26, 1)

    -- Attack
    drawStat(x+2, y+20, 'attack', 'ATK', {x = 49, y = 82, w = 5, h = 6})

    -- Defense
    drawStat(x+2, y+28, 'defense', 'DEF', {x = 49, y = 90, w = 5, h = 6})

    -- Speed
    drawStat(x+2, y+36, 'speed', 'SPD', {x = 57, y = 82, w = 5, h = 6})

    swap_colors(11, 11)

    sprite(x, y, 0, 12)
    for i=1,5 do
        x += 14
        sprite(x, y, 1, 12)
    end
    sprite(x+15, y, 2, 12)
end

return Combat
