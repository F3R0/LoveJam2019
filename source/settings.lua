--shortcuts to love libraries
lg = love.graphics
lp = love.physics
lk = love.keyboard
lf = love.filesystem

--constants
SCALE = 2

--window settings
lg.setBackgroundColor( 0, 0, 0 )
lg.setDefaultFilter('nearest', 'nearest')
screen = {}
screen.w = 320 * SCALE
screen.h = 200 * SCALE
love.window.setMode(screen.w, screen.h, {fullscreen = false, centered = true})