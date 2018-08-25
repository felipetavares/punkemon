
function ConditionText:new()
    local instance = {
		condition = nil -- Recieves an function that verify if the condition is satisfied
		trueCondition = nil -- Recieves the next text conversation if the condition is true
		falseCondition = nil --Recieves the next text conversation if the condition is false 
    }
    lang.instanceof(instance, Character)

    return instance
end


return ConditionText
