local Types = require("Attack")

local attackDesc = {}

attackDesc.Attacks = {
    ['Tackle'] = {
		name = 'Tackle',
		power = 10,
		accuracy = 1,
		element = Types.TECH,
		pp = 3,
		target = nil,
		effect = function() end
    },
	
	['Sand'] = {
		name = 'Sand',
		power = 10,
		accuracy = 1,
		element = Types.TECH,
		pp = 5,
		target = nil,
		effect = function() end
    },
	
	['Harden'] = {
		name = 'Tackle',
		power = 10,
		accuracy = 1,
		element = Types.TECH,
		pp = 3
		target = nil,
		effect = function() end
    },
	
	['Tackle'] = {
		name = 'Tackle',
		power = 10,
		accuracy = 1,
		element = Types.TECH,
		pp = 3
		target = nil,
		effect = function() end
    },
}
	
return attackDesc
