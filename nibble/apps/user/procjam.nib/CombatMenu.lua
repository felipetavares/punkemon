local IV = require('InterpolatedVector')
local Easing = require('Easing')

local CombatMenu = {}

local Modes = {
    ATTACKS=0,
    ITEMS=1
}

local MENU_OPEN_STATS = {x = 140, y = 160 , t = 0.3}
local MENU_CLOSED_STATS = {x = 320, y = 160, t = 0.3}

function CombatMenu:new(attacks, items)
    local instance = {
        attacks = attacks or nil,
        attacks = attacks or nil,
        items = items or nil,

        selected = 1,
        
        selectedAttack = nil,
        selectedItem = nil,
		
		base  = IV:new(),

        mode = Modes.ATTACKS
    }
	
	
    lang.instanceof(instance, CombatMenu)

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
    end
end

function CombatMenu:drawAttacks(x)
    local basex = -x+(320-MENU_OPEN_STATS.x)+16
    local basey = 160
    local ampx = 54
    local ampy = 48

    for i, _ in ipairs(self.attacks) do
        col(9+i-1, (i == self.selected) and 12 or 2)
    end

    pspr(basex, basey, 576, 336, 64, 64)
    col(9, 9)
    col(10, 10)
    col(11, 11)
    col(12, 12)

    local names = {}

    for i=1,4 do
        if self.attacks[i] then
            local name = self.attacks[i].name .. '/' .. tostring(self.attacks[i].pp)

            table.insert(names, name)
        else
            table.insert(names, '')
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

        if i == self.selected then
            col(14, 13)
        else
            col(14, 12)
            col(7, 9)
        end

        print(names[i], x, y)

        col(14, 14)
        col(7, 7)
    end
end

function CombatMenu:update(dt)
    if btp(WHITE) then
        self.mode = Modes.ATTACKS 
		self.base:set(MENU_OPEN_STATS.x, MENU_OPEN_STATS.y, MENU_OPEN_STATS.t, Easing.InOutCubic)
    elseif btp(BLACK) then
        self.mode = Modes.ITEMS
		self.base:set(MENU_OPEN_STATS.x, MENU_OPEN_STATS.y, MENU_OPEN_STATS.t, Easing.InOutCubic)
    end

    if self.base.x == MENU_OPEN_STATS.x then
        if btp(DOWN) then
            if self.selected == 3 then
                self.selectedAttack = self.attacks[self.selected]
                self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
            else
                self.selected = 3
            end
        elseif btp(UP) then
            if self.selected == 1 then
                self.selectedAttack = self.attacks[self.selected]
                self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
            else
                self.selected = 1
            end
        elseif btp(LEFT) then
            if self.selected == 4 then
                self.selectedAttack = self.attacks[self.selected]
                self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
            else
                self.selected = 4
            end
        elseif btp(RIGHT) then
            if self.selected == 2 then
                self.selectedAttack = self.attacks[self.selected]
                self.base:set(MENU_CLOSED_STATS.x, MENU_CLOSED_STATS.y, MENU_CLOSED_STATS.t, Easing.InOutCubic)
            else
                self.selected = 2
            end
        end
    end
	
	self.base:update(dt)
end

function CombatMenu:drawBase(x)
    pspr(-x, 152, 320, 400, 320, 80)
end

function CombatMenu:drawButtons(x, attackb, itemsb)
    local bth = 16

    if attackb then
        pspr(320-x, 160+bth, 320, 384, 16, 16)
    else
        pspr(320-x, 160+bth, 336, 384, 16, 16)
    end

    if itemsb then
        pspr(320-x, 162+bth*2, 352, 384, 16, 16)
    else
        pspr(320-x, 162+bth*2, 368, 384, 16, 16)
    end
end

return CombatMenu
