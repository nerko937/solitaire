require("cards.card")

local function shuffleInPlace(t)
	for i = #t, 2, -1 do
		local j = love.math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

local Deck = {}

love.graphics.setDefaultFilter("nearest")

local suits = { "heart", "club", "diamond", "spade" }
for i = 1, 13, 1 do
	for _, suit in ipairs(suits) do
		local card = Card:new(
			nil,
			0,
			0,
			i,
			suit,
			love.graphics.newImage(string.format("assets/%s/%s_%s.png", suit, i, suit))
		)
		table.insert(Deck, card)
	end
end
-- shuffleInPlace(self.deck)

return Deck
