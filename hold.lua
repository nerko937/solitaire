Hold = {}
local held

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

function Hold.getHeldCoords()
    if held then
        return {x = held.card.x, y = held.card.y}
    end
    return {x = -100, y = -100}
end

function Hold.releaseHeld(newTargetPile)
	if not held then
		return
	end
    if not newTargetPile then
        held.card.x = held.prevX
        held.card.y = held.prevY
        table.insert(held.takenFrom.cards, held.card)
    else
        local canBePutted = false
        local last = newTargetPile.cards[#newTargetPile.cards]
        if last then
            if (held.card:isRedSuit() and last:isBlackSuit()) or (held.card:isBlackSuit() and last:isRedSuit()) then
                canBePutted = true
            end
        end
        if canBePutted and held.card.no == last.no - 1 then
            held.card.isRevealed = true
            held.card.x = newTargetPile.x
            held.card.y = newTargetPile.y + (held.card.YSPACING * #newTargetPile.cards)
            held.card:unsetUnderTopTableauCard()
            table.insert(newTargetPile.cards, held.card)
            if #held.takenFrom.cards ~= 0 then
                for _, card in ipairs(held.takenFrom.cards) do
                    card:setUnderTopTableauCard()
                end
                held.takenFrom.cards[#held.takenFrom.cards].isRevealed = true
                held.takenFrom.cards[#held.takenFrom.cards]:unsetUnderTopTableauCard()
            end
        else
            held.card.x = held.prevX
            held.card.y = held.prevY
            table.insert(held.takenFrom.cards, held.card)
        end
    end
	held = nil
end

function Hold.mouseMoved(x, y)
	if not held then
		return
	end
	held.card.x = x - held.mouseInCardX
	held.card.y = y - held.mouseInCardY
end

function Hold.draw()
	if not held then
		return
	end
	love.graphics.draw(held.card:getImg(), held.card.x, held.card.y)
end
return Hold
