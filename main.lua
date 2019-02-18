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
  ending = lg.newImage('graphics/menu/ending.png')
  curtain = lg.newImage('graphics/menu/curtain.png')

  gameMusic = la.newSource('sound/gamemusic.mp3', 'stream')
  gameMusic:setLooping(true)

  menuMusic = la.newSource('sound/menumusic.mp3', 'stream')
  menuMusic:setLooping(true)
  
  curtain_darken = true
  curtain_start  = false
  curtain_alpha = 1
  
  input:bind('space', 'skip')
  
  --canvas
  canvas = love.graphics.newCanvas(960, 200)
end

function reset()
  map.health = 100
  horde.enemies = {}
  horde.speed = 0
  horde.frequency = 2
  player.x = 160
  player.y = 100
  --camera = _camera(160, 100, 320, 200)
end

function love.update(dt)
  if gameState == SceneStates.menu then
    menuMusic:play()
    gameMusic:stop()
  
    if input:pressed('skip') then
      stateToGo     = SceneStates.intro
      curtain_start = true
    end
  elseif gameState == SceneStates.intro then
    if input:pressed('skip') then
      stateToGo     = SceneStates.game
      curtain_start = true
    end
  elseif gameState == SceneStates.game then
    map:update(dt)
    player:update(dt)
    horde:update(dt)
    camera:update(dt)
    camera:follow(player.x, player.y)
  elseif gameState == SceneStates.ending then
  if input:pressed('skip') then
    reset()
    stateToGo     = SceneStates.menu
    curtain_start = true
    end
  end

  updateCurtain(dt)
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
  elseif gameState == SceneStates.ending then
    lg.draw(ending, 0, 0)
  end

  drawCurtain()
  
  -- Draw the 400x300 canvas scaled by 2 to a 800x600 screen
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.setBlendMode('alpha', 'premultiplied')
  love.graphics.draw(canvas, 0, 0, 0, SCALE, SCALE)
  love.graphics.setBlendMode('alpha')
  
  --debug()
end

function drawCurtain()
	lg.setColor(1, 1, 1, 1 - curtain_alpha);
	lg.draw(curtain, 0, 0, 0);
	lg.setColor(1, 1, 1, 1);
end

function updateCurtain(dt)
	if not curtain_start then
		return
	end

  if curtain_darken then
    if gameState == SceneStates.intro then
      menuMusic:setVolume(curtain_alpha);
    end

		if curtain_alpha > 0 then
			curtain_alpha = curtain_alpha - dt / 2
    else
      gameState = stateToGo
      curtain_darken = false
      
      if gameState == SceneStates.game then
        menuMusic:stop()
        gameMusic:play()
        gameMusic:setVolume(0)
      end
		end
  else
    if gameState == SceneStates.game then
      gameMusic:setVolume(curtain_alpha - 0.3);
    end

		if curtain_alpha < 1 then
			curtain_alpha = curtain_alpha + dt / 2
		else
			curtain_darken = true
			curtain_start  = false
		end
	end
end