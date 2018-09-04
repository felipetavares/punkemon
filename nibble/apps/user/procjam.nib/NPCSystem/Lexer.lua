local Token = require('NPCSystem/Token')
local Lexer = {}

function Lexer:new(path)
    local instance = {
        path = path,
        file = io.open(path, 'r'),
        tokens = {},
        position = 0,
        backlog = '',
        line = 1, column = 1
    }

    lang.instanceof(instance, Lexer)

    return instance
end

function Lexer:position_string()
    return 'Line: ' .. self.line .. ', ' .. 'Column: ' .. self.column
end

function Lexer:lex()
    local buffer = ''
    local state = 0
    local c

    while true do
        if #self.backlog > 0 then
            c = self.backlog:sub(#self.backlog)
            self.backlog = self.backlog:sub(1, #self.backlog-1)
        else
            c = self.file:read(1)

            if c == '\n' then
                self.line += 1
                self.column = 1
            else
                self.column += 1
            end
        end


        if not c then
            return nil
        end

        if state == 0 then
            if c == '-' then
                state = 1
            elseif c == '[' then
                return '['
            elseif c == ']' then
                return ']'
            elseif c == '(' then
                return '('
            elseif c == ')' then
                return ')'
            elseif c == ':' then
                return ':'
            elseif c == ',' then
                return ','
            elseif c == '\n' then
                state = 3
            elseif c == ' ' then
                state = 0
            else
                state = 2
            end
        elseif state == 1 then
            if c == '-' then
                state = 1
            elseif c == '>' then
                return '->'
            else
                self.backlog = self.backlog .. c
                return '--'
            end
        elseif state == 2 then
            if c:match('%W') and c ~= ' ' and c ~= '\n' then
                self.backlog = self.backlog .. c
                return 'id', buffer:match("^%s*(.-)%s*$")
            end
        elseif state == 3 then
            if c == '\n' then
                state = 4
            else
                state = 0
            end
        elseif state == 4 then
            if c == '\n' then
                state = 5
            end
        elseif state == 5 then
            if c == '\n' then
                return 'str', buffer
            else
                state = 4
            end
        end

        buffer = buffer .. c
    end
end

function Lexer:next()
    local token = Token:new(self:lex())

    table.insert(self.tokens, token)
    self.position += 1

    return token
end

function Lexer:close()
    self.file:close()
end

function Lexer:lookAround(n)
    if n == 0 then
        if #self.tokens > 0 then
            return self.tokens[self.position]
        else
            return nil
        end
    else
        if n > 0 then
            for i=1,n do
                if not self:next() then
                    return nil
                end
            end

            return self:lookAround(0)
        else
            if self.position+n > 0 then
                return self.tokens[self.position+n]
            else
                return nil
            end
        end
    end
end

return Lexer
