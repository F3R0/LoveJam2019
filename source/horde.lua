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
    self.time = 0
    self.count = #self.enemies
  end

  for i, enemy in ipairs(self.enemies) do
    enemy:update(dt)
  end
end

function Horde:draw()
  for i, enemy in ipairs(self.enemies) do
    enemy:draw()
  end
end

return setmetatable({}, {__call = function(_, ...) return Horde.new(...) end})