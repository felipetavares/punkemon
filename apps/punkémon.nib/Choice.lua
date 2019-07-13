local Choice = {}

function Choice:new(attack, item, target)
    local instance = {
		attack = attack or nil,
		item = item or nil,
        target = target or nil
    }

    lang.instanceof(instance, Choice)

    return instance
end

return Choice
