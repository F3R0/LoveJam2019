local Horde = {}
Horde.__index = Horde

function Horde.new()
  return setmetatable({
    count = 0,
    time = 0,
    enemies = {}
  }, Horde)
end

function Horde:update(dt)
  self.time = self.time + dt

  if math.floor(self.time) > 1 then
    table.insert(self.enemies, _enemy())

    table.sort(self.enemies)

    self.time = 0
    self.count = #self.enemies
  end

  for i, enemy in ipairs(self.enemies) do
    enemy:update(dt)
    
    if enemy.deadTime > 0.8 then
      table.remove(horde.enemies, i)
    end
  end
end

function Horde:draw(behind)
  for i, enemy in ipairs(self.enemies) do
    if behind then
      if enemy.pos.y > player.y - 19 then
        enemy:draw()
      end
    else
      if enemy.pos.y <= player.y - 19 then
        enemy:draw()
      end
    end
  end
end

return setmetatable({}, {__call = function(_, ...) return Horde.new(...) end})