---@diagnostic disable: lowercase-global
local love = require "love"
local Text = require "../components/Text"

function Game()
    return {
        state = {
            menu = false,
            paused = false,
            running = true,
            ended = false
        },

        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        end,

        draw = function (self, faded)
            if faded then
                Text(
                    "PAUSE",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw(game.state.paused)
            end
        end
    }
end

return Game