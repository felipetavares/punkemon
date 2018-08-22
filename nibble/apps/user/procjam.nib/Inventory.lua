local Item = require('Item')
local Inventory = {}

--EQ_SWORD = 0
--EQ_SHIELD = 1
--IT_POTION = 2
--IT_SUPER_POTION = 3 -- HP
--IT_HYPER_POTION = 4
--IT_MAX_POTION = 5
--IT_FULL_RESTORE = 6 -- Status
--IT_ETHER = 7
--IT_MAX_ETHER = 8
--
---- Equipment --
--EQ_SWORD = {Item:new(), 
--    quantity = 0},
--EQ_SHIELD = {Item:new(), 
--    quantity = 0},
--
---- HP Potions --
--IT_POTION = {Item:new(IT_POTION, 20), 
--    quantity = 0},
--
--IT_SUPER_POTION = {Item:new(IT_SUPER_POTION, 50), 
--    quantity = 0},
--    
--IT_HYPER_POTION = {Item:new(IT_HYPER_POTION_POTION, 120), 
--    quantity = 0},
--    
--IT_MAX_POTION = {Item:new(IT_MAX_POTION_POTION, 500), 
--    quantity = 0},
--    
--    
---- Status Potions
--IT_FULL_RESTORE = {Item:new(IT_FULL_RESTORE), 
--    quantity = 0},
--
---- PP Potions		
--IT_ETHER = {Item:new(IT_ETHER, 0, 10), 
--    quantity = 0},
--
--IT_MAX_ETHER = {Item:new(IT_MAX_ETHER, 0, 20), 
--    quantity = 0},
--    
--},

function Inventory:new(name)
    local instance = {
        name = name or '',
		items = {},
        sliceStart = 1,
        sliceSize = 8,
        cursor = 1,
    }

    lang.instanceof(instance, Inventory)

    return instance
end

function Inventory:addItem(item)
    table.insert(self.items, item)
end

function Inventory:removeItem(item)
    for k, v in ipairs(self.items) do
        if v == item then
            table.remove(self.items, k)

            return item
        end
    end

    return nil
end

function Inventory:getItem()
    return self.items[self.cursor]
end

function Inventory:popItem()
    local prevCursor = self.cursor

    self:moveCursor(-1)

    return table.remove(self.items, prevCursor)
end

function Inventory:getSlice()
    local slice = {}

    for i=self.sliceStart,self.sliceStart+self.sliceSize do
        if self.items[i] then
            table.insert(slice, self.items[i])
        end
    end

    return slice
end

function Inventory:moveCursor(delta)
    local sliceStart = self.sliceStart
    local sliceEnd = self.sliceStart+self.sliceSize

    local newCursor = self.cursor+delta

    if self.items[newCursor] then
        if newCursor < sliceStart then
            self:moveSlice(-1)
        elseif newCursor > sliceEnd then
            self:moveSlice(1)
        end

        self.cursor = newCursor
    end
end

function Inventory:moveSlice(delta)
    if self:checkSlice(delta) then
        self.sliceStart += delta
        return true
    end

    return false
end

function Inventory:checkSlice(delta)
    if delta < 0 then
        if self.items[self.sliceStart+delta] then
            return true
        else
            return false
        end
    else
        if self.items[self.sliceStart+self.sliceSize+delta] then
            return true
        else
            return false
        end
    end
end

return Inventory
