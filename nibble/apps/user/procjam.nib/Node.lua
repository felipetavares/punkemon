local Node = {}

function Node:new()
    local instance = {
        id = -1,
        neighbours = {},
    }

    lang.instanceof(instance, Node)

    return instance
end

function Node:addNeighbour(neighbour)
    self.neighbours[neighbour.id] = neighbour
end

function Node:removeNeighbour(id)
    self.neighbours[id] = nil
end

function Node:print()
    dprint('Node: ' .. tostring(self.id))

    for k, neighbour in pairs(self.neighbours) do
        dprint('Neighbour: ' .. tostring(neighbour.id))
    end

    dprint('')
end

return Node
