local CH0 = 154448+4*0
local CH1 = 154448+4*1
local CH2 = 154448+4*2
local CH3 = 154448+4*3
local CH4 = 154448+4*4
local CH5 = 154448+4*5
local CH6 = 154448+4*6

local SQR = 0
local TRI = 1
local SIN = 2
local PSIN = 3

function audio_tick(channel)
end

function audio(ch, w, v, o, n)
    kernel.write(ch, makeaudio(w, v, o, n))
end

function makeaudio(w, v, o, n)
    return string.char(w)..string.char(v)..string.char(o)..string.char(n)
end

