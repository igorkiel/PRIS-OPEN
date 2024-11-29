-- #####################################################
-- #                                                   #
-- #                CREATED BY TELASKO                 #
-- #                  DISCORD: .telasko.               #
-- #####################################################

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local useOnceStorage = 2334
    local generalStorage = Storage.DjinnWar.Faction.UsedItem

    if player:getStorageValue(generalStorage) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já usou um item de Djinn antes. Não pode usar este.")
        return true
    end

    local maridUsed = player:getStorageValue(useOnceStorage)
    if maridUsed > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já se aliou aos Marid.")
        return true
    end

    if player:getStorageValue(Storage.DjinnWar.Faction.Efreet) > 0 then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "Você já escolheu os Efreet. Não pode se aliar aos Marid.")
        return true
    end

    local maridStorages = {
        [Storage.DjinnWar.MaridFaction.Start] = 1,
        [Storage.DjinnWar.MaridFaction.Mission01] = 2,
        [Storage.DjinnWar.MaridFaction.Mission02] = 2,
        [Storage.DjinnWar.MaridFaction.RataMari] = 2,
        [Storage.DjinnWar.MaridFaction.Mission03] = 3,
        [Storage.DjinnWar.MaridFaction.DoorToLamp] = 1,
        [Storage.DjinnWar.MaridFaction.DoorToEfreetTerritory] = 1
    }

    for storage, value in pairs(maridStorages) do
        player:setStorageValue(storage, value)
    end

    player:setStorageValue(Storage.DjinnWar.Faction.Marid, 1)
    player:setStorageValue(useOnceStorage, 1)
    player:setStorageValue(generalStorage, 1)

    player:save()

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Você agora está aliado aos Marid.")
    
    item:remove(1)

    return true
end
