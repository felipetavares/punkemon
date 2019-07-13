local function extract_rules(file)
    for line in io.lines(file) do
        dprint(line)
    end
end

local function execute(rule)
end

function grammar_dofile(file)
    local rules = extract_rules(file)

    for _, rule in ipairs(rules) do
        execute(rule)
    end
end
