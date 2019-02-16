require 'source.settings'

local _anim = require 'plugins.anim8'
local _camera = require 'plugins.Camera'
local _input = require 'plugins.Input'
local _player = require 'source.player'

local dirs = {up = 'up', down = 'down', left = 'left', right = 'right' }
local currentDir = ''
local hit = false

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  map = love.graphics.newImage('graphics/map.png')

  camera = _camera(160, 100, 320, 200)
  camera:setFollowLerp(0.1)
  camera:setFollowStyle('TOPDOWN')

  camera.draw_deadzone = true

  player = _player()

  input = _input()

  --key bindings
  input:bind('w', 'move_u' )
  input:bind('a', 'move_l')
  input:bind('s', 'move_d')
  input:bind('d', 'move_r')
  input:bind('space', 'hit')

  --canvas
  canvas = love.graphics.newCanvas(960, 200)
end

function love.update(dt)
  player:update(dt)
  
  camera:update(dt)
  camera:follow(player.x, player.y)

  if input:down('move_u') then move(dirs.up, dt) end
  if input:down('move_l') then move(dirs.left, dt) end
  if input:down('move_d') then move(dirs.down, dt) end
  if input:down('move_r') then move(dirs.right, dt) end
  if input:pressed('hit') then hit = true end
  if input:released('hit') then hit = false end
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  
  camera:attach()
  
  love.graphics.draw(map, 0, 0)
  player:draw()
  
  camera:detach()
  camera:draw()
    
  love.graphics.setCanvas()
  
  -- Draw the 400x300 canvas scaled by 2 to a 800x600 screen
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
  love.graphics.setBlendMode('alpha')
  
  lg.print(player.cx, 1, 1)
end

function move(dir, dt)
  currentDir = dir

  if currentDir == dirs.left and player.cx < 150 then return end 
  if currentDir == dirs.right and player.cx > 860 then return end 
  if currentDir == dirs.up and player.cy < 0 then return end 
  if currentDir == dirs.down and player.cy < 0 then return end 

  if dir == dirs.up then
    player.y = player.y - dt * player.speed;
  elseif dir == dirs.down then
    player.y = player.y + dt * player.speed;
  elseif dir == dirs.right then
    player.x = player.x + dt * player.speed;
  elseif dir == dirs.left then
    player.x = player.x - dt * player.speed;
  end
end

function love.keypressed(key)
  if key == 'e' then
      camera:shake(8, 1, 60)
  end
end