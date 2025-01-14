local WIDTH, HEIGHT = love.graphics.getDimensions()

function DrawBackground()
	local squareSize = 2
	for x = 0, WIDTH, squareSize * 2 do
		for y = 0, HEIGHT, squareSize * 2 do
			love.graphics.setColor(love.math.colorFromBytes(0, 153, 51))
			love.graphics.rectangle("fill", x, y, squareSize, squareSize)
			love.graphics.setColor(love.math.colorFromBytes(51, 204, 51))
			love.graphics.rectangle("fill", x + squareSize, y, squareSize, squareSize)
			love.graphics.setColor(love.math.colorFromBytes(102, 153, 0))
			love.graphics.rectangle("fill", x, y + squareSize, squareSize, squareSize)
			love.graphics.setColor(love.math.colorFromBytes(102, 255, 51))
			love.graphics.rectangle("fill", x + squareSize, y + squareSize, squareSize, squareSize)
		end
	end
end

return DrawBackground
