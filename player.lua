local player = {}
player.__index = player

function player.new()
    local p = {}
    setmetatable(p, player)

    -- Position and direction
    p.x = 400
    p.y = 300
    p.direction = 1
    
    -- jumping
    p.onGround = false
    p.jumping = false
    p.jumpStrength = 0

    -- texture and quads
    p.texture = love.graphics.newImage(config.player.spritesheet)
    p.quad = love.graphics.newQuad(config.player.quad.x, config.player.quad.y, config.player.quad.w, config.player.quad.h, p.texture:getWidth(), p.texture:getHeight())

    -- hc shape
    p.shape = hc.rectangle(p.x - config.player.quad.w/2, p.y - config.player.quad.h/2, config.player.quad.w, config.player.quad.h)

    -- pipe and pipe animation
    p.pipes = {}
    p.pipes.quad = {}
    for i=1,#config.player.pipes.quad do
        p.pipes.quad[i] = love.graphics.newQuad(config.player.pipes.quad[i].x, config.player.pipes.quad[i].y, config.player.pipes.quad[i].w, config.player.pipes.quad[i].h, p.texture:getWidth(), p.texture:getHeight())
    end
    p.pipes.index = 1
    p.pipes.indexDirection = 1
    p.pipes.timer = 0

    return p
end

function player:update(dt)
    -- pipe animation timer
    self.pipes.timer = self.pipes.timer + dt
    if self.pipes.timer >= config.player.pipes.animation.speed then
        self.pipes.timer = self.pipes.timer - config.player.pipes.animation.speed
        self.pipes.index = self.pipes.index + 1 * self.pipes.indexDirection
        if self.pipes.index > #self.pipes.quad or self.pipes.index < 1 then
            self.pipes.indexDirection = self.pipes.indexDirection * -1
            self.pipes.index = self.pipes.index + 2 * self.pipes.indexDirection
        end
    end

    -- update y position (pretend gravity)
    local dy = 0
    
    if self.jumping then
        dy = -config.player.jumpStrength * dt
        self.jumpStrength = self.jumpStrength - config.player.jumpStrength * dt
        if self.jumpStrength <= 0 then
            self.jumping = false
            self.jumpStrength = 0
        end
    else
        dy = level:getGravity() * dt
        self.onGround = false
    end

    self.y = self.y + dy

    -- check for movement input
    local dx = 0

    if love.keyboard.isDown("left") then
        dx = -config.player.speed * dt
        self.direction = -1
    end
    if love.keyboard.isDown("right") then
        dx = config.player.speed * dt
        self.direction = 1
    end

    -- move the player sprite
    self.x = self.x + dx
    -- move the player shape
    self.shape:move(dx, dy)

    -- check for player collision and adjust the player sprite and shape, using a -ve because it is from the context of the level block
    for i, v in ipairs(level:getShapes()) do
        local c, dx, dy = v:collidesWith(self.shape)
        if c then
            self.y = self.y - dy
            self.x = self.x - dx
            self.shape:move(-dx, -dy)
            self.jumpStrength = 0
            self.onGround = true
            self.jumping = false
        end
    end

    if self.onGround and love.keyboard.isDown("space") then
        self.jumpStrength = config.player.jumpStrength
        self.onGround = false
        self.jumping = true
    end
end

function player:draw()
    love.graphics.draw(self.texture, self.quad, self.x, self.y, 0, self.direction, 1, config.player.quad.w/2, config.player.quad.h/2)
    love.graphics.draw(self.texture, self.pipes.quad[self.pipes.index], self.x, self.y - config.player.quad.h/2 - config.player.pipes.quad[self.pipes.index].h/2, 0, self.direction, 1, config.player.pipes.quad[self.pipes.index].w/2, config.player.pipes.quad[self.pipes.index].h/2)
    --self.shape:draw("line")
end

return player