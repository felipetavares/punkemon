-- Particle Effects

require('ParticleFunctions')
local ParticleSystem = require('ParticleSystem')

local Effects = {}

Effects.Effect = {}

function Effects.Effect:start(...)
    self.system:emit(...)
end

-- Explosion

Effects.Explosion = Effects.Effect

function Effects.Explosion:new()
    local instance = new(Effects.Explosion, {
        system1 = ParticleSystem:new(10, {x = 0, y = 0}, 0, false, hitCreate, hitUpdate, hitDraw),
        system2 = ParticleSystem:new(10, {x = 0, y = 0}, 0, false, sparklesCreate, sparklesUpdate, sparklesDraw)
    })

    particleManager:add(instance.system1)
    particleManager:add(instance.system2)

    return instance
end

function Effects.Explosion:start(x, y)
    self.system1:emit(x, y)
    self.system2:emitLine(16/10, 0, x-8, y)
end

return Effects
