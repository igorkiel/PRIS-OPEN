function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid ~= 1223 then
        return true
    end

    if player:getStorageValue(Storage.WhiteRavenMonasteryQuest.Diary) >= 1 then
        player:teleportTo(toPosition, true)
        item:transform(item.itemid + 1)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door seems to be sealed against unwanted intruders.')
    end
    return true
end
