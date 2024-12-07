---@diagnostic disable: lowercase-global

local lunajson = require "lunajson"

ASTEROID_SIZE = 100
show_debagging = false
destroy_ast = false

function calculateDistance(x1, y1, x2, y2)
    local dist_x = (x2 - x1) ^ 2
    local dist_y = (y2 - y1) ^ 2
    return math.sqrt(dist_x + dist_y)
end

function readJSON(file_name)
    local file = io.open("src/data/" .. file_name .. ".json", "r")
    local data = file:read("*all")
    file:close()

    return lunajson.decode(data)
end