function onUse(player, item, fromPosition, target, toPosition)
    local monsterPosition = Position(32479, 31900, 5)

    -- Verifica se o item possui o actionid e itemid específicos
    if item.actionid == 52005 and item.itemid == 1945 then
        -- Cria o monstro "Ghoul" na posição especificada
        local monster = Game.createMonster("Ghoul", monsterPosition)
        
        if monster then
            player:sendCancelMessage("A Ghoul has appeared!") -- Mensagem para o jogador
            item:transform(item.itemid + 1) -- Transforma o item
            -- print("Ghoul created at position:", monsterPosition)
        else
            player:sendCancelMessage("The monster could not be summoned.")
            -- print("Failed to create monster at position:", monsterPosition)
        end
    else
        player:sendCancelMessage("The switch seems to be stuck.")
        -- print("Switch is stuck. Actionid:", item.actionid, "Itemid:", item.itemid)
    end

    return true
end
