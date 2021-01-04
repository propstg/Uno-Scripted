function RotateHands()
    local startingHands = {}
    for i = 1, #seatedPlayers do
        startingHands[i] = seatedPlayers[i].getHandObjects()
        AddHeldCardsToHand(startingHands[i], i)
    end

    for i = 1, #startingHands do
        local nextIndex = getNextSeatedPlayerIndex(i)
        for j = 1, #startingHands[i] do
            startingHands[i][j].setVar("Owner", seatedPlayers[nextIndex])
            startingHands[i][j].setPosition(seatedPlayers[nextIndex].getHandTransform()['position'] )
            startingHands[i][j].setRotation({seatedPlayers[nextIndex].getPlayerHand()['rot_x'], seatedPlayers[nextIndex].getPlayerHand()['rot_y']+180,0})
        end
    end

    Wait.frames(function()
        for i = 1, #seatedPlayers do
            for j = 1, #seatedPlayers[i].getHandObjects() do
                if seatedPlayers[i].getHandObjects()[j].getVar("Owner").color ~= seatedPlayers[i].color then
                    _player = Player[seatedPlayers[i].getHandObjects()[j].getVar("Owner").color]
                    seatedPlayers[i].getHandObjects()[j].setPosition(_player.getHandTransform()["position"])
                    seatedPlayers[i].getHandObjects()[j].setRotation({_player.getPlayerHand()['rot_x'],_player.getPlayerHand()['rot_y']+180,0})
                end
            end
        end
    end, 20)
end

function SwapHands(sendingPlayerIndex, receivingPlayerIndex)
    local sendersHand = seatedPlayers[sendingPlayerIndex].getHandObjects()    
    local receiversHand = seatedPlayers[receivingPlayerIndex].getHandObjects()

    AddHeldCardsToHand(receiversHand, receivingPlayerIndex)
    AddHeldCardsToHand(sendersHand, sendingPlayerIndex)

    for j = 1, #sendersHand do
        sendersHand[j].setVar("Owner", seatedPlayers[receivingPlayerIndex])
        sendersHand[j].setPosition(seatedPlayers[receivingPlayerIndex].getHandTransform()['position'])
        sendersHand[j].setRotation({seatedPlayers[receivingPlayerIndex].getPlayerHand()['rot_x'],seatedPlayers[receivingPlayerIndex].getPlayerHand()['rot_y']+180,0})
    end

    for j = 1, #receiversHand do
        receiversHand[j].setVar("Owner", seatedPlayers[sendingPlayerIndex])
        receiversHand[j].setPosition(seatedPlayers[sendingPlayerIndex].getHandTransform()['position'])
        receiversHand[j].setRotation({seatedPlayers[sendingPlayerIndex].getPlayerHand()['rot_x'],seatedPlayers[sendingPlayerIndex].getPlayerHand()['rot_y']+180,0})
    end

    Wait.frames(function()
        for i=1,#seatedPlayers do
            for j=1,#seatedPlayers[i].getHandObjects() do
                if seatedPlayers[i].getHandObjects()[j].getVar("Owner").color ~= seatedPlayers[i].color then
                    _player = Player[seatedPlayers[i].getHandObjects()[j].getVar("Owner").color]
                    seatedPlayers[i].getHandObjects()[j].setPosition(_player.getHandTransform()["position"])
                    seatedPlayers[i].getHandObjects()[j].setRotation({_player.getPlayerHand()['rot_x'],_player.getPlayerHand()['rot_y']+180,0})
                end
            end
        end
    end, 20)
end

function AddHeldCardsToHand(handToAddTo, playerIndex)
    for i = 1, #seatedPlayers[playerIndex].getHoldingObjects() do
        if seatedPlayers[playerIndex].getHoldingObjects()[i].tag == 'Card' then
            handToAddTo[#handToAddTo + i] = seatedPlayers[playerIndex].getHoldingObjects()[i]
        end
    end
end

function getNextSeatedPlayerIndex(currentIndex)
    local newIndex = currentIndex + 1
    if newIndex > #seatedPlayers
    then
        newIndex = 1
    end
    return newIndex
end