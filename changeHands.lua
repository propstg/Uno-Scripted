
--[[This function will move players hands between one player, designated as a 'sender' and another player designated as a 'receiver'.
To simply swap hands between the sender and the receiver, set 'Recursive' to 0 when calling. Otherwise the function is designed to exchange hands with the player to your right]]
function ChangeHands(sendingPlayerIndex,receivingPlayerIndex,Recursive)
    --Create a reference to the hand of the sending player    
    sendersHand = {}
    sendersHand = seatedPlayers[sendingPlayerIndex].getHandObjects()    
    --Create a reference to the Hand of the receiving player
    receiversHand = {}
    receiversHand = seatedPlayers[receivingPlayerIndex].getHandObjects()

    --Add any cards the players might actively be holding to the tables
    for i=1,#seatedPlayers[receivingPlayerIndex].getHoldingObjects()
    do
        if seatedPlayers[receivingPlayerIndex].getHoldingObjects()[i].tag == 'Card'
        then
            receiversHand[#receiversHand+i] = seatedPlayers[receivingPlayerIndex].getHoldingObjects()[i]
        end
    end

    for i=1, #seatedPlayers[sendingPlayerIndex].getHoldingObjects()
    do
        if seatedPlayers[sendingPlayerIndex].getHoldingObjects()[i].tag == 'Card'
        then
            -- typo? original had "sendingPlayerHand" instead of "sendersHand"
            sendersHand[#sendersHand+i] = seatedPlayers[sendingPlayerIndex].getHoldingObjects()[i]
        end
    end

    --Iterate through all of the objects (cards) in the sending players hands
    for j=1,#sendersHand
    do

        --First we set the owner of the card to be the receiving player
        sendersHand[j].setVar("Owner", seatedPlayers[receivingPlayerIndex])

        --Then we move the card to the receiving players hand, and fix its rotation
        sendersHand[j].setPosition( seatedPlayers[receivingPlayerIndex].getHandTransform()['position'] )
        sendersHand[j].setRotation({seatedPlayers[receivingPlayerIndex].getPlayerHand()['rot_x'],seatedPlayers[receivingPlayerIndex].getPlayerHand()['rot_y']+180,0})
    end

    --If Recursive is greater than 1, we will assume we are exchanging cards with the player to your right, instead of just swapping hands with 1 other player
    if Recursive > 1
    then
        --decrease Recusive by 1
        Recursive = Recursive-1
        --Call this function again, but with the receiving player now becoming the sender, and the next player in line being the new receiver
        ChangeHands(receivingPlayerIndex, getNextSeatedPlayerIndex(receivingPlayerIndex), Recursive )

    --If Recursive is equal to 0, we assume we only want to swap hands between the sender and the receiver
    elseif Recursive == 0
    then
        --Call this function again, but with the receiver being the new sender, the sender being the new receiver, and Recursive as -1 to bypass this check again
        ChangeHands(receivingPlayerIndex,sendingPlayerIndex,-1)
    end


    Wait.frames(
        function()
            for i=1,#seatedPlayers
            do
                for j=1,#seatedPlayers[i].getHandObjects()
                do
                    if seatedPlayers[i].getHandObjects()[j].getVar("Owner").color ~= seatedPlayers[i].color
                    then
                        _player =  Player[ seatedPlayers[i].getHandObjects()[j].getVar("Owner").color ]
                        seatedPlayers[i].getHandObjects()[j].setPosition( _player.getHandTransform()["position"] )
                        seatedPlayers[i].getHandObjects()[j].setRotation( {_player.getPlayerHand()['rot_x'],_player.getPlayerHand()['rot_y']+180,0} )
                    end
                end
            end
        end, 20)

end--Function ChangeHands END