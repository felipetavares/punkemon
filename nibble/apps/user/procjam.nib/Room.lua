require('AStar')

local Effects = require('Effects')

local EnemyTank = require('EnemyTank')
local EnemyBiped = require('EnemyBiped')

local Decoration = require('Decoration')
local ItemDescription = require('ItemDescription')
local Item = require('Item')

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

function Room:new(tilemap, doormap, doors, w, h, x, y, dungeon, stage)
    local instance = {
        x = x or 0,
        y = y or 0,
        w = w or 0,
        h = h or 0,
        tilemap = tilemap,
        doormap = doormap,
        doors = doors,
        decorations = {},
        characters = {},
        items = {},
        paths = {},
        dungeon = dungeon or nil,
        stage = stage or 1,
        explosionEffect = Effects.Explosion:new()
    }

    lang.instanceof(instance, Room)

    instance:generateDecorations()
    instance:generateCharacters()

    return instance
end

function Room:generateCharacters()
    for i, path in ipairs(self.paths) do
        if i ~= #self.paths then
            --if math.random() < 0.5 then
            table.insert(self.characters, EnemyBiped:new(path, self.stage))
            --else
            --    table.insert(self.characters, EnemyTank:new(path, self.stage))
            --end
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

    for i, door in pairs(self.doors) do
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

        break
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

function Room:destroyDecoration(x, y)
    for i, decor in ipairs(self.decorations) do
        if decor.x == x*16 and decor.y == y*16 then
            table.remove(self.decorations, i)
            return
        end
    end
end

function Room:hasItem(x, y)
    for _, item in ipairs(self.items) do
        if item.x == x*16 and item.y == y*16 then
            return true
        end
    end

    return false
end

function Room:getItem(x, y)
    for i, item in ipairs(self.items) do
        if item.x == x*16 and item.y == y*16 then
            return table.remove(self.items, i)
        end
    end

    return nil
end

function Room:getCharacter(x, y)
    for _, char in ipairs(self.characters) do
        if char.x == x and char.y == y then
            return char
        end
    end

    return nil
end

function Room:draw(camera)
    camera:push_position(self.x, self.y)

    -- Draws tilemap
	local x, y = 0,0
	for _, tile in ipairs(self.tilemap:tilemap()) do
        local tile_x = tile%tileset_w+tileset_x
        local tile_y = tile/tileset_w+tileset_y
		
        camera:spr(x, y, tile_x, tile_y)

        x += tile_w

		if x >= tilemap_w*tile_w then
            x = 0
            y += tile_h
		end
    end

    -- Draws items 
    for _, item in ipairs(self.items) do
        item:draw(camera)
    end

    -- Draws decorations
    for _, decor in ipairs(self.decorations) do
        decor:draw(camera)
    end

    -- Draws characters
    for _, char in ipairs(self.characters) do
        char:draw(camera)
    end

    player:draw(self, camera)

    camera:pop_position()
end

function Room:step()
    for _, char in ipairs(self.characters) do
        char:step()
    end

    player:step(self)
end

function Room:update(dt)
    for i=#self.characters,1,-1 do
        if self.characters[i].battleStats.HP <= 0 then
            local char = self.characters[i]
            local x, y = char.x*16+8, char.y*16+8

            Delayed.exec(0.3, function() 
                self.explosionEffect:start(x, y)
            end)
            
            self:spawnRandomItems(char.x, char.y, 4)

            table.remove(self.characters, i)
        end
    end

    player:update(self, dt)
end

function Room:spawnRandomItems(x, y, range, number)
    number = number or 8

    for i=1,number do
        local ix, iy = x+math.floor((math.random()-0.5)*range), y+math.floor((math.random()-0.5)*range)

        if not self:hasDecoration(ix, iy) and self.tilemap:get(ix, iy).kind == 07 then
            local item = Item:new(ItemDescription.Oyster)
            item.x, item.y = ix*16, iy*16

            table.insert(self.items, item)

            Delayed.exec(math.random()*0.2, function()
                item.appear:start(ix*16+8, iy*16+8)
            end)
        end
    end
end

function Room:useDecoration(x, y)
    self:destroyDecoration(x, y)
    self:spawnRandomItems(x, y, 4)
end

return Room
