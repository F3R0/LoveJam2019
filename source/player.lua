local Player = {}
Player.__index = Player

local function move(self, dir, dt)
  self.state = WalkState.walk
  self.direction = dir

  if dir == Directions.left and self.cx < 150 then return end 
  if dir == Directions.right and self.cx > 860 then return end 
  if dir == Directions.up and self.cy < 0 then return end 
  if dir == Directions.down and self.cy > 200 then return end 

  if dir == Directions.up then
    self.y = self.y - dt * self.speed;
  elseif dir == Directions.down then
    self.y = self.y + dt * self.speed;
  elseif dir == Directions.right then
    self.x = self.x + dt * self.speed;
  elseif dir == Directions.left then
    self.x = self.x - dt * self.speed;
  end
end

function Player.new()
    local image = love.graphics.newImage('graphics/player.png')
    local width = image:getWidth()
    local height = image:getHeight()

    --key bindings
    input:bind('up',    'move_u' )
    input:bind('left',  'move_l')
    input:bind('down',  'move_d')
    input:bind('right', 'move_r')
    input:bind('z',     'drag')
    input:bind('x',     'hit')

    return setmetatable({
      img = image,
      w = width,
      h = height,
      x = 160,
      y = 100,
      speed = 100,
      cx = 0,
      cy = 0,
      state = WalkState.idle,
      direction = Directions.right,
      hit = false,
      debug = false
    }, Player)
end

function Player:update(dt)
  self.cx = self.x + self.w / 2;
  self.cy = self.y + self.h / 2;

  self.state = WalkState.idle
  self.hit = false

  --move directions
  if input:down('move_u') then move(self, Directions.up, dt) end
  if input:down('move_l') then move(self, Directions.left, dt) end
  if input:down('move_d') then move(self, Directions.down, dt) end
  if input:down('move_r') then move(self, Directions.right, dt) end

  --dragging weapon
  if input:down('drag') then 
    self.state = WalkState.drag 
    self.speed = 60
  end
  if input:released('drag') then self.speed = 100 end

  --hitting
  if input:down('hit', 0.5, 0.5) then self.hit = true end
end

function Player:draw()
  lg.draw(self.img, self.x - self.w / 2, self.y - self.h / 2)

  if self.debug and self.hit then
    lg.setColor(1, 0, 0)
    lg.rectangle("line", self.x - self.w / 2 + self.w, self.y - self.h / 2, self.w, self.h)
    lg.setColor(1, 1, 1)
  end
end

return setmetatable({}, {__call = function(_, ...) return Player.new(...) end})