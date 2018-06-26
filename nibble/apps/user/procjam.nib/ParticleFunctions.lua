local Particle = require('Particle')

local colors = {
	{8, 9}, -- Rosa
	{12, 13}, -- Amarelo
	{7, 11}, -- Verde
	{6, 10}, -- Azul
	{4, 11} -- Roxo
}

-- Bubbles
function bubbleCreate()	
	return Particle:new(6,10, nil, 
				{x = (math.random() -0.5) * 5, y = math.random() * 2 + 6})
end

function bubbleUpdate(p, dt)
	p.position.y = p.position.y - p.speed.y * dt
	p.position.x = p.position.x + ( p.speed.x * math.sin(time()) ) * dt 
end

function bubbleDraw(particle)
	pspr(particle.position.x, particle.position.y, 0,80, 8, 16)
end


function tinyBubbleDraw(particle)
    putp(particle.position.x, particle.position.y, particle.color)
	
	putp(particle.position.x - 1 	, particle.position.y , particle.accent)
	putp(particle.position.x + 1 	, particle.position.y , particle.accent)
	putp(particle.position.x 		, particle.position.y - 1, particle.accent)
	putp(particle.position.x		, particle.position.y + 1, particle.accent)
end

-- Heal

function healCreate()

	local c = math.random(1, #colors)
	
	p =  Particle:new(colors[3][2], nil, nil,  
						{x = 0, y = math.random() * 15 + 15})
	
	p.lifeTime = math.random() * 3
	p.emissionTime = clock()
						
	return p
end

function healUpdate(p, dt)
	p.position.y = p.position.y - p.speed.y * dt
	if p.lifeTime + p.emissionTime < clock() then
		p.active = false
	end
end

function healDraw(particle)
    putp(particle.position.x		, particle.position.y		, particle.color)
	putp(particle.position.x - 1 	, particle.position.y 		, particle.color)
	putp(particle.position.x + 1 	, particle.position.y 		, particle.color)
	putp(particle.position.x 		, particle.position.y - 1	, particle.color)
	putp(particle.position.x		, particle.position.y + 1	, particle.color)
end


-- Hits
function hitCreate()
	
	speed = {x = (math.random() - 0.5) * 50,
			y = (math.random() - 0.5) * 50}
	
	p =  Particle:new(colors[2][1], nil, nil,  speed)
	
	p.tail = Particle:new(colors[2][1], nil, nil,
		{x = speed.x - 5 , y = speed.y - 5})
	
	p.lifeTime = math.random() * 0.5
	p.emissionTime = clock()
						
	return p
end

function hitUpdate(p, dt)
	p.tail.position.x, p.tail.position.y  = p.position.x , p.position.y
    p.position.x = p.position.x + p.speed.x * dt
    p.position.y = p.position.y + p.speed.y * dt
	if p.lifeTime + p.emissionTime < clock() then
		p.active = false
	end
end

function hitDraw(p)
	line(p.position.x , p.position.y,
		p.tail.position.x, p.tail.position.y,
		p.color)
end

function sandAttackCreate()

	local c = math.random(1, #colors)
	
	p =  Particle:new(colors[1][2], nil, nil,  
						{x = math.random() * 15 + 15, y = math.random() * 15 + 15})
	
	p.lifeTime = math.random() * 3
	p.emissionTime = clock()
						
	return p
end

function sandAttackUpdate(p, dt)
    p.position.x = p.position.x + p.speed.x * dt
    p.position.y = p.position.y + p.speed.y * dt
	if p.lifeTime + p.emissionTime < clock() then
		p.active = false
	end
end
