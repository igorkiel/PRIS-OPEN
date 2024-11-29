function onLogin(player)
    local vipEndsAt = player:getVipDays()
    local currentTime = os.time()

    if vipEndsAt > 0 and vipEndsAt <= currentTime then
        player:setPromotionLevel(0)
        player:setVipDays(0)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Seu VIP expirou e sua promoção foi removida.")
    elseif player:getVipDays() > 0 then
        if player:getPromotionLevel() == 0 then
            player:setPromotionLevel(1)
        end
        local duration = os.date("%d/%m/%Y", vipEndsAt)
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você tem "..player:getVipDays().." dia(s) de VIP. Ele expirará em "..duration..".")
    else
        player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Você não tem VIP ativo no momento.")
    end

    return true
end
