local push = require "push"
require("background")
local Piles = require("cards.piles")
local Hold = require("cards.hold")
-- local GameOver = require("gameOver")

local gameWidth, gameHeight = 720, 1280 --fixed game resolution
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {fullscreen = true, resizable = false})

function love.resize(w, h)
  return push:resize(w, h)
end

function love.load()
    -- GameOver.createTextObjs(push:getWidth(), push:getHeight())
	Piles.recreate(push:getWidth())
    mx = 0
    my = 0
    tx = 0
    ty = 0
end

function love.update(dt) end

function love.draw()
    push:start()
    -- love.graphics.scale(1/love.window.getDPIScale())
	DrawBackground()
	Piles.draw()
	Hold.draw()
	-- GameOver.draw()
	local x, y, w, h = love.window.getSafeArea( )
	
	love.graphics.print ('graphics.width '.. love.graphics.getWidth (), x, y)
	love.graphics.print ('graphics.gheight '.. love.graphics.getHeight (), x, y+14)
	
	local width, height = love.window.getDesktopDimensions()
	love.graphics.print ('window.width '.. width, x, y+2*14)
	love.graphics.print ('window.gheight '.. height, x, y+3*14)
	
	love.graphics.print ('safe.x '.. x, x, y+4*14)
	love.graphics.print ('safe.y '.. y, x, y+5*14)
	love.graphics.print ('safe.width '.. w, x, y+6*14)
	love.graphics.print ('safe.height '.. h, x, y+7*14)
	love.graphics.print ('mouse.x '.. mx, x, y+8*14)
	love.graphics.print ('mouse.y '.. my, x, y+9*14)
	love.graphics.print ('touch.x '.. tx, x, y+10*14)
	love.graphics.print ('touch.y '.. ty, x, y+11*14)
    push:finish()
end

function love.mousepressed(x, y, button)
    x, y = push:toGame(x, y)
	-- GameOver.mousePressed(x, y, button)
	Piles.mousePressed(x, y, button)
    mx = x
    my = y
end

-- function love.touchpressed( id, x, y, dx, dy, pressure )
--     tx = x
--     ty = y
-- end

function love.mousereleased(x, y, button)
    x, y = push:toGame(x, y)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(x, y)
    x, y = push:toGame(x, y)
	Hold.mouseMoved(x, y)
end
