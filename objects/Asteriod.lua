---@diagnostic disable: lowercase-global
local love = require "love"

function Asteroid(x, y, ast_size, level, debagging)
    debagging = debagging or false

    local ASTEROID_VERT = 12
    local ASTEROID_JAG = 0.33
    local ASTEROID_SPEED = math.random(50) + (level * 2)

    local ast_size = 100
    local offset = {}
    local vert = math.floor(math.random(ASTEROID_VERT + 1) + ASTEROID_VERT / 2)
    for i = 1, vert + 1, 1 do
        table.insert(offset, math.random() * ASTEROID_JAG * 2 + 1 - ASTEROID_JAG)
    end

    local vel = -1
    if math.random() < 0.5 then 
        vel = 1
    end
    return {
        x = x,
        y = y,
        x_vel = math.random() * ASTEROID_SPEED * vel,
        y_vel = math.random() * ASTEROID_SPEED * vel,
        radius = math.ceil(ast_size / 2),
        angle = math.rad(math.random(math.pi)),
        vert = vert,
        offset = offset,

        draw = function (self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            love.graphics.setColor(0.6, 0.6, 0.6, opacity)
            local points = {
                self.x + self.radius * self.offset[1] * math.cos(self.angle),
                self.y + self.radius * self.offset[1] * math.sin(self.angle)
            }

            for i = 1, self.vert - 1 do
                table.insert(points, self.x + self.radius * self.offset[i] * math.cos(self.angle + i * math.pi * 2 / self.vert))
                table.insert(points, self.y + self.radius * self.offset[i] * math.sin(self.angle + i * math.pi * 2 / self.vert))
            end

            love.graphics.polygon(
                "line",
                points
            )

            if debagging then
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end

        end,

        move = function (self, dt)
            self.x = self.x + self.x_vel * dt
            self.y = self.y + self.y_vel * dt

            if self.x + self.radius < 0 then
                self.x = love.graphics.getWidth() + self.radius
            elseif self.x - self.radius > love.graphics.getWidth() then
                self.x = -self.radius
            end

            if self.y + self.radius < 0 then
                self.y = love.graphics.getHeight() + self.radius
            elseif self.y - self.radius > love.graphics.getHeight() then
                self.y = -self.radius
            end

        end
    }
end

return Asteroid