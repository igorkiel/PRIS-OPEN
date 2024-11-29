-- premium_item.lua

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local premiumDays = 15

    -- Adiciona 15 dias de premium
    player:addPremiumDays(premiumDays)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received 15 days of premium account!")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

    -- Remove o item usado
    item:remove(1)
    return true
end
