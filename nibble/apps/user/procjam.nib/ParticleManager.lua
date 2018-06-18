-- Functions to generate and control the particles

local ParticleManager = {}

function ParticleManager:new()
    local instance = {
        particleSystems = {}
    }

    lang.instanceof(instance, ParticleManager)

    return instance
end

function ParticleManager:draw()
    for _, ps in ipairs(self.particleSystems) do
        ps:draw()
    end
end

function ParticleManager:update(dt)
    for _, ps in ipairs(self.particleSystems) do
        ps:update(dt)
    end
end

function ParticleManager:add(particleSystem)
    table.insert(self.particleSystems, particleSystem)
end


return ParticleManager