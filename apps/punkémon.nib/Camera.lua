-- Camera System
-- Exposes the same drawing API
-- as niblib but allows for transformations

local Easing = require('Easing')

local Camera = {}

function Camera:new()
    return new(Camera, {
        -- Stack of positions
        stack = {},

        x = 0,
        y = 0,

        -- Current interpolation
        -- Start point and end points as 
        -- tuples with (x, y, t) plus
        -- an easing function
        interpolation = {
            to = {
                x = 0, y = 0, t = 0
            },
            from = {
                x = 0, y = 0, t = 0
            },
            easing = Easing.Linear
        }
    })
end

function Camera:push_position(x, y)
    insert(self.stack, {x = x, y = y})
end

function Camera:pop_position()
    remove(self.stack)
end

function Camera:calc_x()
    if #self.stack > 0 then
        return self.x-self.stack[#self.stack].x
    else
        return self.x
    end
end

function Camera:calc_y()
    if #self.stack > 0 then
        return self.y-self.stack[#self.stack].y
    else
        return self.y
    end
end

function Camera:translate(x, y, time, easing)
    -- Default time and interpolation
    time = time or 1
    easing = easing or Easing.Linear

    -- From
    self.interpolation.from.x = self:calc_x()
    self.interpolation.from.y = self:calc_y()
    self.interpolation.from.t = clock()

    -- To
    self.interpolation.to.x = x
    self.interpolation.to.y = y
    self.interpolation.to.t = clock()+time

    -- Using easing
    self.interpolation.easing = easing
end

function Camera:update(dt)
    -- Elapsed time
    local et = clock()-self.interpolation.from.t
    -- Total time
    local t = self.interpolation.to.t-self.interpolation.from.t
    -- Interpolated value (0-1)
    local i = self.interpolation.easing(et/t)

    -- Initial values
    local ix = self.interpolation.from.x
    local iy = self.interpolation.from.y

    -- Interpolation deltas
    local dx = self.interpolation.to.x-ix
    local dy = self.interpolation.to.y-iy

    -- Set interpolated position
    self.x, self.y = ix+dx*i, iy+dy*i
end

function Camera:spr(x, y, sprx, spry, pal)
    sprite(x-self:calc_x(), y-self:calc_y(), sprx, spry, pal)
end

function Camera:pspr(x, y, sx, sy, w, h, pal)
    custom_sprite(x-self:calc_x(), y-self:calc_y(), sx, sy, w, h, pal)
end

function Camera:rectf(x, y, w, h, color)
    rectf(x-self:calc_x(), y-self:calc_y(), w, h, color)
end

function Camera:quadf(x1, y1, x2, y2, x3, y3, x4, y4, color)
    quadf(x1-self:calc_x(), y1-self:calc_y(),
          x2-self:calc_x(), y2-self:calc_y(),
          x3-self:calc_x(), y3-self:calc_y(),
          x4-self:calc_x(), y4-self:calc_y())
end

function Camera:trif(x1, y1, x2, y2, x3, y3, color)
    trif(x1-self:calc_x(), y1-self:calc_y(),
         x2-self:calc_x(), y2-self:calc_y(),
         x3-self:calc_x(), y3-self:calc_y())
end

function Camera:circf(x1, y1, r, color)
    circf(x1-self:calc_x(), y1-self:calc_y(), r, color)
end

function Camera:circ(x1, y1, r, color)
    circ(x1-self:calc_x(), y1-self:calc_y(), r, color)
end

function Camera:line(x1, y1, x2, y2, color)
    line(x1-self:calc_x(), y1-self:calc_y(), x2-self:calc_x(), y2-self:calc_y(), color)
end

function Camera:rect(x, y, w, h, color)
    rect(x-self:calc_x(), y-self:calc_y(), w, h, color)
end

function Camera:quad(x1, y1, x2, y2, x3, y3, x4, y4, color)
    quad(x1-self:calc_x(), y1-self:calc_y(),
         x2-self:calc_x(), y2-self:calc_y(),
         x3-self:calc_x(), y3-self:calc_y(),
         x4-self:calc_x(), y4-self:calc_y())
end

function Camera:tri(x1, y1, x2, y2, x3, y3, color)
    tri(x1-self:calc_x(), y1-self:calc_y(),
        x2-self:calc_x(), y2-self:calc_y(),
        x3-self:calc_x(), y3-self:calc_y())
end

function Camera:print(str, dstx, dsty, pal)
    print(str, dstx-self:calc_x(), dsty-self:calc_y(), pal)
end

return Camera
