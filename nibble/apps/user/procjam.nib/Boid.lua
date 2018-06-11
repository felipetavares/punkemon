local Boid = {}

function Boid:new()
    local instance = {
        -- Where is this boid off to?
        dir = {
            x = math.random()-0.5, y = math.random()-0.5
        },
        -- Where is this boid?
        pos = {
            x = 320/2, y = 240/2
        },
        -- Previous positions
        snake = {},
        speed = 0.5,
        length = 3,
        color = 6,
        accent = 14,
        contour = 2,
        height = 5,
        turnSide = -1,
        turnUpdateChance = 0.3
    }

    local l = math.sqrt(instance.dir.x^2+instance.dir.y^2)

    instance.dir.x = instance.dir.x/l
    instance.dir.y = instance.dir.y/l

    lang.instanceof(instance, Boid)

    return instance
end

function Boid:drawAround(x, y)
    local p

    p = getp(x-1, y)
    if (p ~= self.color and p ~= self.accent) then
        putp(x-1, y, self.contour)
    end
    p = getp(x+1, y)
    if (p ~= self.color and p ~= self.accent) then
        putp(x+1, y, self.contour)
    end
    p = getp(x, y-1)
    if (p ~= self.color and p ~= self.accent) then
        putp(x, y-1, self.contour)
    end
    p = getp(x, y+1)
    if (p ~= self.color and p ~= self.accent) then
        putp(x, y+1, self.contour)
    end
end

function Boid:draw()
    for i, p in ipairs(self.snake) do
        if i == 3 then
            putp(p.x, p.y, self.accent)
        else
            putp(p.x, p.y, self.color)
        end

        local color = getp(p.x, p.y+self.height)
        if (color ~= self.color and color ~= self.accent) then
            putp(p.x, p.y+self.height, self.contour)
        end

        self:drawAround(p.x, p.y)
    end

    if #self.snake > self.length then
        -- Remove the first snake position
        table.remove(self.snake, 1)
    end

    -- Add a new one
    if #self.snake == 0 or
       self.snake[#self.snake].x ~= math.floor(self.pos.x) or
       self.snake[#self.snake].y ~= math.floor(self.pos.y) then
        table.insert(self.snake, {x = math.floor(self.pos.x), y = math.floor(self.pos.y)})
    end
end

function Boid:update(dt, heading, closeCenter, farCenter, overlapIntensity)
    local intensity = 1

    -- Avoid walls
    if self.pos.y < 10 then
        heading = math.pi*3/2
        intensity = -self.pos.y
    elseif self.pos.y > 230 then
        heading = -math.pi*3/2
        intensity = self.pos.y-230
    elseif self.pos.x < 10 then
        heading = -math.pi
        intensity = -self.pos.x
    elseif self.pos.x > 310 then
        heading = math.pi
        intensity = self.pos.x-310
    end

    -- Update heading
    local ang = math.atan(self.dir.y, self.dir.x)
    local dh = heading-ang

    if dh > math.pi or dh < -math.pi then
        dh = -dh
    end

    ang = ang+dh*dt*intensity+(math.random()*0.1*self.turnSide)

    self.dir.x = math.cos(ang)
    self.dir.y = math.sin(ang)

    -- Avoid close boids
    local dx, dy = self.pos.x-closeCenter.x, self.pos.y-closeCenter.y
    
    self.pos.x = self.pos.x + dx*dt*overlapIntensity
    self.pos.y = self.pos.y + dy*dt*overlapIntensity

    -- Merge to close-ish boids
    dx, dy = farCenter.x-self.pos.x, farCenter.y-self.pos.y
    
    self.pos.x = self.pos.x + dx*dt/4
    self.pos.y = self.pos.y + dy*dt/4
    
    -- Move in the heading direction
    self.pos.x = self.pos.x+self.dir.x*self.speed
    self.pos.y = self.pos.y+self.dir.y*self.speed

    -- Update the turn side
    if math.random() > 1-self.turnUpdateChance then
        self.turnSide = self.turnSide*-1
    end
end

return Boid
