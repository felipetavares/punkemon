local Attack = require('Attack')
local Character = {}
local EnemyDescription = require('EnemyDescription')

local ParticleSystem = require('ParticleSystem')
require ('ParticleFunctions')

function Character:new()
    local instance = {
        x = 0,
        y = 0,
        path = {},
        position = 1,
        level = 1,
        name = 'Basic',
		
		baseStats = {},
		
		battleStats = {},
		
		moveset = {}
    }

    lang.instanceof(instance, Character)

    return instance
end

function Character:init(path, particleManager)
    local init = {x = 0, y = 0}
    
    if path and path[self.position] then
        init = path[self.position]
    end

    self.x = init.x
    self.y = init.y
    self.path = path or {}

    -- Load the character stats
    self.baseStats   = lang.copy(EnemyDescription.basicStats[self.name .. tostring(self.level) ])
    self.battleStats = lang.copy(EnemyDescription.basicStats[self.name .. tostring(self.level) ])

    self.moveset     = lang.copy(EnemyDescription.moveset[self.name .. tostring(self.level)])
end

function Character:findDirection()
    if self.path then
        if self.path[self.position+1] then
            local nextPosition = self.path[self.position+1]

            local dx, dy = nextPosition.x-self.x, nextPosition.y-self.y

            if dx == 0 then
                if dy > 0 then
                    return 2
                else
                    return 1
                end
            else
                if dx > 0 then
                    return 4
                else
                    return 3
                end
            end
        end
    end

    return 0
end

function Character:battleDraw()
	dprint('Opa coleguinha, precisa desenhar esse inimigo maneiro aqui')
end

function Character:print()
    s = ''

    s = s .. tostring(self.x) .. ',' .. tostring(self.y) .. '\n'
    s = s .. tostring(self.baseStats) .. '\n'
    s = s .. tostring(self.battleStats) .. '\n'
    s = s .. tostring(self.moveset) .. '\n'
    dprint(s)
end

function Character:hit(move)
    self:hitDamage(move)

    self:hitParticles()
end

function Character:hitParticles()
    self.psystem:emit()
end

function Character:hitDamage(move)
	damage = move.power * self.battleStats.attack / move.target.battleStats.defense * (0.85 + math.random() * 0.15)
    
	damage = damage * Attack.elementalMultiplier[move.element][move.target.baseStats.element]

    dprint('Damage:', math.floor(damage))

    self.battleStats.HP = self.battleStats.HP-math.floor(damage+0.5)
end

return Character
