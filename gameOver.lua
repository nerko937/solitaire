local Piles = require("cards.piles")

GameOver = { isGameOver = false }

local font = love.graphics.setNewFont("assets/Milky Week.ttf", 100)
local fontH = font:getHeight()
love.graphics.setFont(font)

local textYGap = 50

local congrats, playAgain

function GameOver.createTextObjs(width, height)
	congrats = { text = "Congratulations!", y = (height - ((fontH * 2) + textYGap)) / 2 }
	congrats.textW = font:getWidth(congrats.text)
	congrats.x = (width - congrats.textW) / 2
	playAgain = {
		text = "Play Again?",
		x = (width - font:getWidth("Play Again?")) / 2,
		y = congrats.y + textYGap + fontH,
	}
end

function GameOver.draw()
	if not GameOver.isGameOver then
		return
	end
	love.graphics.print(congrats.text, congrats.x, congrats.y)
	love.graphics.print(playAgain.text, playAgain.x, playAgain.y)
end

function GameOver.mousePressed(x, y, button, width)
	if not GameOver.isGameOver then
		return
	end
	if button ~= 1 or not x or not y then
		return
	end
	if x < congrats.x or x > congrats.x + congrats.textW then
		return
	end
	if y < congrats.y or y > playAgain.y + fontH then
		return
	end
	Piles.recreate(width)
	GameOver.isGameOver = false
end

return GameOver
