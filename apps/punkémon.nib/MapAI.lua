--
-- Map AI
--

local Actions = require('AIActions')

local AI = {}

local Angles = {
  Up = math.pi*3/2,     --         math.pi*3/2
  Down = math.pi/2,     --            |
  Right = 0,            -- math.pi <-   -> 0
  Left = math.pi        --            |
                        --         math.pi/2
}                      

function AI:new()
  local instance = {
    -- We only run sensors for
    -- tiles in this mask
    sensorShape = {
      0, 0, 0, 0, 0, 
      0, 0, 1, 1, 0, 
      0, 1, 1, 1, 1, 
      0, 0, 1, 1, 0, 
      0, 0, 0, 0, 0, 
    },
    direction = Angles.Up
  }

  --lang.instanceof(instance, AI)
  setmetatable(instance, {__index=AI})

  return instance
end

function AI:rotateMatrix(input, a)
  local output = {}

  -- Find the center (assuming it's a square)
  local l = math.sqrt(#self.sensorShape)
  local c = l/2

  -- For every element
  for x=0.5,l do
    for y=0.5,l do
      -- Translate center to origin
      local srcx, srcy = x-c, y-c
      -- Find where to put it
      local dstx, dsty = srcx*math.cos(a)-srcy*math.sin(a), srcy*math.cos(a)+srcx*math.sin(a)
      -- Translate origin to center
      dstx, dsty = dstx+c, dsty+c
      -- Put the data there
      output[math.floor(dsty)*l+math.floor(dstx)+1] = input[math.floor(y)*l+math.floor(x)+1]
    end
  end

  return output
end

-- Creates a observation of the world
-- Takes:
--  The current world map
-- Returns:
--  A limited observation of the given map
function AI:observe(tilemap)
  local observation = {
    interests = {}
  }

  -- Current rotation is always 0 because
  -- it's the one we stored 
  local deltaRotation = 0-self.direction
  local sensorShape = self:rotateMatrix(self.sensorShape, deltaRotation)

  -- Assuming it's a square
  local sensorSize = math.sqrt(#sensorShape)
  -- Find the center
  local c = sensorSize/2

  for x=1,sensorSize do
    for y=1,sensorSize do
      local p = (y-1)*sensorSize+x

        if sensorShape[p] ~= 0 then
          local tx, ty = px-(x-math.floor(c)), py-(y-math.floor(c))
          -- TODO: get the tile
          if self:isInteresting(tile) then
            table.insert(observation.interests, tile)
          end
        end
    end
  end

  return observation
end

-- Choses the next action
-- Takes:
--  The current AI state as `self`
--  The current world observation
-- Returns:
--  The next action to be taken
function AI:action(observation)
  -- TODO
  return Actions.None
end

-- Gets a representation of the world
-- Returns:
--  A representation of the world
function AI:world()
  -- TODO
  return nil
end

-- Executes an action
-- Takes:
--  An action
function AI:execute(action)
  -- TODO
end

function AI:step()
  self:execute(self:action(self:observe(self:world())))
end

-- TEST
local ai = AI:new()
local rotated = ai:rotateMatrix(ai.sensorShape, math.pi/2)

for y=1,5 do
  for x=1,5 do
    local v = rotated[(y-1)*5+x]

    if not v then
      v = 0
    end

    io.write(tostring(v) .. ', ')
  end
  print()
end

return AI
