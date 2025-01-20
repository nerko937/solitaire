Card = require("card")

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
            local card = Card:new(nil, 0, 0, i, suit, love.graphics.newImage(string.format("assets/%s/%s_card_%s.png", suit, suit, assetNo)))
			table.insert(self.deck, card)
		end
	end
	-- shuffleInPlace(self.deck)
	return self
end

function Cards.getYCoordSpacing(size)
    return (size - 1) * 7
end

local cardX, cardY, cardClickX, cardClickY, cardRestX, cardRestY = 50, 50, 50, 50, 50, 50
local isHeld = false

function Cards:holdTopFromPile(x, y, pile, isTableau)
    local card = table.remove(pile.cards)
	self.held = {
		mouseInCardX = x - card.x,
		mouseInCardY = y - card.y,
		card = card,
		takenFrom = pile,
        prevX = card.x,
        prevY = card.y,
	}
end

function Cards:getHeldCoords()
    if self.held then
        return {x = self.held.card.x, y = self.held.card.y}
    end
    return {x = -100, y = -100}
end

function Cards:releaseHeld(newPile)
	if not self.held then
		return
	end
    if not newPile then
        self.held.card.x = self.held.prevX
        self.held.card.y = self.held.prevY
        table.insert(self.held.takenFrom.cards, self.held.card)
    else
        local canBePutted = false
        local last = newPile.cards[#newPile.cards]
        if last then
            if (self.held.card:isRedSuit() and last:isBlackSuit()) or (self.held.card:isBlackSuit() and last:isRedSuit()) then
                canBePutted = true
            end
        end
        if canBePutted and self.held.card.no == last.no - 1 then
            self.held.card.isRevealed = true
            self.held.card.x = newPile.x
            self.held.card.y = newPile.y + (self.held.card.YSPACING * #newPile.cards)
            self.held.card:unsetUnderTopTableauCard()
            table.insert(newPile.cards, self.held.card)
            if #self.held.takenFrom.cards ~= 0 then
                for _, card in ipairs(self.held.takenFrom.cards) do
                    card:setUnderTopTableauCard()
                end
                self.held.takenFrom.cards[#self.held.takenFrom.cards].isRevealed = true
                self.held.takenFrom.cards[#self.held.takenFrom.cards]:unsetUnderTopTableauCard()
            end
        else
            self.held.card.x = self.held.prevX
            self.held.card.y = self.held.prevY
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
	self.held.card.x = x - self.held.mouseInCardX
	self.held.card.y = y - self.held.mouseInCardY
end

function Cards:draw()
	if not self.held then
		return
	end
	love.graphics.draw(self.held.card:getImg(), self.held.card.x, self.held.card.y)
end
return Cards
