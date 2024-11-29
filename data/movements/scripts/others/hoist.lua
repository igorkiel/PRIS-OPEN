function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end


	if isInArray({3059, 3061}, item.uid) then
		player:teleportTo(Position(32156, 31128, 10))
	elseif item.uid == 3060 then
		if Tile(Position(32156, 31127, 10)):getItemById(1945) then
			player:teleportTo(Position(32157, 31127, 11))
		else
			player:teleportTo(Position(32156, 31128, 9))
		end
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end
