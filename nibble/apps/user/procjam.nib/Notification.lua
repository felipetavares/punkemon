local IV = require('InterpolatedVector')
local Easing = require('Easing')

local Notification = {}

function Notification:new(text, time)
    local instance = {
        text = text or '',
        width = #text*8+16,
        height = 16,
        time = time or 1,
        position = IV:new()
    }

    lang.instanceof(instance, Notification)

    instance.position.x, instance.position.y = 320, 0
    instance.position:set(160-instance.width/2, 0, 0.1, Easing.InOutCubic)
    
    Delayed.exec(instance.time, function()
        instance.position:set(-instance.width, 0, 0.1, Easing.InOutCubic)

        Delayed.exec(0.4, function()
            instance.finished = true
        end)
    end)

    return instance
end

function Notification:draw()
    rectf(self.position.x, self.position.y+self.height, self.width, 2, 1)
    rectf(self.position.x, self.position.y, self.width, self.height, 13)
    rect(self.position.x+1, self.position.y, self.width, self.height, 1)

    col(14, 1)
    col(7, 0)
    print(self.text, self.position.x+8, self.position.y+4)
    col(14, 14)
    col(7, 7)
end

function Notification:update()
    self.position:update()
end

return Notification
