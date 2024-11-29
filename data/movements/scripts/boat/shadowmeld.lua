function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
    player:setStorageValue(Ships.Shadowmeld, 1)
    if player:getStorageValue(110016) == 0 or player:getStorageValue(110016) == -1 then
        player:setStorageValue(110016, 1)
    end
    return true
end

function onDeEquip(player, item, slot)
    player:setStorageValue(Ships.Shadowmeld, 0)
    return true
end