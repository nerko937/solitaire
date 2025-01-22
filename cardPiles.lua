Card = require("card")
Hold = require("hold")
love.graphics.setDefaultFilter("nearest")
local placeholder = love.graphics.newImage("assets/Placeholder.png")
local WIDTH, _ = love.graphics.getDimensions()

local stock, waste, heartsFoundation, clubsFoundation, diamondsFoundation, spadesFoundation, tableaus

local function initPiles()
	local step = WIDTH / 7
	local start = (step - (placeholder:getWidth())) / 2
	local deck = require("deck")
	stock = {
		cards = {},
		placeholder = Card:new(nil, start, start, nil, nil, placeholder, true),
	}
	waste = {
		cards = {},
		placeholder = Card:new(nil, start + step, start, nil, nil, placeholder, true),
	}
	heartsFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 3, start, nil, nil, placeholder, true),
	}
	clubsFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 4, start, nil, nil, placeholder, true),
	}
	diamondsFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 5, start, nil, nil, placeholder, true),
	}
	spadesFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 6, start, nil, nil, placeholder, true),
	}
	local secRowY = (start * 3) + (placeholder:getHeight())
	tableaus = {}
	for i = start, WIDTH, step do
		table.insert(tableaus, {
			cards = {},
			placeholder = Card:new(nil, i, secRowY, nil, nil, placeholder, true),
		})
	end
	for index, tableau in ipairs(tableaus) do
		for innerIndex = 1, index, 1 do
			local card = table.remove(deck)
			card.x = tableau.placeholder.x
			card.y = tableau.placeholder.y + (card.YSPACING * (innerIndex - 1))
			if innerIndex == index then
				card.isRevealed = true
			else
				card:setUnderTopTableauCard()
			end
			table.insert(tableau.cards, card)
		end
	end
	for _, card in ipairs(deck) do
		card.x = stock.placeholder.x
		card.y = stock.placeholder.y
	end
	stock.cards = deck
end
initPiles()

local function reverseTable(t)
	local reversedTable = {}
	local itemCount = #t
	for k, v in ipairs(t) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end

Piles = {}

function Piles.draw()
	local function drawCardPlaceholders()
		love.graphics.setColor(love.math.colorFromBytes(0, 51, 0))
		love.graphics.draw(
			heartsFoundation.placeholder:getImg(),
			heartsFoundation.placeholder.x,
			heartsFoundation.placeholder.y
		)
		love.graphics.draw(
			clubsFoundation.placeholder:getImg(),
			clubsFoundation.placeholder.x,
			clubsFoundation.placeholder.y
		)
		love.graphics.draw(
			diamondsFoundation.placeholder:getImg(),
			diamondsFoundation.placeholder.x,
			diamondsFoundation.placeholder.y
		)
		love.graphics.draw(
			spadesFoundation.placeholder:getImg(),
			spadesFoundation.placeholder.x,
			spadesFoundation.placeholder.y
		)
		love.graphics.draw(stock.placeholder:getImg(), stock.placeholder.x, stock.placeholder.y)
		for _, tableau in ipairs(tableaus) do
			love.graphics.draw(tableau.placeholder:getImg(), tableau.placeholder.x, tableau.placeholder.y)
		end
	end

	local function drawTableaus()
		love.graphics.setColor(1, 1, 1)
		for _, tableau in ipairs(tableaus) do
			local maxIter = #tableau.cards
			for i = 1, maxIter, 1 do
				local card = tableau.cards[i]
				love.graphics.draw(card:getImg(), card.x, card.y)
			end
		end
	end

	local function drawStock()
		local top = stock.cards[#stock.cards]
		if top then
			love.graphics.draw(top:getImg(), top.x, top.y)
		end
	end

	local function drawWaste()
		local index = #waste.cards
		if index > 0 then
			local card = waste.cards[index]
			love.graphics.draw(card:getImg(), card.x, card.y)
		end
	end

	drawCardPlaceholders()
	drawTableaus()
	drawStock()
	drawWaste()
end

local function overlappingArea(first, sec)
	local overlapX = math.max(0, math.min(first.x + first:getW(), sec.x + sec:getW()) - math.max(first.x, sec.x))
	local overlapY = math.max(0, math.min(first.y + first:getH(), sec.y + sec:getH()) - math.max(first.y, sec.y))
	return overlapX * overlapY
end

function Piles.mousePressed(x, y, button)
	local function initCardMove()
		for _, tableau in ipairs(tableaus) do
			local tableauTop = tableau.cards[#tableau.cards]
			if tableauTop and tableauTop:beenClicked(x, y) then
				Hold.holdTopFromPile(x, y, tableau)
			end
		end
		local wasteTop = waste.cards[#waste.cards]
		if wasteTop and wasteTop:beenClicked(x, y) then
			Hold.holdTopFromPile(x, y, waste)
			return
		end
	end

	local function handleStockClick()
		if not stock.placeholder:beenClicked(x, y) then
			return
		end
		local card = table.remove(stock.cards)
		if card then
			table.insert(waste.cards, card)
			card.x = waste.placeholder.x
			card.y = waste.placeholder.y
			card.isRevealed = true
		else
			stock.cards = reverseTable(waste.cards)
			for _, stockCard in ipairs(stock.cards) do
				stockCard.x = stock.placeholder.x
				stockCard.y = stock.placeholder.y
				stockCard.isRevealed = false
			end
			waste.cards = {}
		end
	end

	if button ~= 1 then
		return
	end

	handleStockClick()
	initCardMove()
end

function Piles.mouseReleased(x, y, button)
	if button ~= 1 then
		return
	end
	local biggestAreaObj, biggestArea, held = nil, 0, Hold.getHeldCard()
	if held then
		for _, tableau in ipairs(tableaus) do
			local target = tableau.cards[#tableau.cards]
			if not target then
				target = tableau.placeholder
			end
			local area = overlappingArea(held, target)
			if area > biggestArea then
				biggestArea = area
				biggestAreaObj = tableau
			end
		end
	end
	if biggestArea == 0 then
		Hold.releaseHeld()
	else
		Hold.releaseHeld(biggestAreaObj)
		for _, card in ipairs(biggestAreaObj.cards) do
			card:setUnderTopTableauCard()
		end
		biggestAreaObj.cards[#biggestAreaObj.cards]:unsetUnderTopTableauCard()
	end
end

return Piles
