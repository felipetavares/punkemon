-- Camera System
-- Exposes the same drawing API
-- as niblib but allows for transformations

local Easing = require('Easing')

local InterpolatedVector = {}

function InterpolatedVector:new()
    local instance = {
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
    }

    lang.instanceof(instance, InterpolatedVector)

    return instance
end

function InterpolatedVector:set(x, y, time, easing)
    -- Default time and interpolation
    time = time or 1
    easing = easing or Easing.Linear

    -- From
    self.interpolation.from.x = self.x
    self.interpolation.from.y = self.y
    self.interpolation.from.t = clock()

    -- To
    self.interpolation.to.x = x
    self.interpolation.to.y = y
    self.interpolation.to.t = clock()+time

    -- Using easing
    self.interpolation.easing = easing
end

function InterpolatedVector:update(dt)
    -- Elapsed time
    local et = clock() - self.interpolation.from.t
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

return InterpolatedVector
