love.graphics.setDefaultFilter("nearest")
local Cards = {}

local function shuffleInPlace(t)
	for i = #t, 2, -1 do
		local j = love.math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end
function Cards:init()
	self.deck = {}
	local suits = { "Hearts", "Clubs", "Diamonds", "Spades" }
	for i = 1, 13, 1 do
		for _, suit in ipairs(suits) do
			local assetNo = tostring(i)
			if i < 10 then
				assetNo = "0" .. assetNo
			end
			love.graphics.setDefaultFilter("nearest")
			table.insert(self.deck, {
				suit = suit,
				no = i,
				img = love.graphics.newImage(string.format("assets/%s/%s_card_%s.png", suit, suit, assetNo)),
			})
		end
	end
	shuffleInPlace(self.deck)
	return self
end

function Cards.getYCoordSpacing(size)
    return (size - 1) * 7
end

local cardX, cardY, cardClickX, cardClickY, cardRestX, cardRestY = 50, 50, 50, 50, 50, 50
local isHeld = false

function Cards:holdTopFromPile(x, y, pile, isTableau)
    local cardY = pile.y
    if isTableau then
        cardY = cardY + self.getYCoordSpacing(#pile.cards)
    end
	self.held = {
		mouseInCardX = x - pile.x,
		mouseInCardY = y - cardY,
		x = pile.x,
		y = cardY,
		card = table.remove(pile.cards),
		takenFrom = pile,
	}
end

function Cards:getHeldCoords()
    if self.held then
        return {x = self.held.x, y = self.held.y}
    end
    return {x = -100, y = -100}
end

function Cards:releaseHeld(newPile)
	if not self.held then
		return
	end
    if not newPile then
        table.insert(self.held.takenFrom.cards, self.held.card)
    else
        local canBePutted = false
        local last = newPile.cards[#newPile.cards]
        if last then
            if self.held.card.suit == "Hearts" or self.held.card.suit == "Diamonds" then
                if last.suit == "Clubs" or last.suit == "Spades" then
                    canBePutted = true
                end
            else
                if last.suit == "Hearts" or last.suit == "Diamonds" then
                    canBePutted = true
                end
            end
        end
        if canBePutted and self.held.card.no == last.no - 1 then
            table.insert(newPile.cards, self.held.card)
            if self.held.takenFrom.visibleIndex then
                self.held.takenFrom.visibleIndex = self.held.takenFrom.visibleIndex - 1
            end
        else
            table.insert(self.held.takenFrom.cards, self.held.card)
        end
    end
	self.held = nil
end

function Cards:mouseReleased(x, y, button)
	-- local held = {}
	-- held.x = x - cardClickX
	-- held.endX = held.x + self.w
	-- held.y = y - cardClickY
	-- held.endY = held.y + self.h
-- 	local biggestAreaObj, biggestArea = nil, 0
-- 	for _, pile in ipairs(self.piles) do
-- 		local area = overlappingArea(held, pile)
-- 		if area > biggestArea then
-- 			biggestArea = area
-- 			biggestAreaObj = pile
-- 		end
-- 	end
-- 	if biggestArea == 0 then
-- 		cardX = cardRestX
-- 		cardY = cardRestY
-- 		isHeld = false
-- 		return
-- 	end
-- 	cardX, cardRestX = biggestAreaObj.x, biggestAreaObj.x
-- 	cardY, cardRestY = biggestAreaObj.y, biggestAreaObj.y
-- 	isHeld = false
end

function Cards:mouseMoved(x, y)
	if not self.held then
		return
	end
	self.held.x = x - self.held.mouseInCardX
	self.held.y = y - self.held.mouseInCardY
end

function Cards:draw()
	if not self.held then
		return
	end
	love.graphics.draw(self.held.card.img, self.held.x, self.held.y)
end
return Cards
