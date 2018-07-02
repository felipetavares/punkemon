local Choice = {}

function Choice:new(attack, item)
    local instance = {
		attack = attack or nil,
		item = item or nil,
    }

    lang.instanceof(instance, Choice)

    return instance
end

return Choice
