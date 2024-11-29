local storages = {
    [26100] = Storage.SvargrondArena.Greenhorn,
    [27100] = Storage.SvargrondArena.Scrapper,
    [28100] = Storage.SvargrondArena.Warlord,
    [1101] = Storage.SvargrondArena.Pit -- Storage correta para o Pit
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item.itemid == 5133 then
        return false
    end

    local arenaStorage = player:getStorageValue(Storage.SvargrondArena.Arena)

    if arenaStorage < 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
        return true
    end

    -- Doors to rewards
    local cStorage = storages[item.actionid]
    if cStorage then
        local playerStorageValue = player:getStorageValue(cStorage)
        
        if playerStorageValue ~= 1 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s locked.')
            return true
        end

        item:transform(item.itemid + 1)
        player:teleportTo(item:getPosition(), true)
        return true
    end

    -- Arena entrance doors (Pit door)
    local pitStorage = player:getStorageValue(Storage.SvargrondArena.Pit)
    
    if pitStorage ~= 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
        return true
    else
        item:transform(item.itemid + 1)
        player:teleportTo(item:getPosition(), true)
        
    end

   
    return true
end
