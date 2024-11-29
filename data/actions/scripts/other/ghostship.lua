function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(Storage.GhostShipQuest) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
        return false
    end

    player:setStorageValue(Storage.GhostShipQuest, 1)
    player:addItem(2463, 1)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a Plate Armor.")
    return true
end
