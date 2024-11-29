function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
    local playerOutfit = player:getOutfit()
    playerOutfit.lookAura = 932
    player:setOutfit(playerOutfit)
    player:addAura(1)
    return true
end

function onDeEquip(player, item, slot)
    local playerOutfit = player:getOutfit()
    player:removeAura(1)
    playerOutfit.lookAura = 0
    player:setOutfit(playerOutfit)    
    return true
end