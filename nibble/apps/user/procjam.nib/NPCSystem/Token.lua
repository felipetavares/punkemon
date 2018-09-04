local Token = {}

function Token:new(type, content)
    local instance = {
        type = type,
        content = content
    }

    lang.instanceof(instance, Token)

    return instance
end

return Token
