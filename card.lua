local back = love.graphics.newImage("assets/Backs/back_0.png")

Card = {}

function Card:new (o, x, y, no, suit, img)
   o = o or {}
   o.x = x
   o.y = y
   o.no = no
   o.suit = suit
   o._front = img
   o._w = back:getWidth()
   o._h = back:getHeight()
   o.isRevealed = false
   o._isUnderTopTableauCard = false
   o.YSPACING = 7
   setmetatable(o, self)
   self.__index = self
   return o
end

function Card:setUnderTopTableauCard()
    self._isUnderTopTableauCard = true
end

function Card:unsetUnderTopTableauCard()
    self._isUnderTopTableauCard = false
end

function Card:getH()
    if self._isUnderTopTableauCard then
        return self.YSPACING
    end
    return self._h
end

function Card:getW()
    return self._w
end

function Card:getImg()
    if self.isRevealed then
        return self._front
    end
    return back
end

function Card:isRedSuit()
    return self.suit == "Hearts" or self.suit == "Diamonds"
end

function Card:isBlackSuit()
    return self.suit == "Clubs" or self.suit == "Spades"
end

function Card:beenClicked(clickX, clickY)
	if clickX < self.x or clickX > self.x + self:getW() then
		return false
	end
	if clickY < self.y or clickY > self.y + self:getH() then
		return false
	end
	return true
end
