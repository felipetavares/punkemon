local Token = require('NPCSystem/Token')
local Parser = {}

function Parser:new(l)
    local instance = {
        l = l,
        t = nil,

        data = {}
    }

    lang.instanceof(instance, Parser)

    return instance
end

function Parser:next()
    self.t = self.l:next()
end

function Parser:error(token)
    dprint('Expecting ' .. token .. ' but found ' .. self.t.type)
    dprint('@ ', self.l:position_string())

    kablunga()
end

function Parser:parse()
    self:next()

    self:dialogs()

    return self.data
end

function Parser:dialogs()
    while true do
        self:dialog()

        if not self.t.type then
            break
        end
    end
end

function Parser:dialog()
    table.insert(self.data, {
        formatting = {},
        options = {}
    })

    self:header()

    self:content()

    self:footer()
end

function Parser:header_title()
    if self.t.type == '[' then
        self:next()

        if self.t.type == 'id' then
            self.data[#self.data].id = self.t.content

            self:next()

            if self.t.type == '->' then
                self:next()

                if self.t.type == 'id' then
                    self.data[#self.data].nextId = self.t.content

                    self:next()

                    if self.t.type == ']' then
                        self:next()
                    else
                        self:error(']')
                    end
                else
                    self:error('id')
                end
            else
                self:error('->')
            end
        else
            self:error('id')
        end
    else
        self:error('[')
    end
end

function Parser:header()
    if self.t.type == '--' then
        self:next()

        self:header_title()

        if self.t.type == '--' then
            self:next()
        else
            self:error('--')
        end
    else
        self:error('--')
    end
end

function Parser:footer()
    if self.t.type == '--' then
        self:next()
    else
        self:error('--')
    end
end

function Parser:content()
    self:description()

    self:text()

    self:status()

    self:options()
end

function Parser:description()
    if self.t.type == 'id' then
        self.data[#self.data].character = self.t.content

        self:next()

        if self.t.type == '(' then
            self:next()

            if self.t.type == 'id' then
                self.data[#self.data].emotion = self.t.content

                self:next()

                if self.t.type == ')' then
                    self:next()

                    if self.t.type == ':' then
                        self:next()
                    else
                        self:error(':')
                    end
                else
                    self:error(')')
                end
            else
                self:error('id')
            end
        elseif self.t.type == ':' then
            self:next()
        else
            self:error('( or :')
        end
    else
        self:error('( or :')
    end
end

function Parser:text()
    if self.t.type == 'str' then
        self.data[#self.data].text = self.t.content

        self:next()
    else
        self:error('str')
    end
end

function Parser:status_left()
    if self.t.type == '[' then
        self:next()

        if self.t.type == 'id' then
            table.insert(self.data[#self.data].formatting, {
                name = self.t.content,
                values = {}
            })

            self:next()

            if self.t.type == ']' then
                self:next()
            else
                self:error(']')
            end
        else
            self:error('id')
        end
    else
        self:error('[')
    end
end

function Parser:status_right()
    while self.t.type == 'id' do
        local formatting = self.data[#self.data].formatting

        table.insert(formatting[#formatting].values, self.t.content)

        self:next()

        if self.t.type ~= ',' then
            break
        else
            self:next()
        end
    end
end

function Parser:status_line()
    self:status_left()

    if self.t.type == ':' then
        self:next()
    else
        self:error(':')
    end

    self:status_right()
end

function Parser:status()
    while self.t.type == '[' do
        self:status_line()
    end
end

function Parser:options()
    while self.t.type == '(' do
        table.insert(self.data[#self.data].options, {})
        self:option()
    end
end

function Parser:option()
    local options = self.data[#self.data].options

    if self.t.type == '(' then
        self:next()

        if self.t.type == 'id' then
            options[#options].text = self.t.content
            self:next()

            if self.t.type == '->' then
                self:next()

                if self.t.type == 'id' then
                    options[#options].id = self.t.content
                    self:next()

                    if self.t.type == ')' then
                        self:next()
                    else
                        self:error(')')
                    end
                else
                    self:error('id')
                end
            else
                self:error('->')
            end
        else
            self:error('id')
        end
    else
        self:error('(')
    end
end

return Parser
