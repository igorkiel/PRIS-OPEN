-- #####################################################
-- #                                                   #
-- #                CREATED BY TELASKO                 #
-- #                  DISCORD: .telasko.               #
-- #####################################################

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local useOnceStorage = 2335
    local generalStorage = Storage.DjinnWar.Faction.UsedItem

    if player:getStorageValue(generalStorage) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já usou um item de Djinn antes. Não pode usar este.")
        return true
    end

    local efreetUsed = player:getStorageValue(useOnceStorage)
    if efreetUsed > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já se aliou aos Efreet.")
        return true
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Marid) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já escolheu os Marid. Não pode se aliar aos Efreet.")
        return true
    end

    local efreetStorages = {
        Storage.DjinnWar.EfreetFaction.Start,
        Storage.DjinnWar.EfreetFaction.Mission01,
        Storage.DjinnWar.EfreetFaction.Mission02,
        [Storage.DjinnWar.EfreetFaction.Mission03] = 3,
        Storage.DjinnWar.EfreetFaction.DoorToLamp,
        Storage.DjinnWar.EfreetFaction.DoorToMaridTerritory
    }

    for storage, value in pairs(efreetStorages) do
        player:setStorageValue(storage, value)
    end

    player:setStorageValue(Storage.DjinnWar.Faction.Efreet, 1)
    player:setStorageValue(useOnceStorage, 1)
    player:setStorageValue(generalStorage, 1)

    player:save()

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Você agora está aliado aos Efreet.")
    
    item:remove(1)

    return true
end
