local Map = {}
Map.__index = Map

function Map.new()
  local img_ground = lg.newImage('graphics/map/ground.png')
  local img_sky = lg.newImage('graphics/map/sky.png')

  return setmetatable({
    ground  = img_ground,
    sky     = img_sky
  }, Map)
end

function Map:update(dt)

end

function Map:draw()
  for i=-3, 15 do
    lg.draw(self.sky, i * 99, 0)
  end
  
  for i=-3, 10 do
    lg.draw(self.ground, i * 104, 60)
  end

end

return setmetatable({}, {__call = function(_, ...) return Map.new(...) end})