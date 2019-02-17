local Player = {}
Player.__index = Player

local hitTime = 0
local hitEnd = true

local function move(self, dir, dt)
  self.walk = true
  self.direction = dir

  if dir == Directions.left and self.x < 50 then return end 
  if dir == Directions.right and self.x > 860 then return end 
  if dir == Directions.up and self.y < 70 then return end 
  if dir == Directions.down and self.y > 200 then return end 

  if dir == Directions.up then
    self.y = self.y - dt * self.speed;
  elseif dir == Directions.down then
    self.y = self.y + dt * self.speed;
  elseif dir == Directions.right then
    self.x = self.x + dt * self.speed;
    self.face = 1
  elseif dir == Directions.left then
    self.x = self.x - dt * self.speed;
    self.face = -1
  end
end

local function checkHit(self, face, enemyPos, enemySize)
  if face == 1 then 
    return  self.x              < enemyPos.x + enemySize.w and
            enemyPos.x          < self.x + self.w / 2      and
            self.y - self.h / 2 < enemyPos.y + enemySize.h and
            enemyPos.y          < self.y + self.h / 2
  else
    return  self.x - self.w / 2 < enemyPos.x + enemySize.w and
            enemyPos.x          < self.x                   and
            self.y - self.h / 2 < enemyPos.y + enemySize.h and
            enemyPos.y          < self.y + self.h / 2
  end
end

function Player.new()
    --idle sword up
    local img_idle_up  = lg.newImage('graphics/Player/PL_Idle_SW_Up.png')
    local anim_idle_up = anim.new(img_idle_up, 80, 60, 0.2)

    --idle sword down
    local img_idle_dw  = lg.newImage('graphics/Player/PL_Idle_SW_Down.png')
    local anim_idle_dw = anim.new(img_idle_dw, 80, 60, 0.2)
    
    --run
    local img_run  = lg.newImage('graphics/Player/PL_Run.png')
    local anim_run = anim.new(img_run, 80, 60, 0.1)
    
    --drag
    local img_drag  = lg.newImage('graphics/Player/PL_Walk_Sw_Down.png')
    local anim_drag = anim.new(img_drag, 80, 60, 0.15)

    --attack light
    local img_attack_light  = lg.newImage('graphics/Player/PL_Attack_Light.png')
    local anim_attack_light = anim.new(img_attack_light, 80, 60, 0.1)
    
    --attack heavy
    local img_attack_heavy  = lg.newImage('graphics/Player/PL_Attack_Heavy.png')
    local anim_attack_heavy = anim.new(img_attack_heavy, 80, 60, 0.1)

    anim_set = {}
    anim_set.idle_up       = anim_idle_up
    anim_set.idle_dw       = anim_idle_dw
    anim_set.run           = anim_run
    anim_set.drag          = anim_drag
    anim_set.attack_light  = anim_attack_light
    anim_set.attack_heavy  = anim_attack_heavy

    --key bindings
    input:bind('up',    'move_u' )
    input:bind('left',  'move_l')
    input:bind('down',  'move_d')
    input:bind('right', 'move_r')
    input:bind('z',     'drag')
    input:bind('x',     'hit')

    return setmetatable({
      anims = anim_set,
      anim = nil,
      w = 80,
      h = 60,
      x = 160,
      y = 100,
      speed = 100,
      direction = Directions.right,
      face = 1,
      hit = false,
      walk = false,
      drag = false,
      drag_power = 1,
      audio = {
        slash_1 = la.newSource("sound/Slash1.wav", "static"),
        slash_2 = la.newSource("sound/Slash2.wav", "static")
      }
    }, Player)
end

function Player:update(dt)  
  self.walk = false
  self.drag = false

  --move directions
  if input:down('move_u') then move(self, Directions.up, dt) end
  if input:down('move_l') then move(self, Directions.left, dt) end
  if input:down('move_d') then move(self, Directions.down, dt) end
  if input:down('move_r') then move(self, Directions.right, dt) end
  
  --dragging weapon
  if input:down('drag') then 
    self.drag = true
    
    if self.drag_power < 20 and self.walk then self.drag_power = self.drag_power + dt * 5 end
    
    if self.drag_power > 2 and not self.walk then self.drag_power = self.drag_power - dt * 20 end
  else
    self.drag = false

    if self.drag_power > 1 then self.drag_power = self.drag_power - dt * 20 end
  end

  --hitting
  if self.hit then
    self.speed = 0
    hitTime = hitTime + dt
      
    if hitTime > 0.7 then
      hitTime = 0
      self.hit = false
      self.anim.pos = 1
    elseif hitTime > 0.2 then
      for i, enemy in ipairs(horde.enemies) do
        enemy.damaged = false
      end
    end
  else
    if self.drag then 
      self.speed = 40
    else
      self.speed = 100
    end

    if self.walk and self.drag then
      self.anim = self.anims.drag
    elseif self.walk and not self.drag then
      self.anim = self.anims.run
    elseif not self.walk and self.drag then
      self.anim = self.anims.idle_dw
    elseif not self.walk and not self.drag then
      self.anim = self.anims.idle_up
    end
  end

  if input:pressed('hit') then
    self.hit = true

    for i, enemy in ipairs(horde.enemies) do
      if checkHit(self, self.face, enemy.pos, enemy.size) and not enemy.damaged then

        enemy.health = enemy.health - 20 * self.drag_power
        enemy.damaged = true
      end
    end

    if self.drag_power > 10 then
      camera:shake(8, 1, 60)
      self.anim = self.anims.attack_heavy
      self.audio.slash_2:play()
    else
      self.anim = self.anims.attack_light
      self.audio.slash_1:play()
    end

    self.drag_power = 1 
  end
  
  self.anim:update(dt);
end

function Player:draw()
  self.anim:draw(self.x, self.y, 0, self.face, 1, self.w / 2, self.h / 2)
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})