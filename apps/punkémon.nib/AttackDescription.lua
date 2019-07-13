local Types = require("Attack")
local Attack = require('Attack')

local ParticleSystem = require('ParticleSystem')
require ('ParticleFunctions')

local attackDesc = {
    ['Slash'] = {
		name = 'Slash',
		power = 25,
		accuracy = 1,
		element = Types.TECH,
		pp = 5,
		target = 'enemy',
		effect = function() end,
        visualCreation = function(self)
            self.ps = ParticleSystem:new(40, {x = 0, y = 0}, 0, false, slashCreate, slashUpdate, slashDraw)
            particleManager:add(self.ps)
        end,
        visual = function (self)
            self.ps.position.x, self.ps.position.y = self.target:getCombatCenter()
            self.ps:emitLine(2, 2, -50, -60)

            Delayed.exec(0.1, function()
                self.ps:emitLine(-2, 2, 50, -60)
            end)
        end
    },
    ['Bubbles'] = {
		name = 'Bubbles',
		power = 0,
		accuracy = 1,
		element = Types.NAT,
		pp = 3,
		target = 'enemy',
		effect = function(self)
            self.changeStat(self.target.battleStats, 'attack', -10)
        end,
        visualCreation = function(self)
            self.ps = ParticleSystem:new(10, {x = 0, y = 0}, 0.3, false, bubbleCreate, bubbleUpdate, bubbleDraw)
            particleManager:add(self.ps)
        end,
        visual = function (self)
            self.ps.position.x, self.ps.position.y = self.target:getCombatCenter()

            self.ps:emit()
        end
    },
    ['Scales'] = {
		name = 'Scales',
		power = 0,
		accuracy = 1,
		element = Types.NAT,
		pp = 3,
		target = 'self',
		effect = function(self)
            self.changeStat(self.target.battleStats, 'defense', 10)
        end,
        visualCreation = function(self)
            self.ps = ParticleSystem:new(64, {x = 0, y = 0}, 0, false, trisCreate, trisUpdate, trisDraw)
            particleManager:add(self.ps)
        end,
        visual = function (self)
            self.ps.position.x, self.ps.position.y = self.target:getCombatCenter()

            self.ps:emit(-20, -40)
        end
    },
    ['Diva'] = {
		name = 'Diva',
		power = 0,
		accuracy = 1,
		element = Types.NAT,
		pp = 3,
		target = 'self',
		effect = function(self)
            self.changeStat(self.target.battleStats, 'speed', 10)
        end,
        visualCreation = function(self)
            self.ps = ParticleSystem:new(50, {x = 0, y = 0}, 0, false, sparklesCreate, sparklesUpdate, sparklesDraw)
            particleManager:add(self.ps)
        end,
        visual = function (self)
            self.ps.position.x, self.ps.position.y = self.target:getCombatCenter()

            self.ps:emitLine(1, 0, -25, 20)
        end
    },
    ['Punch'] = {
		name = 'Punch',
		power = 12,
		accuracy = 1,
		element = Types.TECH,
		pp = 3,
		target = 'enemy',
		effect = function() end,
        visualCreation = function(self)
            self.ps = ParticleSystem:new(60, {x = 0, y = 0}, 0, false, hitCreate, hitUpdate, hitDraw)
            particleManager:add(self.ps)
        end,
        visual = function (self)
            self.ps.position.x, self.ps.position.y = self.target:getCombatCenter()
            
            for i=0,5 do
                Delayed.exec(i*0.1, function()
                    self.ps:emit((math.random()-0.5)*40, (math.random()-0.5)*80)
                end)
            end
        end
    },
}

return attackDesc
