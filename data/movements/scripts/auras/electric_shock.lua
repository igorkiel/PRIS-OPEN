function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
	local playerOutfit = player:getOutfit()
	playerOutfit.lookAura = 933
	player:setOutfit(playerOutfit)
    player:addAura(2)
    return true
end

function onDeEquip(player, item, slot)
	local playerOutfit = player:getOutfit()
    player:removeAura(2)
	playerOutfit.lookAura = 0
	player:setOutfit(playerOutfit)
return true
end

