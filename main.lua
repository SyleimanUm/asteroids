---@diagnostic disable: lowercase-global
local love = require "love"

local Player = require "Player"
local Game = require "states/Game"

function love.keypressed(key)
    if game.state.running then        
        if key == "w" then
            player.thrusting = true
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
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

    game = Game()
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer()
    end
end

function love.draw()
    player:draw()

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(love.timer.getFPS(), 10, 10)
end