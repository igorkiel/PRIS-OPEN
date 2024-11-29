local cooldownStorage = 13545 -- Use a unique storage value ID
local cooldownTime = 4 * 60 * 60 -- 4 horas em segundos
local maxPlayers = 4 -- Número máximo de jogadores que podem entrar
local entryStorageBase = 13550 -- Base para os storage values dos jogadores

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentTime = os.time()
    local entryCount = 0

    -- Contar quantos jogadores já usaram a porta
    for i = 0, maxPlayers - 1 do
        local lastOpened = player:getStorageValue(entryStorageBase + i)
        if lastOpened > 0 then
            local timeLeft = (lastOpened + cooldownTime) - currentTime
            if timeLeft > 0 then
                entryCount = entryCount + 1
            else
                player:setStorageValue(entryStorageBase + i, -1) -- Resetar o storage se o cooldown acabou
            end
        end
    end

    -- Se o número de jogadores que usaram a porta é maior ou igual ao máximo permitido, bloquear a entrada
    if entryCount >= maxPlayers then
        local timeLeft = (player:getStorageValue(entryStorageBase) + cooldownTime) - currentTime
        local hours = math.floor(timeLeft / 3600)
        local minutes = math.floor((timeLeft % 3600) / 60)
        local seconds = timeLeft % 60
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("The door will unlock in %02d:%02d:%02d.", hours, minutes, seconds))
        return true
    end

    -- Abre a porta e atualiza o armazenamento do jogador
    if item.itemid == 5114 then
        player:teleportTo(toPosition, true)
        item:transform(item.itemid + 1)
        
        -- Encontrar um slot livre para armazenar o tempo de uso
        for i = 0, maxPlayers - 1 do
            local storageValue = player:getStorageValue(entryStorageBase + i)
            if storageValue == -1 then
                player:setStorageValue(entryStorageBase + i, currentTime)
                break
            end
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
    end
    return true
end
