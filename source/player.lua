local Player = {}
Player.__index = Player

function Player.new()
    local image = love.graphics.newImage('graphics/player.png')
    local width = image:getWidth()
    local height = image:getHeight()

    return setmetatable({
      img = image,
      w = width,
      h = height,
      x = 160,
      y = 100,
      speed = 100,
      cx = 0,
      cy = 0
    }, Player)
end

function Player:update(dt)
  self.cx = self.x + self.w / 2;
  self.cy = self.y + self.h / 2;
end

function Player:draw()
  lg.draw(self.img, self.x - self.w / 2, self.y - self.h / 2)
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})