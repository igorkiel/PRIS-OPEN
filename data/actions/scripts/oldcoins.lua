function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifique se o jogador está logado
    if not player then
        return true
    end

    -- Remova o item do inventário do jogador
    item:remove(1)

    -- Adicione um ponto premium à conta do jogador
    local accountId = player:getAccountId()
    db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + 1 WHERE `id` = " .. accountId)

    -- Informe ao jogador que ele recebeu um ponto premium
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Você adicionou 1 OLD coin ao seu shop!")

    -- Adicione um efeito visual na posição do jogador
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

    return true
end
