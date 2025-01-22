Card = require("card")
Hold = require("hold")
love.graphics.setDefaultFilter("nearest")
local placeholder = love.graphics.newImage("assets/Placeholder.png")
local WIDTH, _ = love.graphics.getDimensions()

local function reverseTable(t)
	local reversedTable = {}
	local itemCount = #t
	for k, v in ipairs(t) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end

Piles = {
	heartsFoundation = {},
	clubsFoundation = {},
	diamondsFoundation = {},
	spadesFoundation = {},
	stock = {},
	waste = {},
	tableaus = {},
}

function Piles:init(deck)
	local step = WIDTH / 7
	local start = (step - (placeholder:getWidth())) / 2
	self.stock = {
		cards = {},
		placeholder = Card:new(nil, start, start, nil, nil, placeholder, true),
	}
	self.waste = {
		cards = {},
		placeholder = Card:new(nil, start + step, start, nil, nil, placeholder, true),
	}
	self.heartsFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 3, start, nil, nil, placeholder, true),
	}
	self.clubsFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 4, start, nil, nil, placeholder, true),
	}
	self.diamondsFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 5, start, nil, nil, placeholder, true),
	}
	self.spadesFoundation = {
		cards = {},
		placeholder = Card:new(nil, start + step * 6, start, nil, nil, placeholder, true),
	}
	local secRowY = (start * 3) + (placeholder:getHeight())
	for i = start, WIDTH, step do
		table.insert(self.tableaus, {
			cards = {},
			placeholder = Card:new(nil, i, secRowY, nil, nil, placeholder, true),
		})
	end
	for index, tableau in ipairs(self.tableaus) do
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
		card.x = self.stock.placeholder.x
		card.y = self.stock.placeholder.y
	end
	self.stock.cards = deck
	return self
end

function Piles:draw()
	local function drawCardPlaceholders()
		love.graphics.setColor(love.math.colorFromBytes(0, 51, 0))
		love.graphics.draw(
			self.heartsFoundation.placeholder:getImg(),
			self.heartsFoundation.placeholder.x,
			self.heartsFoundation.placeholder.y
		)
		love.graphics.draw(
			self.clubsFoundation.placeholder:getImg(),
			self.clubsFoundation.placeholder.x,
			self.clubsFoundation.placeholder.y
		)
		love.graphics.draw(
			self.diamondsFoundation.placeholder:getImg(),
			self.diamondsFoundation.placeholder.x,
			self.diamondsFoundation.placeholder.y
		)
		love.graphics.draw(
			self.spadesFoundation.placeholder:getImg(),
			self.spadesFoundation.placeholder.x,
			self.spadesFoundation.placeholder.y
		)
		love.graphics.draw(self.stock.placeholder:getImg(), self.stock.placeholder.x, self.stock.placeholder.y)
		for _, tableau in ipairs(self.tableaus) do
			love.graphics.draw(tableau.placeholder:getImg(), tableau.placeholder.x, tableau.placeholder.y)
		end
	end

	local function drawTableaus()
		love.graphics.setColor(1, 1, 1)
		for _, tableau in ipairs(self.tableaus) do
			local maxIter = #tableau.cards
			for i = 1, maxIter, 1 do
				local card = tableau.cards[i]
				love.graphics.draw(card:getImg(), card.x, card.y)
			end
		end
	end

	local function drawStock()
		local top = self.stock.cards[#self.stock.cards]
		if top then
			love.graphics.draw(top:getImg(), top.x, top.y)
		end
	end

	local function drawWaste()
		local index = #self.waste.cards
		if index > 0 then
			local card = self.waste.cards[index]
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

function Piles:mousePressed(x, y, button)
	local function initCardMove()
		for _, tableau in ipairs(self.tableaus) do
			local tableauTop = tableau.cards[#tableau.cards]
			if tableauTop and tableauTop:beenClicked(x, y) then
				Hold.holdTopFromPile(x, y, tableau)
			end
		end
		local wasteTop = self.waste.cards[#self.waste.cards]
		if wasteTop and wasteTop:beenClicked(x, y) then
			Hold.holdTopFromPile(x, y, self.waste)
			return
		end
	end

	local function handleStockClick()
		if not self.stock.placeholder:beenClicked(x, y) then
			return
		end
		local card = table.remove(self.stock.cards)
		if card then
			table.insert(self.waste.cards, card)
			card.x = self.waste.placeholder.x
			card.y = self.waste.placeholder.y
			card.isRevealed = true
		else
			self.stock.cards = reverseTable(self.waste.cards)
			for _, stockCard in ipairs(self.stock.cards) do
				stockCard.x = self.stock.placeholder.x
				stockCard.y = self.stock.placeholder.y
				stockCard.isRevealed = false
			end
			self.waste.cards = {}
		end
	end

	if button ~= 1 then
		return
	end

	handleStockClick()
	initCardMove()
end

function Piles:mouseReleased(x, y, button)
	if button ~= 1 then
		return
	end
	local biggestAreaObj, biggestArea, held = nil, 0, Hold.getHeldCard()
	if held then
		for _, tableau in ipairs(self.tableaus) do
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
