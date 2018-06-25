local Attack = require('Attack')
local Character = {}

function Character:new()
    local instance = {
        x = 0,
        y = 0,
        path = {},
        position = 1,
		level = 1,
		
		baseStats = {
			attack = 0,
			defense = 0,
			speed = 0,
			element = NEUTRAL,
			HP = 1
		},
		
		battleStats = {
			attack = 1,
			defense = 1,
			speed = 1,
			HP = 1,
			status  = 0,
		},
		
		moveset = {
		}
    }

    lang.instanceof(instance, Character)

    return instance
end

function Character:init(path)
    local init = {x = 0, y = 0}
    
    if path and path[self.position] then
        init = path[self.position]
    end

    self.x = init.x
    self.y = init.y
    self.path = path or {}
end

function Character:findDirection()
    if self.path then
        if self.path[self.position+1] then
            local nextPosition = self.path[self.position+1]

            local dx, dy = nextPosition.x-self.x, nextPosition.y-self.y

            if dx == 0 then
                if dy > 0 then
                    return 2
                else
                    return 1
                end
            else
                if dx > 0 then
                    return 4
                else
                    return 3
                end
            end
        end
    end

    return 0
end

return Character
