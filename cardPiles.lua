love.graphics.setDefaultFilter("nearest")
local placeholder = love.graphics.newImage("assets/Placeholder.png")
local back = love.graphics.newImage("assets/Backs/back_0.png")
local cardW = placeholder:getWidth()
local cardH = placeholder:getHeight()
local WIDTH, HEIGHT = love.graphics.getDimensions()
local heldCard

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

function Piles:init(cards)
	self.cards = cards
	local step = WIDTH / 7
	local start = (step - (placeholder:getWidth())) / 2
	self.stock = {
		x = start,
		y = start,
		cards = {},
		indexOfHeld = 0,
	}
	self.waste = {
		x = start + step,
		y = start,
		cards = {},
		indexOfHeld = 0,
	}
	self.heartsFoundation = {
		x = start + step * 3,
		y = start,
		cards = {},
		indexOfHeld = 0,
	}
	self.clubsFoundation = {
		x = start + step * 4,
		y = start,
		cards = {},
		indexOfHeld = 0,
	}
	self.diamondsFoundation = {
		x = start + step * 5,
		y = start,
		cards = {},
		indexOfHeld = 0,
	}
	self.spadesFoundation = {
		x = start + step * 6,
		y = start,
		cards = {},
		indexOfHeld = 0,
	}
	local secRowY = (start * 3) + (placeholder:getHeight())
	for i = start, WIDTH, step do
		table.insert(self.tableaus, {
			x = i,
			y = secRowY,
			cards = {},
			indexOfHeld = 0,
		})
	end
	for index, tableau in ipairs(self.tableaus) do
		for innerIndex = 1, index, 1 do
			table.insert(tableau.cards, table.remove(self.cards.deck))
            if innerIndex == index then
                tableau.visibleIndex = innerIndex
            end
		end
	end
	self.stock.cards = self.cards.deck
	return self
end

function Piles:draw()
	local function drawCardPlaceholders()
		love.graphics.setColor(love.math.colorFromBytes(0, 51, 0))
		love.graphics.draw(placeholder, self.heartsFoundation.x, self.heartsFoundation.y)
		love.graphics.draw(placeholder, self.clubsFoundation.x, self.clubsFoundation.y)
		love.graphics.draw(placeholder, self.diamondsFoundation.x, self.diamondsFoundation.y)
		love.graphics.draw(placeholder, self.spadesFoundation.x, self.spadesFoundation.y)
		love.graphics.draw(placeholder, self.stock.x, self.stock.y)
		for _, tableau in ipairs(self.tableaus) do
			love.graphics.draw(placeholder, tableau.x, tableau.y)
		end
	end

	local function drawTableaus()
		love.graphics.setColor(1, 1, 1)
		for _, tableau in ipairs(self.tableaus) do
			local maxIter = #tableau.cards
			if tableau.indexOfHeld ~= 0 then
				maxIter = tableau.indexOfHeld - 1
			end
			for i = 1, maxIter, 1 do
				local img = back
                if i >= tableau.visibleIndex then
                    img = tableau.cards[i].img
                end
				-- if i == maxIter and tableau.indexOfHeld == 0 then
				-- 	img = tableau.cards[i].img
				-- end
				love.graphics.draw(img, tableau.x, tableau.y + self.cards.getYCoordSpacing(i))
			end
		end
	end

	local function drawStock()
		if #self.stock.cards > 0 then
			love.graphics.draw(back, self.stock.x, self.stock.y)
		end
	end

	local function drawWaste()
		local index = #self.waste.cards
		if index > 0 then
			love.graphics.draw(self.waste.cards[index].img, self.waste.x, self.waste.y)
		end
	end

	drawCardPlaceholders()
	drawTableaus()
	drawStock()
	drawWaste()
end

local function isClickInsidePile(clickX, clickY, pile, ySpacingAdder)
    -- poor naming, what when we click at the middle of tableau?
	local pileY = pile.y
	if ySpacingAdder then
		pileY = pileY + ySpacingAdder(#pile.cards)
	end
	if clickX < pile.x or clickX > pile.x + cardW then
		return false
	end
	if clickY < pileY or clickY > pileY + cardH then
		return false
	end
	return true
end

local function overlappingArea(first, sec)
	local overlapX = math.max(0, math.min(first.x + cardW, sec.x + cardW) - math.max(first.x, sec.x))
	local overlapY = math.max(0, math.min(first.y + cardH, sec.y + cardH) - math.max(first.y, sec.y))
	return overlapX * overlapY
end

function Piles:mousePressed(x, y, button)
	local function initCardMove()
		for _, tableau in ipairs(self.tableaus) do
			if isClickInsidePile(x, y, tableau, self.cards.getYCoordSpacing) then
				tableau.indexOfHeld = #tableau.cards
				self.cards:holdTopFromPile(x, y, tableau, true)
				return
			end
		end
		if isClickInsidePile(x, y, self.waste) and #self.waste.cards ~= 0 then
			self.waste.indexOfHeld = #self.waste.cards
			self.cards:holdTopFromPile(x, y, self.waste)
			return
		end
	end

	local function handleStockClick()
		if x < self.stock.x or x > self.stock.x + cardW then
			return
		end
		if y < self.stock.y or y > self.stock.y + cardH then
			return
		end
		local card = table.remove(self.stock.cards)
		if card then
			table.insert(self.waste.cards, card)
		else
			self.stock.cards = reverseTable(self.waste.cards)
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
	local biggestAreaObj, biggestArea = nil, 0
	for _, tableau in ipairs(self.tableaus) do
        local cmpObj = {x = tableau.x, y = tableau.y + self.cards.getYCoordSpacing(#tableau.cards)}
		local area = overlappingArea(self.cards:getHeldCoords(), cmpObj)
		if area > biggestArea then
			biggestArea = area
			biggestAreaObj = tableau
		end
	end
	if biggestArea == 0 then
        self.cards:releaseHeld()
	else
        self.cards:releaseHeld(biggestAreaObj)
    end
    self.waste.indexOfHeld = 0
    for _, tableau in ipairs(self.tableaus) do
        tableau.indexOfHeld = 0
    end
end

return Piles
