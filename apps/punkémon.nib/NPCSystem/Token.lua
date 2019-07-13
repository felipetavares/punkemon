local Token = {}

function Token:new(type, content)
    return new (Token, {
        type = type,
        content = content
    })
end

return Token
