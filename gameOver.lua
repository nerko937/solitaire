local Piles = require("cards.piles")

GameOver = { isGameOver = false }

local font = love.graphics.setNewFont("assets/Milky Week.ttf", 100)
local fontH = font:getHeight()
love.graphics.setFont(font)

local HEIGHT, WIDTH, textYGap = 1280, 720, 50

local congrats = { text = "Congratulations!", y = (HEIGHT - ((fontH * 2) + textYGap)) / 2 }
congrats.textW = font:getWidth(congrats.text)
congrats.x = (WIDTH - congrats.textW) / 2

local playAgain = {
	text = "Play Again?",
	x = (WIDTH - font:getWidth("Play Again?")) / 2,
	y = congrats.y + textYGap + fontH,
}

function GameOver.draw()
	if not GameOver.isGameOver then
		return
	end
	love.graphics.print(congrats.text, congrats.x, congrats.y)
	love.graphics.print(playAgain.text, playAgain.x, playAgain.y)
end

function GameOver.mousePressed(x, y, button)
	if not GameOver.isGameOver then
		return
	end
	if button ~= 1 then
		return
	end
	if x < congrats.x or x > congrats.x + congrats.textW then
		return
	end
	if y < congrats.y or y > playAgain.y + fontH then
		return
	end
	Piles.recreate()
	GameOver.isGameOver = false
end

return GameOver
