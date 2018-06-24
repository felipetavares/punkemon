require('AStar')

local EnemyTank = require('EnemyTank')
local EnemyBiped = require('EnemyBiped')

local Decoration = require('Decoration')
local Room = {}

local tile_w, tile_h = 16, 16
local tilemap_w, tilemap_h = 20, 14 

local room_w, room_h = 16, 16
local dungeon_w, dungeon_h = 10, 30

local tileset_w = 5
local tileset_x, tileset_y = 5, 0

local function cantor(x, y)
    return 1/2*(x+y)*(x+y+1)+y
end

function Room:new(tilemap, doormap, doors, w, h, dungeon)
    local instance = {
        w = w or 0,
        h = h or 0,
        tilemap = tilemap,
        doormap = doormap,
        doors = doors,
        decorations = {},
        characters = {},
        paths = {},
        dungeon = dungeon or nil
    }

    lang.instanceof(instance, Room)

    instance:generateDecorations()
    instance:generateCharacters()

    return instance
end

function Room:generateCharacters()
    for i, path in ipairs(self.paths) do
        if i ~= #self.paths then
            if math.random() < 0.5 then
                table.insert(self.characters, EnemyBiped:new(path))
            else
                table.insert(self.characters, EnemyTank:new(path))
            end
        end
    end
end

function Room:generateDecorations()
    local decorations = {
        {x=5, y=13},
        {x=6, y=13},
        {x=7, y=13},
        {x=8, y=13},
        {x=9, y=13},
        {x=5, y=14},
        {x=6, y=14},
        {x=7, y=14},
        {x=8, y=14},
        {x=9, y=14},
    }

    local tiles = self.tilemap:tilemapWithTiles()
    local visited = {}

    for i, doorA in pairs(self.doors) do
        for j, doorB in pairs(self.doors) do
            if doorA ~= doorB then
                if not visited[i+j] then
                    visited[i+j] = true

                    local path = aStar(tiles[doorA.y*self.w+doorA.x+1], tiles[doorB.y*self.w+doorB.x+1], tiles, self.w, self.h)
                    table.insert(self.paths, path)

                    for i, pathStep in ipairs(path) do
                        self.tilemap:setPath(pathStep.x, pathStep.y, true)
                    end
                end
            end
        end
    end

    if #self.doors > 0 then
        local door = self.doors[1]
        local floorTile = 0

        for _, tile in ipairs(tiles) do
            if tile.kind == 07 then
                floorTile = tile
                break
            end
        end

        local path = aStar(floorTile, tiles[door.y*self.w+door.x+1], tiles, self.w, self.h)
        table.insert(self.paths, path)

        for _, pathStep in ipairs(path) do
            self.tilemap:setPath(pathStep.x, pathStep.y, true)
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

function Room:hasDecoration(x, y)
    for _, decor in ipairs(self.decorations) do
        if decor.x == x*16 and decor.y == y*16 then
            return true
        end
    end

    return false
end

function Room:getCharacter(x, y)
    for _, char in ipairs(self.characters) do
        if char.x == x and char.y == y then
            return char
        end
    end

    return nil
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

    -- Draws characters
    for _, char in ipairs(self.characters) do
        char:draw()
    end

    player:draw(self)
end

function Room:step()
    for _, char in ipairs(self.characters) do
        char:step()
    end

    player:step(self)
end

function Room:update(dt)
    player:update(self, dt)
end

return Room
