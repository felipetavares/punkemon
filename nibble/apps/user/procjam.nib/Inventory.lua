local Item = require('Item')
local Inventory = {}

EQ_SWORD = 0
EQ_SHIELD = 1
IT_POTION = 2
IT_SUPER_POTION = 3 -- HP
IT_HYPER_POTION = 4
IT_MAX_POTION = 5
IT_FULL_RESTORE = 6 -- Status
IT_ETHER = 7
IT_MAX_ETHER = 8


function Inventory:new()
    local instance = {
		name = '',
		
		items = {
		-- Equipment --
		EQ_SWORD = {Item:new(), 
					quantity = 0},
		EQ_SHIELD = {Item:new(), 
					quantity = 0},
		
		-- HP Potions --
		IT_POTION = {Item:new(IT_POTION, 20), 
					quantity = 0},
		
		IT_SUPER_POTION = {Item:new(IT_SUPER_POTION, 50), 
					quantity = 0},
					
		IT_HYPER_POTION = {Item:new(IT_HYPER_POTION_POTION, 120), 
					quantity = 0},
					
		IT_MAX_POTION = {Item:new(IT_MAX_POTION_POTION, 500), 
					quantity = 0},
					
					
		-- Status Potions
		IT_FULL_RESTORE = {Item:new(IT_FULL_RESTORE), 
					quantity = 0},
		
		-- PP Potions		
		IT_ETHER = {Item:new(IT_ETHER, 0, 10), 
					quantity = 0},
		
		IT_MAX_ETHER = {Item:new(IT_MAX_ETHER, 0, 20), 
					quantity = 0},
					
			},
		}

    lang.instanceof(instance, Inventory)

    return instance
end

function Inventory:addItem(item, quantity)
	self.items[item] += quantity
end

function Inventory:removeItem(item, quantity)
	self.items[item] -= quantity
end

return Inventory