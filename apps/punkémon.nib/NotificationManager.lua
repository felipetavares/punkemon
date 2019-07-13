local NotificationManager = {}

function NotificationManager:new(text)
    local instance = {
        notifications = {}
    }

    lang.instanceof(instance, NotificationManager)
    
    return instance
end

function NotificationManager:draw()
    for i=#self.notifications,1,-1 do
        self.notifications[i]:draw()
    end
end

function NotificationManager:update(dt)
    for i=#self.notifications,1,-1 do
        local n = self.notifications[i]

        if n.finished then
            table.remove(self.notifications, i)
        else
            n:update(dt)
        end
    end
end

function NotificationManager:add(notification)
    table.insert(self.notifications, notification)
end

return NotificationManager
