local Tile = require('Tile')
local TilemapBuilder = {}

function TilemapBuilder:new(w, h)
    local instance = {
        stack = {},
        tiles = {},
        results = {},
        w = w or 20,
        h = h or 15
    }

    table.insert(instance.stack, {0, 0, instance.w, instance.h})

    for y=0,instance.h-1 do
        for x=0,instance.w-1 do
            instance.tiles[y*instance.w+x+1] = Tile:new(x, y, 1000)
        end
    end

    lang.instanceof(instance, self)

    return instance
end

function TilemapBuilder:copy()
    local copy = TilemapBuilder:new(self.w, self.h)

    for i, bounds in ipairs(self.stack) do
        copy.stack[i] = {bounds[1], bounds[2], bounds[3], bounds[4]}
    end

    for i, tile in ipairs(self.tiles) do
        copy.tiles[i] = Tile:new(self.tiles[i].x, self.tiles[i].y, self.tiles[i].kind)
    end
    
    return copy 
end

function TilemapBuilder:bounds()
    local bounds = self.stack[#self.stack];

    return {
        x = bounds[1],
        y = bounds[2],
        w = bounds[3],
        h = bounds[4]
    }
end

function TilemapBuilder:use(x, y, w, h)
    local bounds = self:bounds()

    table.insert(self.stack, {
        bounds.x+math.floor(bounds.w*x),
        bounds.y+math.floor(bounds.h*y),
        math.floor(bounds.w*w),
        math.floor(bounds.h*h)
    })
end

function TilemapBuilder:use_exact(x, y, w, h)
    table.insert(self.stack, {
        x, y, w, h
    })
end

function TilemapBuilder:restore()
    if #self.stack > 0 then
        table.remove(self.stack, #self.stack)
    end
end

function TilemapBuilder:all(kind)
    local bounds = self:bounds()

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            if self:get(x, y).kind ~= kind then
                return false
            end
        end
    end

    return true
end

function TilemapBuilder:all_terminals()
    local bounds = self:bounds()

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            if self:get(x, y).kind >= 1000 then
                return false
            end
        end
    end

    return true
end

function TilemapBuilder:apply()
    local bounds = self:bounds()

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            for _, result in ipairs(self.results) do
                local kind = result:get(x, y).kind

                if kind < 1000 then
                    self:set(x, y, kind)
                end
            end
        end
    end

    self.results = {}
end

function TilemapBuilder:each(w, h, fn)
    local bounds = self:bounds()

    for y=bounds.y,bounds.y+bounds.h-h do
        for x=bounds.x,bounds.x+bounds.w-w do
            local copy = self:copy()
            copy:use_exact(x, y, w, h)

            fn(copy)

            table.insert(self.results, copy)
        end
    end
end

function TilemapBuilder:is(pattern)
    local bounds = self:bounds()
    local i=1

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            if pattern[i] < 0 then
                if -pattern[i] == self:get(x, y).kind then
                    return false
                end
            else
                if pattern[i] ~= self:get(x, y).kind then
                    return false
                end
            end
            
            i += 1
        end
    end

    return true
end

function TilemapBuilder:into(pattern)
    local bounds = self:bounds()
    local i=1

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            if pattern[i] >= 0 then
                self:set(x, y, pattern[i])
            end
            
            i += 1
        end
    end

end

function TilemapBuilder:borders(kind)
    local bounds = self:bounds()

    self:line(bounds.x, bounds.y,
              bounds.x+bounds.w, bounds.y,
              kind)
    self:line(bounds.x, bounds.y,
              bounds.x, bounds.y+bounds.h,
              kind)
    self:line(bounds.x+bounds.w-1, bounds.y,
              bounds.x+bounds.w-1, bounds.y+bounds.h,
              kind)
    self:line(bounds.x, bounds.y+bounds.h-1,
              bounds.x+bounds.w, bounds.y+bounds.h-1,
              kind)
end

function TilemapBuilder:line(x1, y1, x2, y2, kind)
    if x1 == x2 and y1 == y2 then
        self:set(x1, y1, kind)
        return
    end

    local dx = x2-x1
    local dy = y2-y1
    local dst = math.sqrt(dx^2+dy^2)

    dx = dx/dst
    dy = dy/dst

    for i=1,math.floor(dst) do
        self:set(math.floor(x1), math.floor(y1), kind)

        x1 += dx
        y1 += dy
    end
end

function TilemapBuilder:set(x, y, kind)
    local p = y*self.w+x+1

    if p >= 1 and p <= #self.tiles then
        self.tiles[p].kind = kind
    end
end

function TilemapBuilder:get(x, y)
    local p = y*self.w+x+1

    if p >= 1 and p <= #self.tiles then
        return self.tiles[p]
    else
        return nil
    end

end

function TilemapBuilder:fill(kind)
    local bounds = self:bounds()

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            self:set(x, y, kind)
        end
    end
end

function TilemapBuilder:tilemap()
    local bounds = self:bounds()
    local tilemap = {}

    for y=bounds.y,bounds.y+bounds.h-1 do
        for x=bounds.x,bounds.x+bounds.w-1 do
            table.insert(tilemap, self:get(x, y).kind)
        end
    end

    return tilemap, bounds.w, bounds.h
end

return TilemapBuilder
