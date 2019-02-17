require 'source.settings'
require 'source.states'
require 'source.debug'
require 'source.states'
require 'source.anim'

_camera = require 'plugins.Camera'
_input  = require 'plugins.Input'
_player = require 'source.player'
_horde  = require 'source.horde'
_enemy  = require 'source.enemy'

function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  map = love.graphics.newImage('graphics/map.png')

  camera = _camera(160, 100, 320, 200)
  camera:setFollowLerp(0.1)
  camera:setFollowStyle('TOPDOWN')
  
  input = _input()
  player = _player()
  horde = _horde()

  --canvas
  canvas = love.graphics.newCanvas(960, 200)
end

function love.update(dt)
  player:update(dt)
  horde:update(dt)
  camera:update(dt)
  camera:follow(player.x, player.y)
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()
  
  camera:attach()
  
  love.graphics.draw(map, 0, 0)

  horde:draw(false)
  player:draw()
  horde:draw(true)

  camera:detach()
  camera:draw()
    
  -- Draw the 400x300 canvas scaled by 2 to a 800x600 screen
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
  love.graphics.setBlendMode('alpha')
  
  --debug()
end