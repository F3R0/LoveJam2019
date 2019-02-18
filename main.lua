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
_map    = require 'source.map'

function love.load()
  camera = _camera(160, 100, 320, 200)
  camera:setFollowLerp(0.1)
  camera:setFollowStyle('TOPDOWN')
  
  input = _input()
  player = _player()
  horde = _horde()
  map = _map()

  gameState = SceneStates.menu

  menu = lg.newImage('graphics/menu/title.png')
  intro = lg.newImage('graphics/menu/intro.png')
  
  input:bind('space', 'skip')

  --canvas
  canvas = love.graphics.newCanvas(960, 200)
end

function love.update(dt)
  if gameState == SceneStates.menu then
    if input:pressed('skip') then
      gameState = SceneStates.intro
    end
  elseif gameState == SceneStates.intro then
    if input:pressed('skip') then
      gameState = SceneStates.game
    end
  elseif gameState == SceneStates.game then
    map:update(dt)
    player:update(dt)
    horde:update(dt)
    camera:update(dt)
    camera:follow(player.x, player.y)
  end
end

function love.draw()
  love.graphics.setCanvas(canvas)
  love.graphics.clear()

  if gameState == SceneStates.menu then
    lg.draw(menu, 0, 0)
  elseif gameState == SceneStates.intro then
    lg.draw(intro, 0, 0)
  elseif gameState == SceneStates.game then
    
    camera:attach()
    
    map:draw()
    horde:draw(false)
    player:draw()
    horde:draw(true)

    --debugCanvas()

    camera:detach()
    camera:draw()

    map:drawBars()
  end
  
  -- Draw the 400x300 canvas scaled by 2 to a 800x600 screen
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
  love.graphics.setBlendMode('alpha')
  
  --debug()
end