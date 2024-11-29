function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
	local playerOutfit = player:getOutfit()
	playerOutfit.lookAura = 936
	player:setOutfit(playerOutfit)
    player:addAura(5)
    return true
end

function onDeEquip(player, item, slot)
	local playerOutfit = player:getOutfit()
    player:removeAura(5)
	playerOutfit.lookAura = 0
	player:setOutfit(playerOutfit)
return true
end

