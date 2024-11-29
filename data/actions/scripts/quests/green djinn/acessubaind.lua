function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid ~= 1223 and item.itemid ~= 1257 and item.itemid ~= 1255 then
        return true
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Efreet) >= 1 then
        player:teleportTo(toPosition, true)
        item:transform(item.itemid + 1)  -- Transform the item to the next ID
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door seems to be sealed against unwanted intruders.')
    end
    return true
end
