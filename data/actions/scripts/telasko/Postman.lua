-- #####################################################
-- #                                                   #
-- #                CREATED BY TELASKO                 #
-- #                  DISCORD: .telasko.               #
-- #                                                   #
-- #####################################################

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local postmanStorages = {
        Storage.postman.Mission01,
        Storage.postman.Mission02,
        Storage.postman.Mission03,
        Storage.postman.Mission04,
        Storage.postman.Mission05,
        Storage.postman.Mission06,
        Storage.postman.Mission07,
        Storage.postman.Mission08,
        Storage.postman.Mission09,
        Storage.postman.Mission10,
        Storage.postman.Rank,
        Storage.postman.Door,
        Storage.postman.TravelCarlin,
        Storage.postman.TravelEdron,
        Storage.postman.TravelVenore,
        Storage.postman.TravelCormaya
    }

    -- Verifica se o jogador j� completou a miss�o final do Postman
    if player:getStorageValue(Storage.postman.Mission10) >= 1 then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Voc� j� completou as miss�es do Postman. N�o � poss�vel usar este item novamente.")
        return true
    end

    -- Conceder todas as storages para o jogador
    for _, storage in ipairs(postmanStorages) do
        player:setStorageValue(storage, 1)
    end

    player:sendTextMessage(MESSAGE_INFO_DESCR, "Voc� agora possui todas as miss�es e permiss�es do Postman.")
	
	 -- Remover o item ap�s o uso
    item:remove(1)
	
    return true
end
