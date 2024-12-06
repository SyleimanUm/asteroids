---@diagnostic disable: lowercase-global
local love = require "love"

local Player = require "objects/Player"
local Game = require "states/Game"

math.randomseed(os.time())

function love.keypressed(key)
    if game.state.running then        
        if key == "w" then
            player.thrusting = true
        end

        if key == "space" then
            player:shootLaser()
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



    player = Player()

    game = Game()
    game:startNewGame(player)
end

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer()

        for ast_index, asteroid in pairs(asteroids) do
            if not player.exploading then
                if calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                    player:expload()
                    destroy_ast = true
                end
            else
                player.expload_time = player.expload_time - 1
            end
            for _, laser in pairs(player.lasers) do
                if calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:expload()
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            if destroy_ast then
                destroy_ast = false
                asteroid:destroy(asteroids, ast_index, game)
            end
            asteroid:move(dt)
        end
    end
end

function love.draw()

    if game.state.running or game.state.paused then
        player:draw(game.state.paused)

        for _, asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    end

    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.print(love.timer.getFPS(), 10, 10)
end