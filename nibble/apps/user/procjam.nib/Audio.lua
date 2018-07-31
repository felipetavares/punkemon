local CH0 = 154448+4*0
local CH1 = 154448+4*1
local CH2 = 154448+4*2
local CH3 = 154448+4*3
local CH4 = 154448+4*4
local CH5 = 154448+4*5
local CH6 = 154448+4*6

local SQR = 0
local TRI = 1
local SAW = 2
local SIN = 3

local t = 0
local i = 0

local bass_scale = {
    {3, 0},
    {3, 2},
    {3, 1},
    {3, 5},
    {3, 7},
    {3, 8},
    {3, 9},
    {3, 11}
}

local voice_scale = {
    {3, 0},
    {3, 2},
    {3, 1},
    {3, 5},
    {3, 7},
    {3, 8},
    {3, 9},
    {3, 11}
}

local p1 = {
    1, 0, 2, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 2, 0, 1, 0, 2, 0, 0, 0, 2, 0, 1, 0, 0, 0, 0, 0, 2, 0
}

local p2 = {
    1, 0, 0, 0, 2, 0, 0, 0, 4, 0, 0, 0, 3, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 2, 0, 3, 0, 0, 0, 2, 0
}

local p3 = {
    3, 3, 0, 0, 5, 5, 0, 0, 2, 2, 4, 4, 3, 3, 0, 0, 2, 2, 0, 0, 5, 5, 0, 0, 6, 6, 0, 0
}

function audio_tick(channel)
--    if channel == 1 then
--        -- Percussion
--        if p1[t%#p1+1] == 1 then
--            audio(CH1, TRI, 128, 2, 0)
--        elseif p1[t%#p1+1] == 2 then
--            audio(CH1, TRI, 128, 2, 0)
--        else
--            audio(CH1, TRI, 0, 3, 0)
--        end
--
--        -- Bass
--        if p2[t%#p2+1] ~= 0 then
--            local n = p2[t%#p2+1]
--            audio(CH0, SIN, 255, bass_scale[n][1], bass_scale[n][2])
--        else
--            audio(CH0, SIN, 0, 0, 0)
--        end
--
--        -- Voice 
--        if p3[t%#p3+1] ~= 0 then
--            local n = p3[t%#p3+1]
--            audio(CH2, SIN, 128, voice_scale[n][1], voice_scale[n][2])
--        else
--            audio(CH1, SIN, 0, 0, 0)
--        end
--
--
--        if i%8 == 0 then
--            t += 1
--        end
--
--        i += 1
--    end
end

function audio(ch, w, v, o, n)
    kernel.write(ch, makeaudio(w, v, o, n))
end

function makeaudio(w, v, o, n)
    return string.char(w)..string.char(v)..string.char(o)..string.char(n)
end

