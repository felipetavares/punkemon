local Node = require('Node')
local Graph = {}

function Graph:new()
    local instance = {
        nodes = {},
        idCounter = 0
    }

    lang.instanceof(instance, Graph)

    return instance
end

function Graph:addNode(node)
    local buf = self.idCounter

    node.id = buf
    self.nodes[buf] = node

    self.idCounter = buf+1

    return buf
end

function Graph:addEdge(idA, idB)
    self.nodes[idA]:addNeighbour(self.nodes[idB])
    self.nodes[idB]:addNeighbour(self.nodes[idA])
end

function Graph:addDirectionalEdge(idA, idB)
    self.nodes[idA]:addNeighbour(self.nodes[idB])
end

function Graph:removeNode(id)
    local node = self.nodes[id]

    for _, neighbour in pairs(node.neighbours) do
        neighbour:removeNeighbour(id)
    end

    self.nodes[id] = nil
end

function Graph:removeEdge(idA, idB)
    self.nodes[idA]:removeNeighbour(idB)
    self.nodes[idB]:removeNeighbour(idA)
end

function Graph:removeDirectionlEdge(idA, idB)
    self.nodes[idA]:removeNeighbour(idB)
end

function Graph:print()
    for _, node in pairs(self.nodes) do
        node:print()
    end
end

return Graph
