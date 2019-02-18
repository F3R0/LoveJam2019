local Enemy = {}
Enemy.__index = Enemy

local deathAudio = la.newSource('sound/Death.wav', "static")
local hitWall = la.newSource('sound/EnemyHitWall.wav', "static")

function Enemy.new()
  --walk
  local img_walk  = lg.newImage('graphics/Enemy/EN_Walking.png')
  local anim_walk = anim.new(img_walk, 53, 46, 0.3)

  --attack
  local img_attack  = lg.newImage('graphics/Enemy/EN_Attack.png')
  local anim_attack = anim.new(img_attack, 53, 46, 0.3)

  --dying
  local img_dying  = lg.newImage('graphics/Enemy/EN_Dying.png')
  local anim_dying = anim.new(img_dying, 53, 46, 0.1)

  return setmetatable({
    speed = math.random(20, 40),
    anims = {
      walk = anim_walk,
      attack = anim_attack,
      dying = anim_dying
    },
    anim = {},
    pos   = { 
      x = 1000, 
      y = math.random(80,190) 
    },
    size  = {
      w = 53,
      h = 46
    },
    damaged = false,
    health = math.random(50,100),
    deadTime = 0
  }, Enemy)
end

function Enemy:update(dt)
  if self.health < 0 then
    deathAudio:play()
    self.anim = self.anims.dying
    self.deadTime = self.deadTime + dt
  elseif self.pos.x < 100 then
    self.anim = self.anims.attack
    hitWall:play()
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

  if self.anim then
    self.anim:draw(self.pos.x, self.pos.y)
  end
  
  lg.setColor(1, 1, 1)
end

function Enemy:__lt(other)
  return self.pos.y < other.pos.y
end

return setmetatable({}, {__call = function(_, ...) return Enemy.new(...) end})