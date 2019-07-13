-- NibUI->Text
-- Cria um objeto de texto que pode ter
-- váris características, como:
-- - Posição 
-- - Cor do FG
-- - Cor do BG
-- - Paleta
-- - Bold
-- - Underline

local Text = {}

function Text:new(text, x, y)
    local instance = {
        text = text or "",
        x = x or 0, y = y or 0,
        palette = 0,
        bold = 0,
        underline = false,
        align = 0,
        colormap = {
            [0] = 0,
            [6] = 6,
            [7] = 7,
        }
    }

    instanceof(instance, self)

    return instance
end

function Text:copy()
    local instance = {
        text = self.text,
        x = self.x, y = self.y,
        palette = self.palette,
        colormap = copy(self.colormap),
        background_color = self.background_color,
        bold = self.bold,
        underline = self.underline,
        align = self.align
    }

    instanceof(instance, Text)

    return instance
end

function Text:set(key, value)
    self[key] = value or true

    return self
end

-- Returns a substring with the same
-- decorations
function Text:sub(i, j)
    local instance = {
        text = self.text:sub(i, j),
        x = self.x, y = self.y,
        palette = self.palette,
        colormap = copy(self.colormap),
        background_color = self.background_color,
        bold = self.bold,
        underline = self.underline,
        align = self.align
    }

    instanceof(instance, Text)

    return instance
end

function Text:draw()
    local off_x = 0

    if self.align == 1 then
        off_x = -(#self.text*8)/2
    elseif self.align == 2 then
        off_x = -#self.text*8
    end

    for from, to in pairs(self.colormap) do
        swap_colors(from, to)
    end

    -- Configura bold/não bold
    --swap_colors(7, self.bold)

    local txt_size = measure(self.text)

    -- Desenha
    fill_rect(self.x+off_x, self.y-1, txt_size, 10, self.background_color)
    print(self.text, self.x+off_x, self.y, self.palette)

    -- Desenha underline
    if self.underline then
        local depth = 1

        if self.bold ~= 0 then
            depth = 2
        end

        fill_rect(self.x+off_x-1, self.y+9-1, txt_size+2, depth+2, 1)
        fill_rect(self.x+off_x, self.y+9, txt_size, depth, self.colormap[7])
    end

    for from, to in pairs(self.colormap) do
        swap_colors(from, form)
    end
end

return Text
