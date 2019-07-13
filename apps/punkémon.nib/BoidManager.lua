local BoidManager = {}

function BoidManager:new()
    local instance = {
        boids = {}
    }

    lang.instanceof(instance, BoidManager)

    return instance
end

function BoidManager:draw(camera)
    for _, boid in ipairs(self.boids) do
        boid:draw(camera)
    end
end

function BoidManager:update(dt)
    for _, boid in ipairs(self.boids) do
        local mates, mIntensity = self:closeTo(boid, 20)
        local overlap, oIntensity = self:closeTo(boid, 5)

        local heading = self.findHeading(mates)
        local closeCenter = self.findCenter(overlap)
        local farCenter = self.findCenter(mates)

        boid:update(dt, heading, closeCenter, farCenter, 2)
    end
end

function BoidManager:closeTo(boid, distance)
    local close = {}
    local intensity = 0

    for _, other in ipairs(self.boids) do
        if self.distance(boid, other) < distance and 
           boid.color == other.color then
            table.insert(close, other)

            intensity += self.distance(boid, other)
        end
    end

    return close, intensity
end

function BoidManager.distance(a, b)
    local dx = a.pos.x-b.pos.x
    local dy = a.pos.y-b.pos.y

    return math.sqrt(dx^2+dy^2)
end

function BoidManager.findHeading(boids)
    local a = 0

    for _, boid in ipairs(boids) do
        a += math.atan(boid.dir.y, boid.dir.x)/#boids
    end

    return a
end

function BoidManager.findCenter(boids)
    local p = {
        x = 0, y = 0
    }

    for _, boid in ipairs(boids) do
        p.x += boid.pos.x/#boids
        p.y += boid.pos.y/#boids
    end

    return p
end

function BoidManager:add(boid)
    table.insert(self.boids, boid)
end

return BoidManager
