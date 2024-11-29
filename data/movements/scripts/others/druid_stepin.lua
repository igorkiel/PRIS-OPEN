function onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()

    if not player then
        return true
    end

    local allowedVocations = {2, 6}
    local playerVocation = player:getVocation():getId()

    if not table.contains(allowedVocations, playerVocation) then
        player:teleportTo(fromPosition)
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Somente Druids e Elder Druids podem passar por aqui.")
        position:sendMagicEffect(CONST_ME_TELEPORT)
    end

    return true
end
