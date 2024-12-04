---@diagnostic disable: lowercase-global
local love = require "love"

function Player(debagging)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90)

    debagging = debagging or false

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_ANGLE,
        rotation = 0,
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 3
        },

        draw = function (self)
            local opacity = 1

            if debagging then
                love.graphics.setColor(1, 0, 0)

                love.graphics.rectangle("fill", self.x - 2, self.y - 2,  4, 4)

                love.graphics.circle("line", self.x, self.y, self.radius)
            end

            love.graphics.setColor(1, 1, 1, opacity)
            love.graphics.polygon(
                "line",
                self.x + ((4/3) * self.radius) * math.cos(self.angle),
                self.y - ((4/3) * self.radius) * math.sin(self.angle),
                self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
                self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
                self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
                self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
            )
        end,

        movePlayer = function (self)
            local FPS = love.timer.getFPS()
            local friction = 0.7
            self.rotation = (360 / 180) * math.pi / FPS

            if love.keyboard.isDown("a") then
                self.angle = self.angle + self.rotation
            end

            if love.keyboard.isDown("d") then
                self.angle = self.angle - self.rotation
            end

            if self.thrusting then
                self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / FPS
                self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / FPS
            else
                if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                    self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                    self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                end
            end

            self.x = self.x + self.thrust.x
            self.y = self.y + self.thrust.y
        end
    }
end

return Player