local Particle = require('Particle')

local ParticleSystem = {}

local function defaultUpdate(p, dt)
    p.position.x = p.position.x + p.speed.x * dt
    p.position.y = p.position.y + p.speed.y * dt
end

local function defaultDraw(particle)
    putp(particle.position.x, particle.position.y, particle.color)
end

local function defaultCreateParticle(particle)
	local colors = {
	{8, 9},
    {12, 13},
    {7, 11},
    {6, 10},
    {4, 11}
	}
	local c = math.random(1, #colors)
	
	local p = Particle:new(colors[c][2], colors[c][1], nil, {x = 1, y = 1})
	return p
end

function ParticleSystem:new(nParticles, position, emissionTime, loop, fnCreateParticle, fnUpdate, fnDraw)
    local instance = {
		nParticles = nParticles,
        particles = {},
		startEmission = -1,
		emissionTime = emissionTime or 0,
		active = false,
		position = position or { x = 1 , y = 1},
		fnCreateParticle = fnCreateParticle or defaultCreateParticle,
        fnDraw = fnDraw or defaultDraw,
        fnUpdate = fnUpdate or defaultUpdate,
		loop = loop
    }
	
	for p = 0, nParticles-1 do
		local particle = instance.fnCreateParticle()
		table.insert(instance.particles, particle)
	end

    lang.instanceof(instance, ParticleSystem)

    return instance
end

function ParticleSystem:draw()
    for _, p in ipairs(self.particles) do
        if p.active then
            self.fnDraw(p)
        end
    end
end

function ParticleSystem:update(dt)
    for _, p in ipairs(self.particles) do
        if p.active then
            self.fnUpdate(p, dt)
			if 	p.position.x < 0 or	p.position.x > 320 or
				p.position.y < 0 or	p.position.y > 240 then
					p.active = false
			end
        end
    end
end

function ParticleSystem:add(particle)
    table.insert(self.particles, particle)
end

function ParticleSystem:emit(x, y)
    x = x or 0
    y = y or 0

	self.active = true
	self.startEmission = time()
    for i, p in ipairs(self.particles) do
        p.position.x, p.position.y = x+self.position.x, y+self.position.y
		p.active = true
        if p.init then
            p:init(i, self.nParticles)
        end
		self.fnUpdate(p, self.emissionTime * i)
	end
end

function ParticleSystem:emitLine(dx, dy, x, y)
    x = x or 0
    y = y or 0

	self.active = true
	self.startEmission = time()
    for i, p in ipairs(self.particles) do
		p.position.x, p.position.y = x + self.position.x + dx * i , y + self.position.y + dy * i
		p.active = true
        if p.init then
            p:init(i, self.nParticles)
        end
		self.fnUpdate(p, self.emissionTime * i)
	end
end

function ParticleSystem:emitInsideRect(dx , dy)
	self.active = true
	self.startEmission = time()
	i = 0
    for _, p in ipairs(self.particles) do
		p.position.x, p.position.y = self.position.x + dx * math.random() , self.position.y + dy * math.random()
		p.active = true
        if p.init then
            p:init(i, self.nParticles)
        end
		self.fnUpdate(p, self.emissionTime * i)
		i += 1
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
