function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemId = 2088
    local actionId = 4055
    local storageKey = 12326  -- Defina um storage key único

    if player:getStorageValue(storageKey) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, " The hollow stone is empty.")
        return true
    end

    local newItem = player:addItem(itemId, 1)
    if newItem then
        newItem:setActionId(actionId)
        player:setStorageValue(storageKey, 1)  -- Marca que o jogador pegou o item
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a silver key.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot carry more items.")
    end
    return true
end
