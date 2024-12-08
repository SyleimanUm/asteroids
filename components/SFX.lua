local love = require "love"

function SFX()
    local bgm = love.audio.newSource("src/sounds/bgm.mp3", "stream")
    bgm:setVolume(0.1)
    bgm:setLooping(true)

    local effects = {
        ship_explosion = love.audio.newSource("src/sounds/ship_explosion.ogg", "static"),
        asteriod_explosion = love.audio.newSource("src/sounds/asteriod_explosion.ogg", "static"),
        laser = love.audio.newSource("src/sounds/laser.ogg", "static"),
        thruster = love.audio.newSource("src/sounds/thruster.ogg", "static"),
        select = love.audio.newSource("src/sounds/select.ogg", "static"),

    }
    return {
        fx_played = false,

        setFXPlayed = function (self, has_played)
            self.fx_played = has_played
        end,

        playBGM = function (self)
            if not bgm:isPlaying() then
                bgm:play()
            end
        end,

        stopFX = function (self, effect)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end
        end,

        playFX = function (self, effect, mode)
            if mode == "single" then
                if not self.fx_played then
                    self:setFXPlayed(true)

                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            elseif mode == "slow" then
                if not effects[effect]:isPlaying() then
                    effects[effect]:play()
                end
            else
                self:stopFX(effect)

                effects[effect]:play()
            end
        end
    }
end

return SFX