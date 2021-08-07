local level = {}
level.__index = level

function level.new(level_data)
    local l = {}
    setmetatable(l, level)

    l.shapes = {}
    l.data = level_data
    for i, v in ipairs(l.data.shapes) do
        l.shapes[i] = hc.rectangle(v.x, v.y, v.w, v.h)
    end

    l.spritebatch = nil

    return l
end

function level:update(dt)

end

function level:draw()
    love.graphics.clear(self.data.backgroundColour)
    for i, v in ipairs(self.shapes) do
        v:draw("fill")
    end
end

function level:getGravity()
    return self.data.gravity
end

function level:getShapes()
    return self.shapes
end

return level