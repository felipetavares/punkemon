-- Functions to generate and control the particles

local ParticleManager = {}

function ParticleManager:new()
    return new(ParticleManager, {
                   particleSystems = {}
    })
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
    insert(self.particleSystems, particleSystem)
end


return ParticleManager
