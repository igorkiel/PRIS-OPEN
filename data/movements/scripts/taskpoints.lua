-- #####################################################
-- #                                                   #
-- #                CREATED BY TELASKO                 #
-- #                  DISCORD: .telasko.               #
-- #                                                   #
-- #####################################################

local ConfigPoints = {
    [1234] = 10, 
    [1235] = 20, 
    [1236] = 30, 
}

local storagePoints = 87613 -- storage ID onde os pontos do jogador são armazenados

function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true 
    end

    local requiredPoints = ConfigPoints[item.actionid]
    if not requiredPoints then
        return true 
    end

    local playerPoints = player:getStorageValue(storagePoints)
    if playerPoints >= requiredPoints then
        player:setStorageValue(storagePoints, playerPoints - requiredPoints)
        return true
    else
        player:teleportTo(fromPosition) 
        fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
        player:sendTextMessage(MESSAGE_INFO_DESCR, 'You need ' .. requiredPoints .. ' task points to pass here.')
        return false
    end
end
