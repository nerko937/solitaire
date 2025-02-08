local TLfres = require("tlfres")
require("background")
local Piles = require("cards.piles")
local Hold = require("cards.hold")
-- local GameOver = require("gameOver")

local CANVAS_WIDTH = 720
local CANVAS_HEIGHT = 1280

function love.load()
	Piles.recreate()
    mx = 0
    my = 0
    tx = 0
    ty = 0
end

function love.update(dt) end

function love.draw()
    love.graphics.scale(1/love.window.getDPIScale())
	TLfres.beginRendering(CANVAS_WIDTH, CANVAS_HEIGHT)
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
	TLfres.endRendering()
end

function love.mousepressed(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	-- GameOver.mousePressed(x, y, button)
	Piles.mousePressed(x, y, button)
    mx = x
    my = y
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    tx = x
    ty = y
end

function love.mousereleased(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(_, _)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Hold.mouseMoved(x, y)
end
