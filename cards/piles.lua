require("cards.deck")
local Card = require("cards.card")
local Hold = require("cards.hold")
love.graphics.setDefaultFilter("nearest")
local placeholder = love.graphics.newImage("assets/placeholder.png")
local WIDTH = 720

local stock, waste, heartsFoundation, clubsFoundation, diamondsFoundation, spadesFoundation, tableaus, foundations, tableausAndFoundations

Piles = {}

function Piles.recreate()
	local step = WIDTH / 7
	local yGap = 50
	local deck = GetFreshDeck()
	stock = {
		isTableau = false,
		cards = {},
		placeholder = Card:new(nil, 0, yGap, nil, nil, placeholder, true),
	}
	waste = {
		isTableau = false,
		cards = {},
		placeholder = Card:new(nil, step, yGap, nil, nil, placeholder, true),
	}
	heartsFoundation = {
		isTableau = false,
		cards = {},
		placeholder = Card:new(nil, step * 3, yGap, nil, nil, placeholder, true),
	}
	clubsFoundation = {
		isTableau = false,
		cards = {},
		placeholder = Card:new(nil, step * 4, yGap, nil, nil, placeholder, true),
	}
	diamondsFoundation = {
		isTableau = false,
		cards = {},
		placeholder = Card:new(nil, step * 5, yGap, nil, nil, placeholder, true),
	}
	spadesFoundation = {
		isTableau = false,
		cards = {},
		placeholder = Card:new(nil, step * 6, yGap, nil, nil, placeholder, true),
	}
	local secRowY = (yGap * 2) + placeholder:getHeight()
	tableaus = {}
	for i = 0, WIDTH, step do
		table.insert(tableaus, {
			isTableau = true,
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
	foundations = {}
	table.insert(foundations, heartsFoundation)
	table.insert(foundations, clubsFoundation)
	table.insert(foundations, diamondsFoundation)
	table.insert(foundations, spadesFoundation)
	tableausAndFoundations = {}
	for _, tableau in ipairs(tableaus) do
		table.insert(tableausAndFoundations, tableau)
	end
	for _, foundation in ipairs(foundations) do
		table.insert(tableausAndFoundations, foundation)
	end
	stock.cards = deck
end

local function reverseTable(t)
	local reversedTable = {}
	local itemCount = #t
	for k, v in ipairs(t) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end

function Piles.draw()
	local function drawCardPlaceholders()
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
		for _, tableau in ipairs(tableaus) do
			for _, card in ipairs(tableau.cards) do
				love.graphics.draw(card:getImg(), card.x, card.y)
			end
		end
	end

	local function drawOtherPiles()
		for _, pile in ipairs({ stock, waste, heartsFoundation, clubsFoundation, diamondsFoundation, spadesFoundation }) do
			local top = pile.cards[#pile.cards]
			if top then
				love.graphics.draw(top:getImg(), top.x, top.y)
			end
		end
	end

	drawCardPlaceholders()
	drawTableaus()
	drawOtherPiles()
end

local function overlappingArea(first, sec)
	local overlapX = math.max(0, math.min(first.x + first:getW(), sec.x + sec:getW()) - math.max(first.x, sec.x))
	local overlapY = math.max(0, math.min(first.y + first:getH(), sec.y + sec:getH()) - math.max(first.y, sec.y))
	return overlapX * overlapY
end

function Piles.mousePressed(x, y, button)
	local function initCardMove()
		for _, tableau in ipairs(tableaus) do
			for index, card in ipairs(tableau.cards) do
				if card.isRevealed and card:beenClicked(x, y) then
					Hold.holdFrom(tableau, index, x, y)
				end
			end
		end
		local wasteTop = waste.cards[#waste.cards]
		if wasteTop and wasteTop:beenClicked(x, y) then
			Hold.holdFrom(waste, #waste.cards, x, y)
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
		for _, pile in ipairs(tableausAndFoundations) do
			local target = pile.cards[#pile.cards]
			if not target then
				target = pile.placeholder
			end
			local area = overlappingArea(held, target)
			if area > biggestArea then
				biggestArea = area
				biggestAreaObj = pile
			end
		end
	end
	if biggestArea == 0 then
		Hold.resetHeld()
	elseif biggestAreaObj.isTableau then
		Hold.releaseHeldToTableau(biggestAreaObj)
		for _, card in ipairs(biggestAreaObj.cards) do
			card:setUnderTopTableauCard()
		end
		local top = biggestAreaObj.cards[#biggestAreaObj.cards]
		if top then
			top:unsetUnderTopTableauCard()
		end
	else
		Hold.releaseHeldToFoundation(biggestAreaObj)
		local totalInFoundations = 0
		for _, foundation in ipairs(foundations) do
			totalInFoundations = totalInFoundations + #foundation.cards
		end
		if totalInFoundations == 52 then
			GameOver.isGameOver = true
		end
	end
end

return Piles
