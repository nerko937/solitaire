local Piles = require("cards.piles")

Reset = {}

local Y_FIRST_CARD_ROW_GAP = 50

local icon

function Reset.initIcon(width)
	local img = love.graphics.newImage("assets/redo-arrow-icon.png")
	local y = (Y_FIRST_CARD_ROW_GAP - img:getHeight()) / 2
	icon = {
		img = img,
		x = width - (img:getWidth() + y),
		y = y,
		w = img:getWidth(),
		h = img:getHeight(),
	}
end

function Reset.draw()
	love.graphics.draw(icon.img, icon.x, icon.y)
end

local title = "Confirm reset"
local message = "Do yo want to reset board?"
local buttons = { "Yes", "No", escapebutton = 2 }

function Reset.mousePressed(x, y, button, width)
	if button ~= 1 or not x or not y then
		return
	end
	if x < icon.x or x > icon.x + icon.w then
		return
	end
	if y < icon.y or y > icon.y + icon.h then
		return
	end
	local pressedbutton = love.window.showMessageBox(title, message, buttons)
	if pressedbutton == 1 then
		Piles.recreate(width)
	end
end

return Reset
