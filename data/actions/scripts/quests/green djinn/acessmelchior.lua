function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid ~= 1223 and item.itemid ~= 1257 then
        return true
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Greeting) >= 1 then
        player:teleportTo(toPosition, true)
        if item.itemid == 1223 then
            item:transform(1224)  -- Transform 1223 to 1224
        elseif item.itemid == 1257 then
            item:transform(1258)  -- Transform 1257 to 1258
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door seems to be sealed against unwanted intruders.')
    end
    return true
end
