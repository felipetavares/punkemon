local Particle = require('Particle')

local ParticleSystem = {}

function ParticleSystem:new(nParticles, position, color, accent, speed)
    local instance = {
		nParticles = nParticles,
        particles = {},
		startEmission = -1,
		active = false,
		position = position,
		color = color or 8,	accent = accent or 9,
		speed = speed or { x = 0, y = 0} 
    }
	
	for p = 0, nParticles do
		particle = Particle:new(instance.color, instance.accent, {x = 0, y = 0})
		instance.particles[p] = particle
	end

    lang.instanceof(instance, ParticleSystem)

    return instance
end

function ParticleSystem:draw()
    for _, p in ipairs(self.particles) do
		p:draw()
    end
end

function ParticleSystem:update(dt)
    for _, p in ipairs(self.particles) do
		p:update(dt)
    end
end

function ParticleSystem:add(particle)
    table.insert(self.particles, particle)
end

function ParticleSystem:Emit()
	self.dprint(self)
	self.active = true
    for _, p in ipairs(self.particles) do
		p.position = self.position
		p.speed = self.speed
		p.active = true
    end
end

function ParticleSystem:dprint()
	s = ''
	s = s.. 'NParticles: '.. self.nParticles .. '\n'
	s = s.. 'StartEmission: ' .. self.startEmission .. '\n'
	s = s.. 'Active : ' .. tostring(self.active) .. '\n'
	s = s.. 'Position: ' .. self.position.x  ..',' .. self.position.y .. '\n'
	dprint(s)
end

return ParticleSystem