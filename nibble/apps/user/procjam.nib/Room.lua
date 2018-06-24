require('AStar')

local Decoration = require('Decoration')
local Room = {}

local tile_w, tile_h = 16, 16
local tilemap_w, tilemap_h = 20, 14 

local room_w, room_h = 16, 16
local dungeon_w, dungeon_h = 10, 30

local tileset_w = 5
local tileset_x, tileset_y = 5, 0

function Room:new(tilemap, doormap, doors, w, h)
    local instance = {
        w = w or 0,
        h = h or 0,
        tilemap = tilemap,
        doormap = doormap,
        doors = doors,
        decorations = {},
        characters = {},
        paths = {}
    }

    lang.instanceof(instance, Room)

    instance:generateDecorations()

    return instance
end

function Room:generateDecorations()
    local decorations = {
        {x=5, y=13},
        {x=6, y=13},
        {x=7, y=13},
        {x=8, y=13},
        {x=5, y=14},
        {x=6, y=14},
        {x=7, y=14},
    }

    local tiles = self.tilemap:tilemapWithTiles()

    for i=1,#self.doors do
        for j=i,#self.doors do
            local doorA = self.doors[i]
            local doorB = self.doors[j]

            if doorA ~= doorB then
                local path = aStar(tiles[doorA.y*self.w+doorA.x+1], tiles[doorB.y*self.w+doorB.x+1], tiles, self.w, self.h)
                table.insert(self.paths, path)

                for i, pathStep in ipairs(path) do
                    self.tilemap:setPath(pathStep.x, pathStep.y, true)
                end
            end
        end
    end

    for x=0,self.w-1 do
        for y=0,self.h-1 do
            local decoration = decorations[math.random(1, #decorations)]

            --if self.doormap:get(x, y).kind ~= 01 and
            --   self.doormap:get(x, y+1).kind ~= 01 and
            --   self.tilemap:get(x, y).kind == 07 and
            --   self.tilemap:get(x, y+1).kind == 07 and
            --   self:minimumDecorationDistance(x*16, y*16) > math.random(32^2, 64^2) and
            --   math.random() > 0.8 and self:decorationFits(x, y, decoration.w/16+1, decoration.h/16+1) then
            --    table.insert(self.decorations, Decoration:new(x*16, y*16, decoration))
            --end
            --
            if self:minimumDecorationDistance(x*16, y*16) > math.random(16^2, 24^2) and
               self:decorationFits(x, y, 1, 1) and
               math.random() > 0.9 then
                table.insert(self.decorations, Decoration:new(x*16, y*16, decoration))
            end
        end
    end
end

function Room:decorationFits(x, y, w, h)
    if (self.tilemap:get(x, y).kind == 07 or 
        self.tilemap:get(x, y).kind == 06) and 
       not self.tilemap:get(x, y).path and
       self.doormap:get(x, y).kind ~= 01 then
        return true
    else
        return false
    end
end

function Room:minimumDecorationDistance(x, y)
    local distance = 9999

    for _, decor in ipairs(self.decorations) do
        local dx, dy = x-decor.x, y-decor.y
        local currentDistance = dx^2+dy^2

        if currentDistance < distance then
            distance = currentDistance
        end
    end

    return distance
end

function Room:draw()
    -- Draws tilemap
	local x, y = 0,0
	for _, tile in ipairs(self.tilemap:tilemap()) do
        local tile_x = tile%tileset_w+tileset_x
        local tile_y = tile/tileset_w+tileset_y
		
        spr(x, y, tile_x, tile_y)

        x += tile_w

		if x >= tilemap_w*tile_w then
            x = 0
            y += tile_h
		end
    end

    -- Draws decorations
    for _, decor in ipairs(self.decorations) do
        decor:draw()
    end
end

return Room
