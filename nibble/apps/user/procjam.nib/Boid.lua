local Boid = {}

function Boid:new(color, accent, animation)
    local instance = {
        -- Where is this boid off to?
        dir = {
            x = math.random()-0.5, y = math.random()-0.5
        },
        -- Where is this boid?
        pos = {
            x = 300*math.random()+10, y = 240/2+(math.random()-0.5)*240
        },
        -- Previous positions
        snake = {},
        speed = 0.5,
        length = 3,
        color = color or 8, accent = accent or 9,
        contour = 1,
        height = 8,
        turnSide = -1,
        turnUpdateChance = 0.3,
        animated = (animation ~= nil) or false,
        animation = animation or {},
        animationPos = 1,
        elapsedFrameTime = 0
    }

    local l = math.sqrt(instance.dir.x^2+instance.dir.y^2)

    instance.dir.x = instance.dir.x/l
    instance.dir.y = instance.dir.y/l

    lang.instanceof(instance, Boid)

    return instance
end

function Boid:drawAround(x, y)
    local p

    putp(x-1, y, self.contour)
    putp(x+1, y, self.contour)
    putp(x, y-1, self.contour)
    putp(x, y+1, self.contour)
end

function Boid:draw(camera)
    if self.animated then
        camera:spr(self.pos.x-20, self.pos.y-20,
            self.animation[self.animationPos][1], self.animation[self.animationPos][2])
    else
        -- Draw shadows
        for i, p in ipairs(self.snake) do
            self:drawAround(p.x-camera.x, p.y-camera.y)
        end

        -- Draw fish
        for i, p in ipairs(self.snake) do
            if i == 3 then
                putp(p.x-camera.x, p.y-camera.y, self.accent)
            else
                putp(p.x-camera.x, p.y-camera.y, self.color)
            end

            local color = getp(p.x-camera.x, p.y+self.height-camera.y)
            if (color ~= self.color and color ~= self.accent) then
                putp(p.x-camera.x, p.y+self.height-camera.y, self.contour)
            end
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
end

function Boid:update(dt, heading, closeCenter, farCenter, overlapIntensity)
    if self.animated then
        if self.elapsedFrameTime > 0.1 then
            self.animationPos = ((self.animationPos)%#self.animation)+1
            self.elapsedFrameTime = 0
        else
            self.elapsedFrameTime += dt
        end
    end

    local intensity = 1

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
    if self.animated then
        self.pos.x = (self.pos.x+self.dir.x*self.speed)%360
        self.pos.y = (self.pos.y+self.dir.y*self.speed)%280
    else
        self.pos.x = (self.pos.x+self.dir.x*self.speed)%320
        self.pos.y = (self.pos.y+self.dir.y*self.speed)%240
    end

    -- Update the turn side
    if math.random() > 1-self.turnUpdateChance then
        self.turnSide = self.turnSide*-1
    end
end

return Boid
