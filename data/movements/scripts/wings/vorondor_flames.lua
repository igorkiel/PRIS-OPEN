function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
	local playerOutfit = player:getOutfit()
	playerOutfit.lookWings = 1178
	player:setOutfit(playerOutfit)
    player:addWings(7)
    return true
end

function onDeEquip(player, item, slot)
	local playerOutfit = player:getOutfit()
    player:removeWings(7)
	playerOutfit.lookWings = 0
	player:setOutfit(playerOutfit)
return true
end
