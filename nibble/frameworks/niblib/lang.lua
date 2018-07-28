local lang = {}

function lang.instanceof(a, b)
    setmetatable(a, {__index=b})
end

function lang.copy(orig) -- font:  http://lua-users.org/wiki/CopyTable
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[lang.copy(orig_key)] = lang.copy(orig_value)
        end
        setmetatable(copy, lang.copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

return lang
