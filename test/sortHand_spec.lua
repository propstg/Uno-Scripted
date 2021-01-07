require("../sortHand")

describe("SortHandButtonClicked", function()
    it("should sort by color and number", function()
        local cardGreen5 = createCard("position 1", "GREEN", "5")
        local cardRed2 = createCard("position 2", "RED", "2")
        local cardYellow3 = createCard("position 3", "YELLOW", "3")
        local cardBlue1 = createCard("position 4", "BLUE", "1")
        local cardBlueD2 = createCard("position 5", "BLUE", "+2")
        local cardWildD4 = createCard("position 6", "WILD", "+4")
        local cardYellow8 = createCard("position 7", "YELLOW", "8")
        local cardYellow82 = createCard("position 8", "YELLOW", "8")
        local cardYellow0 = createCard("position 9", "YELLOW", "0")

        local player = {}
        function player.getHandObjects() return {
            cardGreen5, cardRed2, cardYellow3, cardBlue1, cardBlueD2, cardWildD4,
            cardYellow8, cardYellow82, cardYellow0
        } end

        assertCardInfo(cardGreen5, "position 1", "GREEN", "5")
        assertCardInfo(cardRed2, "position 2", "RED", "2")
        assertCardInfo(cardYellow3, "position 3", "YELLOW", "3")
        assertCardInfo(cardBlue1, "position 4", "BLUE", "1")
        assertCardInfo(cardBlueD2, "position 5", "BLUE", "+2")
        assertCardInfo(cardWildD4, "position 6", "WILD", "+4")
        assertCardInfo(cardYellow8, "position 7", "YELLOW", "8")
        assertCardInfo(cardYellow82, "position 8", "YELLOW", "8")
        assertCardInfo(cardYellow0, "position 9", "YELLOW", "0")

        SortHandButtonClicked(player)

        assertCardInfo(cardYellow0, "position 1", "YELLOW", "0")
        assertCardInfo(cardYellow3, "position 2", "YELLOW", "3")
        assertCardInfo(cardYellow82, "position 3", "YELLOW", "8")
        assertCardInfo(cardYellow8, "position 4", "YELLOW", "8")
        assertCardInfo(cardWildD4, "position 5", "WILD", "+4")
        assertCardInfo(cardRed2, "position 6", "RED", "2")
        assertCardInfo(cardGreen5, "position 7", "GREEN", "5")
        assertCardInfo(cardBlueD2, "position 8", "BLUE", "+2")
        assertCardInfo(cardBlue1, "position 9", "BLUE", "1")
    end)

    function assertCardInfo(card, expectedPosition, expectedColor, expectedName)
        assert.equal(expectedPosition, card.position)
        assert.equal(expectedColor, card.getDescription())
        assert.equal(expectedName, card.getName())
    end

    it("should not error out with only one card", function()
        local card1 = createCard("position 1", "BLUE", "+2")
        local player = {}
        function player.getHandObjects() return {card1} end

        assert.equal("position 1", card1.position)
        assert.equal("BLUE", card1.getDescription())
        assert.equal("+2", card1.getName())

        SortHandButtonClicked(player)

        assert.equal("position 1", card1.position)
        assert.equal("BLUE", card1.getDescription())
        assert.equal("+2", card1.getName())
    end)

    function createCard(position, color, value)
        local card = {}
        card.position = position
        function card.getDescription()
            return color
        end
        function card.getName()
            return value
        end
        function card.getPosition()
            return card.position
        end
        function card.setPosition(position)
            card.position = position
        end
        return card
    end
end)