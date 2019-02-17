local Enemy = {}
Enemy.__index = Enemy

function Enemy.new()
  --walk
  local img_walk  = lg.newImage('graphics/Enemy/EN_Walking.png')
  local anim_walk = anim.new(img_walk, 80, 60, 0.3)

  --attack
  local img_attack  = lg.newImage('graphics/Enemy/EN_Attack.png')
  local anim_attack = anim.new(img_attack, 80, 60, 0.3)

  --dying
  local img_dying  = lg.newImage('graphics/Enemy/EN_Dying.png')
  local anim_dying = anim.new(img_dying, 80, 60, 0.3)

  return setmetatable({
    speed = math.random(10, 20),
    anims = {
      walk = anim_walk,
      attack = anim_attack,
      dying = anim_dying
    },
    anim = {},
    pos   = { 
      x = 360, 
      y = math.random(0,200) 
    },
    size  = {
      w = 56,
      h = 56
    },
    damaged = false,
    health = 100
  }, Enemy)
end

function Enemy:update(dt)
  if self.health < 0 then
    self.anim = self.anims.dying
  elseif self.pos.x < 100 then
      self.anim = self.anims.attack
  else
    self.anim = self.anims.walk
    self.pos.x = self.pos.x - dt * self.speed;
  end

  self.anim:update(dt)
end

function Enemy:draw()
  if self.damaged then
    lg.setColor(1, 0, 0)
  end

  self.anim:draw(self.pos.x, self.pos.y)
  lg.setColor(1, 1, 1)

  lg.setColor(1, 0, 0)
  lg.rectangle("line", self.pos.x, self.pos.y, self.size.w, self.size.h)
  lg.setColor(1, 1, 1)
end

return setmetatable({}, {__call = function(_, ...) return Enemy.new(...) end})