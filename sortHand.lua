function SortHandButtonClicked(player, b, button)
    local cardsToSort = {}
    local positionsByIndex = {}
    local playerCards = player.getHandObjects()
    for _, card in pairs(playerCards) do
        table.insert(cardsToSort, {card = card, color = card.getDescription(), value = card.getName()})
        table.insert(positionsByIndex, card.getPosition())
    end

    table.sort(cardsToSort, function(a, b)
        if a.color ~= b.color then
            return a.color > b.color
        end

        return a.value < b.value
    end)

    for cardIndex, cardInfo in pairs(cardsToSort) do
        cardInfo.card.setPosition(positionsByIndex[cardIndex])
    end
end