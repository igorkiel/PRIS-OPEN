function onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Verifique se o jogador est� logado
    if not player then
        return true
    end

    -- Remova o item do invent�rio do jogador
    item:remove(1)

    -- Adicione um ponto premium � conta do jogador
    local accountId = player:getAccountId()
    db.query("UPDATE `accounts` SET `premium_points` = `premium_points` + 1 WHERE `id` = " .. accountId)

    -- Informe ao jogador que ele recebeu um ponto premium
    player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, "Voc� adicionou 1 OLD coin ao seu shop!")

    -- Adicione um efeito visual na posi��o do jogador
    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)

    return true
end
