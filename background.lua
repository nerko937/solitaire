local background = love.graphics.newImage("assets/background_3.png")

function DrawBackground()
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background)
end

return DrawBackground
