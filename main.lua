require("background")
local Piles = require("cards.piles")
local Hold = require("cards.hold")
local GameOver = require("gameOver")

function love.load()
	Piles.recreate()
end

function love.update(dt) end

function love.draw()
	love.graphics.scale(1 / love.window.getDPIScale())
	DrawBackground()
	Piles.draw()
	Hold.draw()
	GameOver.draw()
end

function love.mousepressed(x, y, button)
	GameOver.mousePressed(x, y, button)
	Piles.mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(x, y)
	Hold.mouseMoved(x, y)
end
