---@diagnostic disable: lowercase-global
local love = require "love"

local Player = require "Player"

function love.keypressed(key)
    if key == "w" then
        player.thrusting = true
    end
end

function love.keyreleased(key)
    if key == "w" then
        player.thrusting = false
    end
end


function love.load()
    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0

    local show_debugging = true

    player = Player(show_debugging)
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    player:movePlayer()
end

function love.draw()
    player:draw()

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(love.timer.getFPS(), 10, 10)
end