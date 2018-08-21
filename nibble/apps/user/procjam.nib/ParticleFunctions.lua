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
				{x = (math.random() -0.5) * 10, y = math.random() * 10 + 20})

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
	pspr(particle.position.x, particle.position.y, 176, 16, 16, 16)
end

function tinyBubbleDraw(particle)
    putp(particle.position.x, particle.position.y, particle.color)
	
	putp(particle.position.x - 1 	, particle.position.y , particle.accent)
	putp(particle.position.x + 1 	, particle.position.y , particle.accent)
	putp(particle.position.x 		, particle.position.y - 1, particle.accent)
	putp(particle.position.x		, particle.position.y + 1, particle.accent)
end

-- Sparkles
function sparklesCreate()
	p =  Particle:new(15, nil, nil,  
                      {x = math.random() * 60 + 60, y = math.random() * 120 + 120})
	
    function p:init(i, n)
        self.lifeTime = math.random() * 0.25
        self.emissionTime = clock()

        self.i = i
    end
						
	return p
end

function sparklesUpdate(p, dt)
	p.position.y = p.position.y - p.speed.y * dt
	if p.lifeTime + p.emissionTime < clock() then
		p.active = false
	end
end

function sparklesDraw(particle)
    local c = 15

    putp(particle.position.x		, particle.position.y		, c)
	putp(particle.position.x - 1 	, particle.position.y 		, c)
	putp(particle.position.x + 1 	, particle.position.y 		, c)
	putp(particle.position.x 		, particle.position.y - 1	, c)
	putp(particle.position.x		, particle.position.y + 1	, c)
end

-- Tris
function trisCreate()
	p =  Particle:new(15, nil, nil,  
                      {x = 0, y = 0})
	
    function p:init(i, n)
        local x = math.floor((i-1)%math.floor(math.sqrt(n)))
        local y = math.floor((i-1)/math.floor(math.sqrt(n)))

        if (x+y) % 2 == 0 then
            self.dstAngle = math.pi/2
        else
            self.dstAngle = math.pi/2*3
        end

        self.life = 0
        self.size = 0

        self.dstsize = 7

        self.position.x = self.position.x+x*self.dstsize
        self.position.y = self.position.y+y*self.dstsize*2

        self.angle = self.dstAngle

        self.offset = x+y
    end
						
	return p
end

function trisUpdate(p, dt)
    local speed = 50

    p.size = math.max(math.min(1, p.life*speed-p.offset)*(p.dstsize+1), 0)
    p.angle = p.dstAngle*math.max(math.min(1, p.life*speed-p.offset), 0)

    p.life += dt

    if p.life-p.offset*0.05 > 0.5 then
        p.active = false
    end
end

function trisDraw(p)
    local x1, y1 = 1, 0
    x1, y1 = math.cos(p.angle)*x1-math.sin(p.angle)*y1, math.sin(p.angle)*x1+math.cos(p.angle)*y1
    x1, y1 = x1*p.size, y1*p.size

    local x2, y2 = -1, -1
    x2, y2 = math.cos(p.angle)*x2-math.sin(p.angle)*y2, math.sin(p.angle)*x2+math.cos(p.angle)*y2
    x2, y2 = x2*p.size, y2*p.size

    local x3, y3 = -1, 1
    x3, y3 = math.cos(p.angle)*x3-math.sin(p.angle)*y3, math.sin(p.angle)*x3+math.cos(p.angle)*y3
    x3, y3 = x3*p.size, y3*p.size

    x1, y1 = p.position.x+x1, p.position.y+y1
    x2, y2 = p.position.x+x2, p.position.y+y2
    x3, y3 = p.position.x+x3, p.position.y+y3

    trif(x1, y1, x2, y2, x3, y3, 15)
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
