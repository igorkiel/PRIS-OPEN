function onUse(player, item, itemEx)
    if player:getStorageValue(941539) < 1 then
        local newItem = Game.createItem(2147, 1)
        newItem:setActionId(50110)
        player:addItemEx(newItem)
        player:setStorageValue(941539, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a ruby.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already took the ruby.")
    end
end
