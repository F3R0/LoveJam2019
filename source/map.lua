local Map = {}
Map.__index = Map

local danger = 0

function Map.new()
  return setmetatable({
    ground  = lg.newImage('graphics/map/ground.png'),
    sky     = lg.newImage('graphics/map/sky.png'),
    bars    = lg.newImage('graphics/map/bars.png'),
    walls   = lg.newImage('graphics/map/walls.png'),
    health  = 100
  }, Map)
end

function Map:update(dt)
  for i, enemy in ipairs(horde.enemies) do
    if enemy.pos.x < 100 then
      danger = danger + 1
    end
  end

  self.health = self.health - dt * danger
  danger = 0

  if self.health < 0 then
    stateToGo     = SceneStates.ending
    curtain_start = true
  end
end

function Map:draw()
  for i=-1, 9 do
    lg.draw(self.sky, i * 99, 0)
  end

  for i=-3, 9 do
    lg.draw(self.ground, i * 104, 62)
  end

  lg.draw(self.walls, -120, -40)
end

function Map:drawBars()
  --life
  lg.setColor(0.3, 0.1, 0.1)
  lg.rectangle('fill', 21, 5, 107, 10)
  lg.setColor(0.7, 0.1, 0.1)
  lg.rectangle('fill', 21, 5, self.health / 100 * 107, 10) --max 107
  
  --drag
  lg.setColor(0.1, 0.2, 0.4)
  lg.rectangle('fill', 17, 20, 53, 9)
  lg.setColor(0.1, 0.2, 0.8)
  lg.rectangle('fill', 17, 20, (player.drag_power - 1) / 4 * 53, 9) --max 53
  
  lg.setColor(1, 1, 1)
  lg.draw(self.bars, 0, 0)
end

return setmetatable({}, {__call = function(_, ...) return Map.new(...) end})