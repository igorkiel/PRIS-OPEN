function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position(32692, 31496, 11))
    if tile:getItemById(7132) then
        player:teleportTo(Position(32687, 31471, 13))
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        tile:getItemById(7132):remove()
    end

	return true
end
