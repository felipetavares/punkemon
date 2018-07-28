local Character = require('Character')
local EnemyBiped = Character:new()

function EnemyBiped:new(path)
    local instance = {
        tick = false
    }

    lang.instanceof(instance, lang.copy(EnemyBiped))

    instance:init(path)

    return instance
end

function EnemyBiped:init(path)
    Character.init(self, path)

    self.baseStats.HP = 5

    self.battleStats.HP = self.baseStats.HP
end

function EnemyBiped:draw()
    spr(self.x*16, self.y*16, 10, 2)

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

function EnemyBiped:battleDraw()
    local t = clock()

    local deltay = math.sin(t*6)*4;
    local deltax = math.sin(t*6)*4;

    -- Draws body
	pspr(190, 99, 448, 336, 48, 48)

    -- Draws head 
	pspr(190, 20+deltay/2+2, 448, 240, 48, 96)

    -- Right arm
    pspr(160+deltax/2, 90+deltay, 496, 304, 48, 64)

    -- Left arm
    pspr(210-deltax, 92+deltay, 496, 240, 64, 64)
end

function EnemyBiped:step()
    if self.tick then
        self.position = (self.position%#self.path)+1
        self.tick = false
    else
        self.tick = true
    end

    self.x = self.path[self.position].x
    self.y = self.path[self.position].y
end

return EnemyBiped 
