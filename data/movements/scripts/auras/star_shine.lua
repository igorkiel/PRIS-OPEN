function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
	local playerOutfit = player:getOutfit()
	playerOutfit.lookAura = 934
	player:setOutfit(playerOutfit)
    player:addAura(3)
    return true
end

function onDeEquip(player, item, slot)
	local playerOutfit = player:getOutfit()
    player:removeAura(3)
	playerOutfit.lookAura = 0
	player:setOutfit(playerOutfit)
return true
end

