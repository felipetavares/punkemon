require('GrammarLang')

local TilemapBuilder = require('TilemapBuilder')
local Tile = require('Tile')

-- All functions here operate on an instance
-- of TilemapBuilder

-- Non-Terminals
local NO = 2000
local WL = 1000 local FL = 1001 -- Door size
local DOOR_SIZE = 2

function g_hsplit(builder, doormap, p, fn)
    builder:use(0, 0, p, 1)
    fn(builder, doormap)
    builder:restore()

    builder:use(p, 0, 1-p, 1)
    fn(builder, doormap)
    builder:restore()
end

function g_vsplit(builder, doormap, p, fn)
    builder:use(0, 0, 1, p)
    fn(builder, doormap)
    builder:restore()

    builder:use(0, p, 1, 1-p)
    fn(builder, doormap)
    builder:restore()
end

function g_room(builder, doormap, top_door, bottom_door, left_door, right_door)
    builder:use(0, 0, 1, 1)

    local doorList
    local bounds = builder:bounds()

    if bounds.w >= 12 and bounds.h >= 12 then
        local split_position = math.floor(math.random()*3)/4+1/4;

        if math.random() > 0.5 then
            g_hsplit(builder, doormap, split_position, g_room)
        else
            g_vsplit(builder, doormap, split_position, g_room)
        end
    else
        builder:topleft_half_borders(WL)

        if bounds.y > 0 then
            local top_door = math.random(bounds.x+1, bounds.x+bounds.w-2)

            for i=0,DOOR_SIZE-1 do
                builder:set(top_door+i, bounds.y, FL)
                doormap:set(top_door+i, bounds.y, 1)
            end
        end

        if bounds.x > 0 then
            local left_door = math.random(bounds.y+1, bounds.y+bounds.h-2)

            for i=0,DOOR_SIZE-1 do
                builder:set(bounds.x, left_door+i, FL)
                doormap:set(bounds.x, left_door+i, 1)
            end
        end
    end

    if bounds.w == 20 and bounds.h == 15 then
        builder:bottomright_half_borders(WL)

        doorList = g_external_doors(builder, doormap, top_door, bottom_door, left_door, right_door)

        g_apply_grammar(builder)
    end

    builder:restore()

    return builder, doormap, bounds.w, bounds.h, doorList
end

function g_external_doors(builder, doormap, top_door, bottom_door, left_door, right_door)
    local doorList = {}
    local bounds = builder:bounds()

    if top_door then
        local top_door = math.random(bounds.x+1, bounds.x+bounds.w-DOOR_SIZE-1)

        doorList[D_TOP] = {x = top_door, y = bounds.y, dx = -1, dy = 1}

        for i=0,DOOR_SIZE-1 do
            builder:set(top_door+i, bounds.y, FL)
            doormap:set(top_door+i, bounds.y, 1)
        end
    end

    if bottom_door then
        local bottom_door = math.random(bounds.x+1, bounds.x+bounds.w-DOOR_SIZE-1)

        doorList[D_BOTTOM] = {x = bottom_door, y = bounds.y+bounds.h-1}

        for i=0,DOOR_SIZE-1 do
            builder:set(bottom_door+i, bounds.y+bounds.h-1, FL)
            doormap:set(bottom_door+i, bounds.y+bounds.h-1, 1)
        end
    end

    if left_door then
        local left_door = math.random(bounds.y+1, bounds.y+bounds.h-DOOR_SIZE-1)

        doorList[D_LEFT] = {x = bounds.x, y = left_door}

        for i=0,DOOR_SIZE-1 do
            builder:set(bounds.x, left_door+i, FL)
            doormap:set(bounds.x, left_door+i, 1)
        end
    end

    if right_door then
        local right_door = math.random(bounds.y+1, bounds.y+bounds.h-DOOR_SIZE-1)

        doorList[D_RIGHT] = {x = bounds.x+bounds.w-1, y = right_door}

        for i=0,DOOR_SIZE-1 do
            builder:set(bounds.x+bounds.w-1, right_door+i, FL)
            doormap:set(bounds.x+bounds.w-1, right_door+i, 1)
        end
    end

    return doorList
end

function g_apply_grammar(builder)
    local max_iterations = 1

    while max_iterations > 0 do
        -- Operate in the entire builder that was passed to us
        builder:use(0, 0, 1, 1)

        builder:each(3, 3, function(block)
            if block:is({-1, NO, -1,
                         FL, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 57, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, FL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 58, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 19, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 24, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, FL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 29, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, NO,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 57, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 54, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, WL,
                         -1, FL, WL}) then
                block:into({-1, -1, -1,
                            -1, 03, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 02, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, NO,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 04, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         NO, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 00, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 46, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, NO,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 09, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         FL, WL, NO,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 09, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         NO, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 05, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         NO, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 05, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 48, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, FL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 49, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 47, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 59, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, NO,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 02, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         NO, WL, FL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 58, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         NO, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 50, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, NO,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 51, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         NO, WL, FL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 50, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         NO, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 00, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 45, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, NO,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 04, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, WL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 11, -1,
                            -1, -1, -1})
            end
            
            if block:is({-1, WL, -1,
                         WL, WL, NO,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 14, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         NO, WL, WL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 10, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, FL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 50, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, WL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 51, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         NO, WL, WL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 11, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 53, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 02, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         NO, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 02, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, NO,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 09, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, WL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 09, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, NO,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 11, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         NO, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 56, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, NO,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 02, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 52, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         WL, WL, FL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 45, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, WL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 12, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         NO, WL, FL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 05, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         FL, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 57, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, FL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 58, -1,
                            -1, -1, -1})
            end

            if block:is({-1, NO, -1,
                         FL, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 46, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, FL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 55, -1,
                            -1, -1, -1})
            end
            
            if block:is({-1, NO, -1,
                         NO, WL, WL,
                         -1, FL, -1}) then
                block:into({-1, -1, -1,
                            -1, 02, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         NO, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 56, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         FL, WL, NO,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 51, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         WL, WL, NO,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 60, -1,
                            -1, -1, -1})
            end

            if block:is({-1, FL, -1,
                         NO, WL, WL,
                         -1, WL, -1}) then
                block:into({-1, -1, -1,
                            -1, 56, -1,
                            -1, -1, -1})
            end

            if block:is({-1, WL, -1,
                         WL, WL, FL,
                         -1, NO, -1}) then
                block:into({-1, -1, -1,
                            -1, 05, -1,
                            -1, -1, -1})
            end
        end)

        builder:each(1, 1, function (block)
            if block:is({FL}) then
                block:into({7})
            end
        end)

        builder:each(1, 2, function (block)
            if block:is({WL, FL}) then
                block:into({-1, 6})
            end
        end)

        builder:apply()
        -- Operate in the previous context
        builder:restore()

        max_iterations -= 1
    end
end
