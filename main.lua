local TLfres = require("tlfres")
local Piles = require("cardPiles")
local Deck = require("deck")
local Hold = require("hold")
require("background")

local CANVAS_WIDTH = 266
local CANVAS_HEIGHT = 200

function love.load()
	love.window.setFullscreen(true)
	piles = Piles:init(Deck)
end

function love.update(dt) end

function love.draw()
	TLfres.beginRendering(CANVAS_WIDTH, CANVAS_HEIGHT)
	DrawBackground()
	piles:draw()
    Hold.draw()
	TLfres.endRendering()
end

function love.mousepressed(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	piles:mousePressed(x, y, button)
end

function love.mousereleased(_, _, button)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
	piles:mouseReleased(x, y, button)
end

function love.mousemoved(x, y)
	local x, y = TLfres.getMousePosition(CANVAS_WIDTH, CANVAS_HEIGHT)
    Hold.mouseMoved(x, y)
end
