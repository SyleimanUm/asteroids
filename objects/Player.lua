---@diagnostic disable: lowercase-global
require "globals"
local love = require "love"
local Laser = require "objects/Laser"

function Player(num_lives, sfx)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90)
    local LASER_DISTANCE = 0.6
    local MAX_LASERS = 10
    local EXPLOAD_DUR = 3
    local USABLE_BLINKS = 10 * 2

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_ANGLE,
        rotation = 0,
        expload_time = 0,
        exploading = false,
        invincible = true,
        invincible_seen= true,
        time_blinked = USABLE_BLINKS,
        lasers = {},
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 3,
            big_flame = false,
            flame = 2.0
        },

        lives = num_lives or 3, 

        drawFlameThrust = function (self, fillType, color)

            if self.invinvible_seen then
                table.insert(color, 0.5)
            end
            love.graphics.setColor(color)

            love.graphics.polygon(
                fillType,
                -- the 4 / 3 and 2 / 3 is to find the center of the triangle correctly
                self.x - self.radius * (2 / 3 * math.cos(self.angle) + 0.5 * math.sin(self.angle)),
                self.y + self.radius * (2 / 3 * math.sin(self.angle) - 0.5 * math.cos(self.angle)),
                self.x - self.radius * self.thrust.flame * math.cos(self.angle),
                self.y + self.radius * self.thrust.flame * math.sin(self.angle),
                self.x - self.radius * (2 / 3 * math.cos(self.angle) - 0.5 * math.sin(self.angle)),
                self.y + self.radius * (2 / 3 * math.sin(self.angle) + 0.5 * math.cos(self.angle))
            )
        end,

        shootLaser = function (self)
            
            if #self.lasers < MAX_LASERS then
                table.insert(self.lasers, Laser(self.x, self.y, self.angle))
            sfx:playFX("laser")
            end
        end,

        destroyLaser = function (self, index)
            table.remove(self.lasers, index)
        end,

        draw = function (self, faded)
            local opacity = 1

            if faded then
                opacity = 0.5
            end

            if not self.exploading then
                if self.thrusting then
        
                if not self.thrust.big_flame then
                    self.thrust.flame = self.thrust.flame - 1 / love.timer.getFPS()

                    if self.thrust.flame < 1.5 then
                        self.thrust.big_flame = true
                    end

                else
                    self.thrust.flame = self.thrust.flame + 1 / love.timer.getFPS()

                    if self.thrust.flame > 2.5 then
                        self.thrust.big_flame = false
                    end
                end

                self:drawFlameThrust("fill", {255 / 255, 102 / 255, 25 / 255})
                self:drawFlameThrust("line", {1, 0.5, 0})
                end

                if show_debagging then
                    love.graphics.setColor(1, 0, 0)
    
                    love.graphics.rectangle("fill", self.x - 2, self.y - 2,  4, 4)
    
                    love.graphics.circle("line", self.x, self.y, self.radius)
                end
                if self.invincible_seen then
                    love.graphics.setColor(1, 1, 1, faded and opacity or 0.5)
                else
                    love.graphics.setColor(1, 1, 1, opacity)
                end
                love.graphics.polygon(
                    "line",
                    self.x + ((4/3) * self.radius) * math.cos(self.angle),
                    self.y - ((4/3) * self.radius) * math.sin(self.angle),
                    self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
                    self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
                    self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
                    self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
                )
    
                for _, laser in pairs(self.lasers) do
                    laser:draw(faded)
                end
            else
                love.graphics.setColor(1, 0.0, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1.5)

                love.graphics.setColor(1, 0.5, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 1)

                love.graphics.setColor(1, 0.75, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, self.radius * 0.5)
            end
        end,

        drawLives = function (self, faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end
            
            if self.lives == 2 then
                love.graphics.setColor(1, 1, 0.5, opacity)            
            elseif self.lives == 1   then
                love.graphics.setColor(1, 0.2, 0.2, opacity)            
            else
                love.graphics.setColor(1, 1, 1, opacity)
            end

            local x_pos, y_pos = 45, 30

            for i = 1, self.lives do

                if self.exploading then
                    if i == self.lives then
                        love.graphics.setColor(1, 0, 0, opacity)
                    end
                end

             love.graphics.polygon(
                    "line",
                    (i * x_pos) + ((4/3) * self.radius) * math.cos(VIEW_ANGLE),
                    y_pos - ((4/3) * self.radius) * math.sin(VIEW_ANGLE),
                    (i * x_pos) - self.radius * (2 / 3 * math.cos(VIEW_ANGLE) + math.sin(VIEW_ANGLE)),
                    y_pos + self.radius * (2 / 3 * math.sin(VIEW_ANGLE) - math.cos(VIEW_ANGLE)),
                    (i * x_pos) - self.radius * (2 / 3 * math.cos(VIEW_ANGLE) - math.sin(VIEW_ANGLE)),
                    y_pos + self.radius * (2 / 3 * math.sin(VIEW_ANGLE) + math.cos(VIEW_ANGLE))
                )
            end
    
            -- love.graphics.setColor(1, 1, 1, opacity)

        end,



        movePlayer = function (self, dt)
            if self.invincible then
                self.time_blinked = self.time_blinked - dt * 2

                if math.ceil(self.time_blinked) % 2 == 0 then
                    self.invincible_seen = false
                else
                    self.invincible_seen = true
                end

                if self.time_blinked <= 0 then
                    self.invincible = false
                end

            else
                self.time_blinked = USABLE_BLINKS
                self.invincible_seen = false
            end
                self.exploading = self.expload_time > 0

            if not self.exploading then
                local FPS = love.timer.getFPS()
                local friction = 0.7
                self.rotation = (360 / 270) * math.pi / FPS

                if love.keyboard.isDown("a") then
                    self.angle = self.angle + self.rotation
                end

                if love.keyboard.isDown("d") then
                    self.angle = self.angle - self.rotation
                end

                if self.thrusting then
                    self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle) / FPS
                    self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle) / FPS
                
                    sfx:playFX("thruster", "slow")
                else
                    if self.thrust.x ~= 0 or self.thrust.y ~= 0 then
                        self.thrust.x = self.thrust.x - friction * self.thrust.x / FPS
                        self.thrust.y = self.thrust.y - friction * self.thrust.y / FPS
                    end
                    
                    sfx:stopFX("thruster")
                end

                self.x = self.x + self.thrust.x
                self.y = self.y + self.thrust.y

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

            for index, laser in pairs(self.lasers) do
                laser:move()

                if (laser.distance > LASER_DISTANCE * love.graphics.getWidth()) and (laser.exploading == 0) then
                    laser:expload()
                end

                if laser.exploading == 0 then
                    laser:move()
                elseif laser.exploading == 2 then
                    self.destroyLaser(self, index)
                end
            end
        end,

        expload = function (self)
            self.expload_time = math.ceil(EXPLOAD_DUR * love.timer.getFPS())
        end
    }
end

return Player