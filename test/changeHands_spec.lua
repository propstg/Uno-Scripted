require("../changeHands")
local mockagne = require 'mockagne'
local when = mockagne.when
local verify = mockagne.verify
local verifyNoCall = mockagne.verify_no_call

describe("ChangeHands", function()
    waitMock = nil

    before_each(function()
        waitMock = mockagne.getMock()
        _G.Wait = waitMock
    end)


    it("should work correctly when called to swap hands (7) with no one holding cards", function()
        local player1 = createMockPlayer(1, "Red")
        local player2 = createMockPlayer(2, "Blue")
        
        _G.seatedPlayers = {player1, player2}
        _G.Player = {
            Red = player1,
            Blue = player2
        }

        assert.equal("player 1 position", player1.getHandObjects()[1].position)
        assert.equal(1, player1.getHandObjects()[1].rotation[1])
        assert.equal(181, player1.getHandObjects()[1].rotation[2])
        assert.equal("Red", player1.getHandObjects()[1].owner.color)

        assert.equal("player 2 position", player2.getHandObjects()[1].position)
        assert.equal(2, player2.getHandObjects()[1].rotation[1])
        assert.equal(182, player2.getHandObjects()[1].rotation[2])
        assert.equal("Blue", player2.getHandObjects()[1].owner.color)

        SwapHands(1, 2)
        waitMock.stored_calls[1].args[1]()

        -- Still in player1 hand objects, because game is what actually moves them after position changes?
        assert.equal(1, #player1.getHandObjects())
        assert.equal("player 2 position", player1.getHandObjects()[1].position)
        assert.equal(2, player1.getHandObjects()[1].rotation[1])
        assert.equal(182, player1.getHandObjects()[1].rotation[2])
        assert.equal("Blue", player1.getHandObjects()[1].owner.color)

        -- Still in player2 hand objects, because game is what actually moves them after position changes?
        assert.equal(1, #player2.getHandObjects())
        assert.equal("player 1 position", player2.getHandObjects()[1].position)
        assert.equal(1, player2.getHandObjects()[1].rotation[1])
        assert.equal(181, player2.getHandObjects()[1].rotation[2])
        assert.equal("Red", player2.getHandObjects()[1].owner.color)
    end)

    it("should work correctly when called to swap hands (7). cards held by player are moved as well", function()
        local player1 = createMockPlayer(1, "Red", true)
        local player2 = createMockPlayer(2, "Blue", true)
        
        _G.seatedPlayers = {player1, player2}
        _G.Player = {
            Red = player1,
            Blue = player2
        }

        assert.equal(1, #player1.getHandObjects())
        assert.equal("player 1 position", player1.getHandObjects()[1].position)
        assert.equal(1, player1.getHandObjects()[1].rotation[1])
        assert.equal(181, player1.getHandObjects()[1].rotation[2])
        assert.equal("Red", player1.getHandObjects()[1].owner.color)
        assert.equal(11, player1.getHandObjects()[1].meta)

        assert.equal(1, #player2.getHandObjects())
        assert.equal("player 2 position", player2.getHandObjects()[1].position)
        assert.equal(2, player2.getHandObjects()[1].rotation[1])
        assert.equal(182, player2.getHandObjects()[1].rotation[2])
        assert.equal("Blue", player2.getHandObjects()[1].owner.color)
        assert.equal(21, player2.getHandObjects()[1].meta)

        SwapHands(1, 2)
        waitMock.stored_calls[1].args[1]()

        assert.equal(2, #player1.getHandObjects())
        assert.equal(11, player1.getHandObjects()[1].meta)
        assert.equal("player 2 position", player1.getHandObjects()[1].position)
        assert.equal(2, player1.getHandObjects()[1].rotation[1])
        assert.equal(182, player1.getHandObjects()[1].rotation[2])
        assert.equal("Blue", player1.getHandObjects()[1].owner.color)
        assert.equal(12, player1.getHandObjects()[2].meta)
        assert.equal("player 2 position", player1.getHandObjects()[2].position)
        assert.equal(2, player1.getHandObjects()[2].rotation[1])
        assert.equal(182, player1.getHandObjects()[2].rotation[2])
        assert.equal("Blue", player1.getHandObjects()[2].owner.color)

        assert.equal(2, #player2.getHandObjects())
        assert.equal(21, player2.getHandObjects()[1].meta)
        assert.equal("player 1 position", player2.getHandObjects()[1].position)
        assert.equal(1, player2.getHandObjects()[1].rotation[1])
        assert.equal(181, player2.getHandObjects()[1].rotation[2])
        assert.equal("Red", player2.getHandObjects()[1].owner.color)
        assert.equal(22, player2.getHandObjects()[2].meta)
        assert.equal("player 1 position", player2.getHandObjects()[2].position)
        assert.equal(1, player2.getHandObjects()[2].rotation[1])
        assert.equal(181, player2.getHandObjects()[2].rotation[2])
        assert.equal("Red", player2.getHandObjects()[2].owner.color)
    end)

    it("should work correctly when called to rotate hands (0)", function()
        local player1 = createMockPlayer(1, "Red")
        local player2 = createMockPlayer(2, "Blue")
        local player3 = createMockPlayer(3, "Yellow")
        local player4 = createMockPlayer(4, "Green")
        
        _G.seatedPlayers = {player1, player2, player3, player4}
        _G.Player = {
            Red = player1,
            Blue = player2,
            Yellow = player3,
            Green = player4,
        }

        assert.equal(1, #player1.getHandObjects())
        assert.equal("player 1 position", player1.getHandObjects()[1].position)
        assert.equal(1, player1.getHandObjects()[1].rotation[1])
        assert.equal(181, player1.getHandObjects()[1].rotation[2])
        assert.equal("Red", player1.getHandObjects()[1].owner.color)
        assert.equal(11, player1.getHandObjects()[1].meta)

        assert.equal(1, #player2.getHandObjects())
        assert.equal("player 2 position", player2.getHandObjects()[1].position)
        assert.equal(2, player2.getHandObjects()[1].rotation[1])
        assert.equal(182, player2.getHandObjects()[1].rotation[2])
        assert.equal("Blue", player2.getHandObjects()[1].owner.color)
        assert.equal(21, player2.getHandObjects()[1].meta)

        assert.equal(1, #player3.getHandObjects())
        assert.equal("player 3 position", player3.getHandObjects()[1].position)
        assert.equal(3, player3.getHandObjects()[1].rotation[1])
        assert.equal(183, player3.getHandObjects()[1].rotation[2])
        assert.equal("Yellow", player3.getHandObjects()[1].owner.color)
        assert.equal(31, player3.getHandObjects()[1].meta)

        assert.equal(1, #player4.getHandObjects())
        assert.equal("player 4 position", player4.getHandObjects()[1].position)
        assert.equal(4, player4.getHandObjects()[1].rotation[1])
        assert.equal(184, player4.getHandObjects()[1].rotation[2])
        assert.equal("Green", player4.getHandObjects()[1].owner.color)
        assert.equal(41, player4.getHandObjects()[1].meta)

        RotateHands()
        waitMock.stored_calls[1].args[1]()

        assert.equal(1, #player1.getHandObjects())
        assert.equal(11, player1.getHandObjects()[1].meta)
        assert.equal("player 2 position", player1.getHandObjects()[1].position)
        assert.equal(2, player1.getHandObjects()[1].rotation[1])
        assert.equal(182, player1.getHandObjects()[1].rotation[2])
        assert.equal("Blue", player1.getHandObjects()[1].owner.color)

        assert.equal(1, #player2.getHandObjects())
        assert.equal(21, player2.getHandObjects()[1].meta)
        assert.equal("player 3 position", player2.getHandObjects()[1].position)
        assert.equal(3, player2.getHandObjects()[1].rotation[1])
        assert.equal(183, player2.getHandObjects()[1].rotation[2])
        assert.equal("Yellow", player2.getHandObjects()[1].owner.color)

        assert.equal(1, #player3.getHandObjects())
        assert.equal(31, player3.getHandObjects()[1].meta)
        assert.equal("player 4 position", player3.getHandObjects()[1].position)
        assert.equal(4, player3.getHandObjects()[1].rotation[1])
        assert.equal(184, player3.getHandObjects()[1].rotation[2])
        assert.equal("Green", player3.getHandObjects()[1].owner.color)

        assert.equal(1, #player4.getHandObjects())
        assert.equal(41, player4.getHandObjects()[1].meta)
        assert.equal("player 1 position", player4.getHandObjects()[1].position)
        assert.equal(1, player4.getHandObjects()[1].rotation[1])
        assert.equal(181, player4.getHandObjects()[1].rotation[2])
        assert.equal("Red", player4.getHandObjects()[1].owner.color)
    end)

    function createMockPlayer(playerNumber, playerColor, createHoldingCard)
        local playerMock = {}
        local handObjects = {createCard(playerMock, playerNumber, 1, playerNumber .. ":1")}
        local holdingObjects = {}
        if createHoldingCard then
            holdingObjects = {createCard(playerMock, playerNumber, 2, playerNumber .. ":2")}
        end
        playerMock.color = playerColor
        function playerMock.getHandObjects()
            return handObjects
        end
        playerMock.getHoldingObjectsCalledTimes = 0
        function playerMock.getHoldingObjects()
            playerMock.getHoldingObjectsCalledTimes = playerMock.getHoldingObjectsCalledTimes + 1
            if playerMock.getHoldingObjectsCalledTimes <= 3 then
                return holdingObjects
            end

            return {}
        end
        function playerMock.getHandTransform()
            return {position = ("player %s position"):format(playerNumber)}
        end
        function playerMock.getPlayerHand()
            return { rot_x = playerNumber, rot_y = playerNumber }
        end
        return playerMock
    end

    function createCard(player, playerNumber, cardNumber, name)
        local cardMock = {}
        cardMock.tag = "Card"
        cardMock.meta = playerNumber * 10 + cardNumber
        cardMock.owner = player
        cardMock.position = ("player %s position"):format(playerNumber)
        cardMock.rotation = {playerNumber, playerNumber + 180}
        function cardMock.getVar()
            return cardMock.owner
        end
        function cardMock.setVar(_, newOwner)
            cardMock.owner = newOwner
        end
        function cardMock.setPosition(newPosition)
            cardMock.position = newPosition
        end
        function cardMock.setRotation(newRotation)
            cardMock.rotation = newRotation
        end
        return cardMock
    end
end)