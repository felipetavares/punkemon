local Delayed = {}

local list = {}

function Delayed.exec(t, fn)
    table.insert(list, {
        t = t+clock(),
        fn = fn
    })
end

function Delayed.update()
    for i=#list,1,-1 do
        if list[i].t <= clock() then
            list[i].fn()
            table.remove(list, i)
        end
    end
end

return Delayed
