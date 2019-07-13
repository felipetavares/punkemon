local NotificationManager = {}

function NotificationManager:new(text)
    return new(NotificationManager, {
        notifications = {}
    })
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
            remove(self.notifications, i)
        else
            n:update(dt)
        end
    end
end

function NotificationManager:add(notification)
    insert(self.notifications, notification)
end

return NotificationManager
