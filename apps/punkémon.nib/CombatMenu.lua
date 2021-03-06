local IV = require('InterpolatedVector')
local Easing = require('Easing')
local Attack = require('Attack')

local CombatMenu = {}

local Modes = {
    ATTACKS=0,
    ITEMS=1
}

local MENU_OPEN_STATS = {x = 140, y = 160 , t = 0.3}
local MENU_CLOSED_STATS = {x = 320, y = 160, t = 0.3}

function CombatMenu:new(attacks, inventories)
    local instance = new(CombatMenu, {
        attacks = attacks or nil,
        inventories = inventories or nil,

        selectedAttackIndex = 1,
        selectedInventoryIndex = 1,
        selectedItemIndex = 1,

        selectedAttack = nil,
        selectedItem = nil,

        base  = IV:new(),
        mode = Modes.ATTACKS
    })

    instance:open()

    return instance
end

function CombatMenu:open()
    self.base.x = MENU_CLOSED_STATS.x
    self.base.y = MENU_CLOSED_STATS.y
    self.base:set(MENU_OPEN_STATS.x, MENU_OPEN_STATS.y, MENU_OPEN_STATS.t, Easing.InOutCubic)
end

function CombatMenu:draw()
    if self.mode == Modes.ATTACKS then
        self:drawBase(self.base.x)
        self:drawButtons(self.base.x, true, false)
        self:drawAttacks(self.base.x)
    elseif self.mode == Modes.ITEMS then
        self:drawBase(self.base.x)
        self:drawButtons(self.base.x, false, true)
        self:drawItems(self.base.x)
    end
end

function CombatMenu:drawItems(x)
    local basex = -x
    local basey = 140

    -- Draw inventories
    for i, inventory in ipairs(self.inventories) do
        print(tostring(i), basex+320-12, basey+(i+1)*8)

        if i == self.selectedInventoryIndex then
            rect(basex+320-12, basey+(i+1)*8, 8, 8, 13)
        end
    end

    -- Draw items in inventory
    local inventory = self.inventories[self.selectedInventoryIndex]

    if inventory then
        local sel = inventory:getItem()
        local items = inventory:getSlice()

        if #items == 0 then
            print('Empty!', basex+MENU_OPEN_STATS.x + 16, basey+16)
        end

        for i, item in ipairs(items) do
            local x = basex+MENU_OPEN_STATS.x + 16
            local y = basey+(i+1)*8

            if item == sel then
                print('\9', x-12, y)

                swap_colors(0, 4)
                print(item.name, x, y)
                swap_colors(0, 0)

                local blockSize = 8
                for j=0,math.floor(#item.description/blockSize),1 do
                    local endp = j*blockSize+blockSize

                    if not item.description:sub(endp-1, endp):match(' ') and not (endp >= #item.description) then
                        print(item.description:sub(j*blockSize, j*blockSize+blockSize-1)..'-', x+68, basey+8*(j+2))
                    else
                        print(item.description:sub(j*blockSize, j*blockSize+blockSize-1), x+68, basey+8*(j+2))
                    end
                end
            else
                print(item.name, x, y)
            end
        end

        local x = basex+MENU_OPEN_STATS.x+76

        line(x, basey+16, x, 240-12, 10)
    end
end

function CombatMenu:moveAllowed()
    if not self.lastMovedTime then
        self.lastMovedTime = clock()
        self.minTime = 0.1
        return true
    end

    if clock()-self.lastMovedTime > self.minTime then
        if clock()-self.lastMovedTime > math.max(self.minTime*2, 0.05) then
            self.minTime = 0.1
        else
            self.minTime = self.minTime/2
        end
        self.lastMovedTime = clock()
        return true
    else
        return false
    end
end

function CombatMenu:drawAttacks(x)
    local basex = -x+(320-MENU_OPEN_STATS.x)+16
    local basey = 160
    local ampx = 54
    local ampy = 48

    for i, _ in ipairs(self.attacks) do
        swap_colors(9+i-1, (i == self.selectedAttackIndex) and 10 or 2)
    end

    custom_sprite(basex, basey, 576, 336, 64, 64)
    swap_colors(9, 9)
    swap_colors(10, 10)
    swap_colors(11, 11)
    swap_colors(12, 12)

    local names = {}

    for i=1,4 do
        if self.attacks[i] then
            local name = self.attacks[i].name

            insert(names, name)
        else
            insert(names, '')
        end
    end

    local offsets = {
        {x=-#names[4]*4, y=-4},
        {x=0, y=-2},
        {x=-#names[4]*4, y=4},
        {x=-#names[4]*8+8, y=-2},
    }

    for i, attack in ipairs(self.attacks) do
        local x = basex+ampx/2+math.cos(i/4*math.pi*2-math.pi)*ampx/2
        local y = basey+ampy/2+math.sin(i/4*math.pi*2-math.pi)*ampy/2+4

        x += offsets[i].x
        y += offsets[i].y

        if attack:loaded() then
            if not (i == self.selectedAttackIndex) then
                swap_colors(15, 10)
                swap_colors(11, 8)
            end
        else
            swap_colors(15, 7)
            swap_colors(11, 6)
        end

        print(attack.name, x, y-4)

        print(tostring(attack.pp), x+16, y+4)

        if not attack:loaded() then
            line(x, y+1, x+#names[i]*8, y+1, 7)
        end

        swap_colors(15, 15)
        swap_colors(11, 11)

        if i == self.selectedAttackIndex then
            swap_colors(1, 15)
        end

        local spr = Attack.ElementSprites[attack.element]
        custom_sprite(x, y+4, spr.x, spr.y, spr.w, spr.h)

        swap_colors(1, 1)
    end
end

function CombatMenu:update(dt)
    if button_press(WHITE) then
        self.mode = Modes.ATTACKS
        self.base:set(MENU_OPEN_STATS.x, MENU_OPEN_STATS.y, MENU_OPEN_STATS.t, Easing.InOutCubic)
    elseif button_press(BLACK) then
        self.mode = Modes.ITEMS
        self.base:set(MENU_OPEN_STATS.x, MENU_OPEN_STATS.y, MENU_OPEN_STATS.t, Easing.InOutCubic)
    end

    if self.base.x == MENU_OPEN_STATS.x and self.mode == Modes.ATTACKS then
        local buttons = {UP, RIGHT, DOWN, LEFT}

        for i, button in ipairs(buttons) do
            if button_press(button) then
                if self.attacks[i] and self.attacks[i]:loaded() then
                    if self.selectedAttackIndex == i then
                        self.selectedAttack = self.attacks[self.selectedAttackIndex]
                        self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
                    else
                        self.selectedAttackIndex = i
                    end
                end
            end
        end

        if button_press(BLUE) then
            self.selectedAttack = true
            self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
        end
    end

    if self.base.x == MENU_OPEN_STATS.x and self.mode == Modes.ITEMS then
        local inventory = self.inventories[self.selectedInventoryIndex]

        if inventory then
            if button_down(DOWN) and self:moveAllowed() then
                inventory:moveCursor(1)
            elseif button_down(UP) and self:moveAllowed() then
                inventory:moveCursor(-1)
            end

            if button_press(RED) then
                self.selectedItem = inventory:popItem()
                self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
            end
        end
    end

    self.base:update(dt)
end

function CombatMenu:drawBase(x)
    custom_sprite(-x, 152, 320, 400, 320, 80)

    print('\8', 240, 4+math.sin(clock()*8)*2)
    print('Escape!', 248+8, 4)
end

function CombatMenu:drawButtons(x, attackb, itemsb)
    local bth = 16

    if attackb then
        custom_sprite(320-x, 160+bth, 320, 384, 16, 16)
    else
        custom_sprite(320-x, 160+bth, 336, 384, 16, 16)
    end

    if itemsb then
        custom_sprite(320-x, 162+bth*2, 352, 384, 16, 16)
    else
        custom_sprite(320-x, 162+bth*2, 368, 384, 16, 16)
    end
end

return CombatMenu
