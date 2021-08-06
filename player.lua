local player = {}
player.__index = player

function player.new()
    local p = {}
    setmetatable(p, player)

    p.x = 400
    p.y = 400

    


    return p
end

return player