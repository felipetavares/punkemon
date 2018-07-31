local current_color = 2
local colors = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12}

local t = 0

local clouds = {}

local mod = {
    done = false 
}

for i=1,6 do
    table.insert(clouds, {
        x = math.random(0, 320),
        y = math.random(0, 120),
        v = -math.random(30, 50),
        w = math.random(50, 100)
    })
end

function mod.draw_title_screen ()
    pspr(0, 0, 640, 0, 320, 240)

    -- Draw movin clouds

    for _, cloud in ipairs(clouds) do
        pspr(cloud.x, cloud.y, 800, 352, 112, 32)
    end

    -- Set current position of the wave
    for _, color in ipairs(colors) do
        if color ~= 0 then
            if color == current_color then
                col(color, 11)
            else
                col(color, 7)
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
    pspr(0, 0, 960, 0, 320, 240)

    -- Restore colors
    for i=0,15 do
        col(i, i)
    end

    -- Draw clouds
    pspr(0, 0, 960, 240, 320, 240)

    -- Draw logos
    pspr(86, math.sin(t*2+2)*8+4+60, 160, 240, 144, 112)
    pspr(100, math.sin(t*2)*8+70, 672, 336, 112, 80)
    pspr(32, math.cos(t*2-1)*8+4, 672, 240, 256, 96)

    local startMessage = 'Press \09 to start'
    
    if math.floor(t)%2 == 0 then
        col(7, 1)
        print(startMessage, 160-4*#startMessage, 200)
        col(7, 7)
    end

    if btp(RED) then
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
end

return mod
