-- premium_item.lua

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local premiumDays = 60

    -- Adiciona 60 dias de premium
    player:addPremiumDays(premiumDays)

    player:sendTextMessage(MESSAGE_INFO_DESCR, "You have received 60 days of premium account!")
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

    -- Remove o item usado
    item:remove(1)
    return true
end
