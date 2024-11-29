function onEquip(player, item, slot, isCheck)
    if isCheck then
        return true
    end
	local playerOutfit = player:getOutfit()
	playerOutfit.lookWings = 1182
	player:setOutfit(playerOutfit)
    player:addWings(11)
    return true
end

function onDeEquip(player, item, slot)
	local playerOutfit = player:getOutfit()
    player:removeWings(11)
	playerOutfit.lookWings = 0
	player:setOutfit(playerOutfit)
return true
end
