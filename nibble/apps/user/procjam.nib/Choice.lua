local Choice = {}

function Choice:new()
    local instance = {
		attack = nil,
		item = nil,
    }

    lang.instanceof(instance, Choice)

    return instance
end

return Choice