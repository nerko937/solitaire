Hold = {}
local held

function Hold.holdFrom(pile, index, x, y)
	local cards = { unpack(pile.cards, index) }
	pile.cards = { unpack(pile.cards, 1, index - 1) }
	local first = cards[1]
	held = {
		mouseInCardX = x - first.x,
		mouseInCardY = y - first.y,
		cards = cards,
		card = first,
		takenFrom = pile,
	}
	held.prevCoords = {}
	for _, card in ipairs(cards) do
		table.insert(held.prevCoords, { x = card.x, y = card.y })
	end
end

function Hold.holdTopFromPile(x, y, pile)
	local card = table.remove(pile.cards)
	held = {
		mouseInCardX = x - card.x,
		mouseInCardY = y - card.y,
		card = card,
		takenFrom = pile,
		prevX = card.x,
		prevY = card.y,
	}
end

function Hold.getHeldCard()
	if not held then
		return nil
	end
	return held.card
end

function Hold.resetHeld()
	if not held then
		return
	end
	for index, card in ipairs(held.cards) do
		card.x = held.prevCoords[index].x
		card.y = held.prevCoords[index].y
		table.insert(held.takenFrom.cards, card)
	end
	held = nil
end

function Hold.releaseHeldTo(newTargetPile)
	if not held then
		return
	end
	local canBePutted = false
	local last = newTargetPile.cards[#newTargetPile.cards]
	if last then
		if (held.card:isRedSuit() and last:isBlackSuit()) or (held.card:isBlackSuit() and last:isRedSuit()) then
			if held.card.no == last.no - 1 then
				canBePutted = true
			end
		end
    else
        if held.card.no == 13 then
            canBePutted = true
        end
	end
	if canBePutted then
		for _, card in ipairs(held.cards) do
			card.x = newTargetPile.placeholder.x
			card.y = newTargetPile.placeholder.y + (card.YSPACING * #newTargetPile.cards)
			table.insert(newTargetPile.cards, card)
		end
		if #held.takenFrom.cards ~= 0 then
			for _, card in ipairs(held.takenFrom.cards) do
				card:setUnderTopTableauCard()
			end
			held.takenFrom.cards[#held.takenFrom.cards].isRevealed = true
			held.takenFrom.cards[#held.takenFrom.cards]:unsetUnderTopTableauCard()
		end
	else
		for index, card in ipairs(held.cards) do
			card.x = held.prevCoords[index].x
			card.y = held.prevCoords[index].y
			table.insert(held.takenFrom.cards, card)
		end
	end
	held = nil
end

function Hold.mouseMoved(x, y)
	if not held then
		return
	end
	for index, card in ipairs(held.cards) do
		card.x = x - held.mouseInCardX
		card.y = (y - held.mouseInCardY) + ((index - 1) * card.YSPACING)
	end
end

function Hold.draw()
	if not held then
		return
	end
	for _, card in ipairs(held.cards) do
		love.graphics.draw(card:getImg(), card.x, card.y)
	end
end
return Hold
