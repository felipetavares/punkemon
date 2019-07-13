local Decoration = {}

function Decoration:new(x, y, spr)
    return new(Decoration, {
        x = x or 0,
        y = y or 0,
        spr = spr or {x = 0, y = 0, w = 16, h = 16}
    })
end

function Decoration:draw(camera)
    camera:spr(self.x, self.y, self.spr.x, self.spr.y)
end

return Decoration
