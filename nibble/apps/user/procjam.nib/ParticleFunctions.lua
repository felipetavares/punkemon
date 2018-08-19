local Particle = require('Particle')

local colors = {
	{8, 9}, -- Rosa
	{12, 13}, -- Amarelo
	{7, 11}, -- Verde
	{6, 10}, -- Azul
	{4, 11} -- Roxo
}

-- Slash
function slashCreate()	
	p = Particle:new(15, 0, nil, 
                        {x = 0, y = 0})

    function p:init (i, n)
        self.size = 0 
        self.life = (n-i+1)*math.pi*2/n
    end

    return p
end

function slashUpdate(p, dt)
    p.life += dt*30

    p.size = math.abs(math.sin(p.life/2)*4)

    if p.life > math.pi*2 then
        p.active = false
    end
end

function slashDraw(p)
    circf(p.position.x, p.position.y, p.size, p.color)
end

-- Bubbles
function bubbleCreate()	
    local p = Particle:new(6,10, nil, 
				{x = (math.random() -0.5) * 5, y = math.random() * 2 + 6})

    function p:init (i, n)
        p.life = 2 
    end

    return p
end

function bubbleUpdate(p, dt)
    if dt < 1 then
        p.life -= dt
    end

	p.position.y = p.position.y - p.speed.y * dt
	p.position.x = p.position.x + ( p.speed.x * math.sin(time()) ) * dt 

    if p.life <= 0 then
        p.active = false
    end
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
	speed = {x = (math.random() - 0.5) * 400,
			y = (math.random() - 0.5) * 400}
	
	p =  Particle:new(15, nil, nil,  speed)
	
	p.tail = Particle:new(15, nil, nil,
		{x = speed.x - 5 , y = speed.y - 5})
	
    function p:init (i, n)
        self.lifeTime = math.random() * 0.1
        self.emissionTime = clock()
    end
						
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
