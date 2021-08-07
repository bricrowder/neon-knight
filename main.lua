-- Modules/Libraries
json = require "libs/dkjson"
hc = require "libs/hc"

-- my classes
playerClass = require "player"
levelClass = require "level"

-- global variables
config = nil

function love.load()
    -- Load json config
    config = json.opendecode("config.json")

    -- create player object
    player = playerClass.new()

    level = levelClass.new(json.opendecode("levels/1-test_level.json"))
end

function love.update(dt)
    level:update(dt)
    player:update(dt)

end

function love.draw()
    level:draw()
    player:draw()

    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
    love.graphics.print("Jumping: "..tostring(player.jumping), 10, 25)
    love.graphics.print("On Ground: "..tostring(player.onGround), 10, 40)
    love.graphics.print("Jump Strength: "..player.jumpStrength, 10, 55)
end