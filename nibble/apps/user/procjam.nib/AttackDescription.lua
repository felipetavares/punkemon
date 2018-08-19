local Types = require("Attack")

local attackDesc = {}

attackDesc.Attacks = {
    ['Tackle'] = {
		name = 'Tackle',
		power = 10,
		accuracy = 1,
		element = Attack.TECH,
		pp = 3,
		target = nil,
		effect = function() end
    },
	
	['Sand'] = {
		name = 'Sand',
		power = 10,
		accuracy = 1,
		element = Attack.TECH,
		pp = 5,
		target = nil,
		effect = function() end
    },
	
	['Harden'] = {
		name = 'Tackle',
		power = 10,
		accuracy = 1,
		element = Attack.TECH,
		pp = 3
		target = nil,
		effect = function() end
    },
	
	['Tackle'] = {
		name = 'Tackle',
		power = 10,
		accuracy = 1,
		element = Attack.TECH,
		pp = 3
		target = nil,
		effect = function() end
    },
}
	
return attackDesc
	
local tackle = Attack:new('Slash', 10, 1, Attack.TECH, 3, nil, function () end)
local sand = Attack:new('Bubbles', 10, 1, Attack.TECH, 5, nil, function () end)
local harden = Attack:new('Harden', 10, 1, Attack.TECH, 5, nil, function () end)
local growl = Attack:new('Diva', 10, 1, Attack.TECH, 5, nil, function () end)