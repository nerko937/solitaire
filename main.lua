local TLfres = require("tlfres")
local Piles = require("cards.piles")
local Hold = require("cards.hold")
require("background")

local WIDTH, HEIGHT = love.graphics.getDimensions()

function love.load()
	love.window.setFullscreen(true)
end

function love.update(dt) end

function love.draw()
	TLfres.beginRendering(WIDTH, HEIGHT)
	DrawBackground()
	Piles.draw()
	Hold.draw()
	TLfres.endRendering()
end

function love.mousepressed(_, _, button)
	local x, y = TLfres.getMousePosition(WIDTH, HEIGHT)
	Piles.mousePressed(x, y, button)
end

function love.mousereleased(_, _, button)
	local x, y = TLfres.getMousePosition(WIDTH, HEIGHT)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(x, y)
	local x, y = TLfres.getMousePosition(WIDTH, HEIGHT)
	Hold.mouseMoved(x, y)
end
