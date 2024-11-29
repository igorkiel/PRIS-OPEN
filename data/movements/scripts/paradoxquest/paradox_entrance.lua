function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local skullPositions = {
		Position(32563, 31957, 1),
		Position(32565, 31957, 1),
		Position(32567, 31957, 1),
		Position(32569, 31957, 1)
	}
	local entrance = Position(32481, 31926, 7)
	local skullItemId = 2229
	local effect = CONST_ME_POFF

	if item.actionid == 50044 then
		local allSkullsPresent = true
		for _, skullPos in ipairs(skullPositions) do
			local skullItem = Tile(skullPos):getItemById(skullItemId)
			if not skullItem then
				allSkullsPresent = false
				break
			end
		end
		
		if allSkullsPresent then
			for _, skullPos in ipairs(skullPositions) do
				local skullItem = Tile(skullPos):getItemById(skullItemId)
				if skullItem then
					skullItem:remove()
					skullPos:sendMagicEffect(effect)
				end
			end
			player:teleportTo(entrance)
			entrance:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	return true
end
