local Character = require('Character')
local EnemyTank = Character:new()

function EnemyTank:new(path)
    local instance = {
    }

    lang.instanceof(instance, EnemyTank)

    instance:init(path)

    return instance
end

function EnemyTank:draw()
    spr(self.x*16, self.y*16, 10, 1)

    local direction = self:findDirection()

    if direction ~= 0 then
        local arrows = {
            {x = 1, y = 6, dx = 0, dy = -16},
            {x = 2, y = 6, dx = 0, dy = 16},
            {x = 0, y = 6, dx = -16, dy = 0},
            {x = 3, y = 6, dx = 16, dy = 0},
        }

        local arrow = arrows[direction]

        spr(self.x*16+arrow.dx, self.y*16+arrow.dy, arrow.x, arrow.y)
    end
end

function EnemyTank:step()
    self.position = (self.position%#self.path)+1

    self.x = self.path[self.position].x
    self.y = self.path[self.position].y
end

function EnemyTank:battleDraw()
	pspr(128, 48, 464, 240, 128,128)
end


return EnemyTank 
