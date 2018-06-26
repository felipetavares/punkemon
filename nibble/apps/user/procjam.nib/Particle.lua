local Particle = {}

function Particle:new(color, accent, position, speed)
    local instance = {
		position = position or { x = 0, y = 0},
		color = color or 8, accent = accent or 9,
		active = false,
		speed = speed or { x = 0, y = 0},
    }

    lang.instanceof(instance, Particle)
	
    return instance
end

function Particle:dprint()
	s = ''
	s = s.. 'Position: '.. tostring(self.position) .. '\n'
	s = s.. 'Color: ' .. self.color .. '\n'
	s = s.. 'Accent: ' .. self.accent .. '\n'
	s = s.. 'Active: ' ..  tostring(self.active) .. '\n'
	s = s.. 'Speed : ' .. tostring(self.speed.x) .. ','.. tostring(self.speed.y) .. '\n'
	dprint(s)
end

return Particle