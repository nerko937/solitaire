local push = require("push")
require("background")
local Piles = require("cards.piles")
local Hold = require("cards.hold")
local GameOver = require("gameOver")

local gameWidth, gameHeight = 720, 1280
local windowWidth, windowHeight = love.window.getDesktopDimensions()

push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, { fullscreen = true, resizable = false })

function love.resize(w, h)
	return push:resize(w, h)
end

function love.load()
	GameOver.createTextObjs(push:getWidth(), push:getHeight())
	Piles.recreate(push:getWidth())
end

function love.update(dt) end

function love.draw()
	push:start()
	DrawBackground()
	Piles.draw()
	Hold.draw()
	GameOver.draw()
	push:finish()
end

function love.mousepressed(x, y, button)
	x, y = push:toGame(x, y)
	GameOver.mousePressed(x, y, button, push:getWidth())
	Piles.mousePressed(x, y, button)
end

function love.mousereleased(x, y, button)
	x, y = push:toGame(x, y)
	Piles.mouseReleased(x, y, button)
end

function love.mousemoved(x, y)
	x, y = push:toGame(x, y)
	Hold.mouseMoved(x, y)
end
