local Particle = require('Particle')

local ParticleSystem = {}

local function defaultUpdate(p, dt)
    p.position.x = particle.position.x + p.speed.x * dt
    p.position.y = particle.position.y + p.speed.y * dt
end

local function defaultDraw(x, y, color)
    putp(x, y, color)
end

function ParticleSystem:new(nParticles, position, color, accent, speed, fnUpdate, fnDraw)
    local instance = {
		nParticles = nParticles,
        particles = {},
		startEmission = -1,
		active = false,
		position = position,
		color = color or 8,	accent = accent or 9,
		speed = speed or { x = 0, y = 0},
        fnDraw = fnDraw or defaultDraw,
        fnUpdate = fnUpdate or defaultUpdate
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
        if p.active then
            self.fnDraw(p.position.x, p.position.y, p.color, p)
        end
    end
end

function ParticleSystem:update(dt)
    for _, p in ipairs(self.particles) do
        if p.active then
            self.fnUpdate(p, dt)
        end
    end
end

function ParticleSystem:add(particle)
    table.insert(self.particles, particle)
end

function ParticleSystem:emit()
	self:dprint()
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
