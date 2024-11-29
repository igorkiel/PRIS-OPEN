-- #####################################################
-- #                                                   #
-- #                CREATED BY TELASKO                 #
-- #                  DISCORD: .telasko.               #
-- #                                                   #
-- #####################################################
function onUse(player, item, target, fromPosition, targetPosition)
    -- IDs dos itens que podem alterar a raridade
    local rarityChangerItems = {7253} -- substitua pelos IDs dos itens que alteram a raridade

    -- Verifica se o item usado é um dos rarityChangerItems
    if not table.contains(rarityChangerItems, item:getId()) then
        return false
    end

    -- Define as raridades possíveis e a chance de sucesso
    local rarities = {ITEM_RARITY_RARE, ITEM_RARITY_EPIC, ITEM_RARITY_LEGENDARY, ITEM_RARITY_BRUTAL}
    local successChance = 80 -- porcentagem de chance de sucesso
    local isSuccess = math.random(100) <= successChance

    if isSuccess then
        -- Gera uma raridade aleatória
        local newRarity = rarities[math.random(#rarities)]

        -- Chama a função para alterar a raridade do item
        if target:doPlayerChangeRarity(newRarity) then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "A raridade do item foi alterada com sucesso!")
        else
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Não foi possível alterar a raridade do item.")
        end
    else
        player:sendTextMessage(MESSAGE_INFO_DESCR, "A tentativa de alterar a raridade falhou.")
    end

    -- Remover o item usado após a tentativa
    item:remove(1)
    return true
end
