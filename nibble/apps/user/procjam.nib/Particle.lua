local Particle = {}

function Particle:new(color, accent, position, speed)
    local instance = {
		position = position,
		color = color or 8, accent = accent or 9,
		active = false,
		speed = speed or { x = 0, y = 0},
    }

    lang.instanceof(instance, Particle)
	
    return instance
end

function Particle:draw()
	if self.active then
		putp(self.position.x, self.position.y, self.color)
	end
end

function Particle:update(dt)
	if self.active then
		self.position.x = particle.position.x + self.speed.x * dt
		self.position.y = particle.position.y + self.speed.y * dt
	end
end

function Particle:dprint()
	s = ''
	s = s.. 'Position: '.. tostring(self.position) .. '\n'
	s = s.. 'Color: ' .. self.color .. '\n'
	s = s.. 'Accent: ' .. self.accent .. '\n'
	s = s.. 'Active : ' ..  tostring(self.active) .. '\n'
	dprint(s)
end

return Particle
