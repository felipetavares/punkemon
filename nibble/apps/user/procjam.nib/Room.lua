local TilemapBuilder = require('TilemapBuilder')
local Tile = require('Tile')

-- All functions here operate on an instance
-- of TilemapBuilder

local T_SHADOW = 6
local T_FLOOR = 7

-- Non-Terminals
local N_WALL = 1000

function g_room(builder)
    local max_iterations = 1

    while not builder:all_terminals() and max_iterations > 0 do
        -- Operate in the entire builder that was passed to us
        builder:use(0, 0, 0.5, 1)

        -- Rule 1
        if builder:all(1000) then
            builder:fill(T_FLOOR)
            builder:borders(N_WALL)
            builder:line(1, 1, 19, 1, T_SHADOW)

            builder:line(5, 0, 5, 10, N_WALL)
            builder:set(5, 10, T_SHADOW)
            builder:line(5, 11, 5, 15, N_WALL)
        end

        -- Rule 2
        builder:each(3, 2, function (block)
            if block:is({N_WALL, N_WALL, N_WALL,
                         -N_WALL, -N_WALL, N_WALL}) then
                block:into({01, 01, 04,
                            -1, -1, -1})
            end

            if block:is({N_WALL, N_WALL, N_WALL,
                         N_WALL, -N_WALL, -N_WALL}) then
                block:into({00, 01, 01,
                            -1, -1, -1})
            end

            if block:is({N_WALL, -N_WALL, -N_WALL,
                             N_WALL, N_WALL, N_WALL}) then
                block:into({05, -1, -1,
                            10, 11, 11})
            end

            if block:is({-N_WALL, -N_WALL, N_WALL,
                             N_WALL, N_WALL, N_WALL}) then
                block:into({-1, -1, 09,
                            11, 11, 10})
            end

            if block:is({N_WALL, N_WALL, N_WALL,
                             -N_WALL, -N_WALL, -N_WALL}) then
                block:into({03, 02, 03,
                            -1, -1, -1})
            end

            if block:is({N_WALL, -N_WALL, -N_WALL,
                             N_WALL, -N_WALL, -N_WALL}) then
                block:into({05, -1, -1,
                            05, -1, -1})
            end

            if block:is({-N_WALL, -N_WALL, N_WALL,
                             -N_WALL, -N_WALL, N_WALL}) then
                block:into({-1, -1, 09,
                            -1, -1, 09})
            end

            if block:is({-N_WALL, -N_WALL, -N_WALL,
                          N_WALL, N_WALL, N_WALL}) then
                block:into({-1, -1, -1,
                            11, 11, 11})
            end
        end)

        builder:each(3, 2, function(block)
            if block:is({-N_WALL, N_WALL, -N_WALL,
                         -N_WALL, N_WALL, -N_WALL}) then
                block:into({-1, 24, -1,
                            -1, 24, -1})
            end
        end)

        -- Rule 4
        builder:each(2, 2, function(block)
            if block:is({-N_WALL, -N_WALL,
                         -N_WALL, N_WALL}) then
                block:into({-1, -1,
                            -1, 19})
            end

            if block:is({-N_WALL, N_WALL,
                         -N_WALL, -N_WALL}) then
                block:into({-1, 29,
                            -1, -1})
            end
        end)

        builder:apply()

        -- Operate in the previous context
        builder:restore()

        max_iterations -= 1
    end

    return builder
end
