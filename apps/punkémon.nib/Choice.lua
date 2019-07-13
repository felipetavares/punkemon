local Choice = {}

function Choice:new(attack, item, target)
    return new(Choice, {
        attack = attack or nil,
        item = item or nil,
        target = target or nil
    })
end

return Choice
