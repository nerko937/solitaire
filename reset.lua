local Piles = require("cards.piles")

Reset = { showsConfirmation = false }

local Y_FIRST_CARD_ROW_GAP = 50
local font = love.graphics.setNewFont("assets/Milky Week.ttf", 100)
local fontH = font:getHeight()
love.graphics.setFont(font)

local TEXT_X_GAP, TEXT_Y_GAP = 50, 50

local icon, confirm, yes, no

function Reset.createObjs(width, height)
	local img = love.graphics.newImage("assets/redo-arrow-icon.png")
	local y = (Y_FIRST_CARD_ROW_GAP - img:getHeight()) / 2
	icon = {
		img = img,
		x = width - (img:getWidth() + y),
		y = y,
		w = img:getWidth(),
		h = img:getHeight(),
	}

	confirm = {
		text = "Do you really want to reset game?",
		x = 0,
		y = (height - ((fontH * 3) + TEXT_Y_GAP)) / 2,
		limit = width,
		align = "center",
	}
	local yesNoY = confirm.y + TEXT_Y_GAP + (fontH * 2)
	yes = {
		text = "Yes",
		x = (width / 2) - ((TEXT_X_GAP / 2) + font:getWidth("Yes")),
		y = yesNoY,
		textW = font:getWidth("Yes"),
	}
	no = {
		text = "No",
		x = (width / 2) + (TEXT_X_GAP / 2),
		y = yesNoY,
		textW = font:getWidth("No"),
	}
end

function Reset.draw()
	love.graphics.draw(icon.img, icon.x, icon.y)
	if Reset.showsConfirmation then
		love.graphics.printf(confirm.text, confirm.x, confirm.y, confirm.limit, confirm.align)
		love.graphics.print(yes.text, yes.x, yes.y)
		love.graphics.print(no.text, no.x, no.y)
	end
end

function Reset.mousePressed(x, y, button, width)
	local function handleResetIcon()
		if x < icon.x or x > icon.x + icon.w then
			return
		end
		if y < icon.y or y > icon.y + icon.h then
			return
		end
		Reset.showsConfirmation = true
	end

	local function handleConfirm()
		if not Reset.showsConfirmation then
			return
		end
		if y < yes.y or y > yes.y + fontH then
			return
		end
		if x >= yes.x and x <= yes.x + yes.textW then
			Reset.showsConfirmation = false
			Piles.recreate(width)
		end
		if x >= no.x and x <= no.x + no.textW then
			Reset.showsConfirmation = false
		end
	end

	if button ~= 1 or not x or not y then
		return
	end
	handleConfirm()
	handleResetIcon()
end

return Reset
