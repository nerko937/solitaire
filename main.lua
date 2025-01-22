local TLfres = require("tlfres")
local Piles = require("cardPiles")
local Hold = require("hold")
require("background")

local CANVAS_WIDTH = 266
local CANVAS_HEIGHT = 200

function love.load()
	love.window.setFullscreen(true)
end

function love.update(dt) end

function love.draw()
	TLfres.beginRendering(CANVAS_WIDTH, CANVAS_HEIGHT)
	DrawBackground()
	Piles.draw()
	Hold.draw()
	TLfres.endRendering()
end

function love.mousepressed(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Piles.mousePressed(x, y, button)
end

function love.mousereleased(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(x, y)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Hold.mouseMoved(x, y)
end
