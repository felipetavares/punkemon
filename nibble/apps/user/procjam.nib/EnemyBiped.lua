local Character = require('Character')
local EnemyBiped = Character:new()
local EnemyDescription = require('EnemyDescription')

function EnemyBiped:new(path, level)
    local instance = {
        tick = false,

        name = "Biped",
        level = level,
    }

    lang.instanceof(instance, lang.copy(EnemyBiped))

    instance:init(path)

    return instance
end

function EnemyBiped:getCombatCenter()
    return 200, 120
end

function EnemyBiped:init(path)
    Character.init(self, path)
end

function EnemyBiped:draw(camera)
    camera:spr(self.x*16, self.y*16, 10, 2)

    local direction = self:findDirection()

    if direction ~= 0 then
        local arrows = {
            {x = 1, y = 6, dx = 0, dy = -16},
            {x = 2, y = 6, dx = 0, dy = 16},
            {x = 0, y = 6, dx = -16, dy = 0},
            {x = 3, y = 6, dx = 16, dy = 0},
        }

        local arrow = arrows[direction]

        local c = (math.floor(clock()*12) % 6) + 2

        for i=2,8 do
            if i == c then
                col(c, 13)
            else
                col(i, 12)
            end
        end

        local offset = (math.sin(clock()*3)+1)*0.25+0.5

        camera:spr(self.x*16+arrow.dx*offset, self.y*16+arrow.dy*offset, arrow.x, arrow.y)

        for i=2,8 do
            col(i, i)
        end
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
