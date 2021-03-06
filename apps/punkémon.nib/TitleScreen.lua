local Camera = require('Camera')
local Easing = require('Easing')

local current_color = 2
local colors = {2, 4, 5, 6, 7, 8, 9, 10, 11}

local t = 0

local clouds = {}

local mod = {
    done = false 
}

local camera = Camera:new()

for i=1,6 do
    insert(clouds, {
        x = math.random(0, 320),
        y = math.random(0, 120),
        v = -math.random(30, 50),
        w = 100
    })
end

function mod.draw_title_screen ()
    clear(1)

    camera:pspr(0, 0, 640, 0, 320, 240)

    -- Draw movin clouds

    for _, cloud in ipairs(clouds) do
        camera:pspr(cloud.x, cloud.y, 800, 352, 112, 32)
    end

    -- Set current position of the wave
    for _, color in ipairs(colors) do
        if color ~= 0 then
            if color == current_color then
                swap_colors(color, 13)
            else
                swap_colors(color, 0)
            end
        end
    end

    -- Select next position for the wave using a sine pattern
    local color_index = math.floor(math.floor(t*8)%(#colors*1))+1
    --local color_index = math.floor((math.sin(t)+1.05)/2*(#colors))+1

    if color_index <= #colors then
        current_color = colors[color_index]
    end

    -- Draw waves
    camera:pspr(0, 0, 960, 0, 320, 240)

    -- Restore colors
    for i=0,15 do
        swap_colors(i, i)
    end

    -- Draw clouds
    camera:pspr(0, 0, 960, 240, 320, 240)

    -- Draw logos
    camera:pspr(96, math.sin(t*2+2)*8+4+60, 160, 240, 144, 112)
    camera:pspr(110, math.sin(t*2)*8+70, 672, 336, 112, 80)
    camera:pspr(32, math.cos(t*2-1)*8+4, 672, 240, 256, 96)

    local startMessage = 'Press \09 to start'

    if math.floor(t)%2 == 0 then
        swap_colors(11, 1)
        camera:print(startMessage, 160-4*#startMessage, 200)
        swap_colors(11, 11)
    end

    if button_press(RED) then
        mod.done = true
    end
end

function mod.update_title_screen(dt)
    t += dt

    for _, cloud in ipairs(clouds) do
        cloud.x += cloud.v*dt

        if cloud.x < -cloud.w then
            cloud.x = 320
        end
    end

    camera:update()
end

return mod
