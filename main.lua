local TLfres = require("tlfres")
require("background")
local Piles = require("cards.piles")
local Hold = require("cards.hold")
local GameOver = require("gameOver")

local CANVAS_WIDTH = 720
local CANVAS_HEIGHT = 1280

function love.load()
	Piles.recreate()
end

function love.update(dt) end

function love.draw()
	TLfres.beginRendering(CANVAS_WIDTH, CANVAS_HEIGHT)
	DrawBackground()
	Piles.draw()
	Hold.draw()
	GameOver.draw()
	TLfres.endRendering()
end

function love.mousepressed(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	GameOver.mousePressed(x, y, button)
	Piles.mousePressed(x, y, button)
end

function love.mousereleased(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(_, _)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	Hold.mouseMoved(x, y)
end
