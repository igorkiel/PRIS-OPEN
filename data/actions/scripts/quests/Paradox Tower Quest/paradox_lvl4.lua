function onUse(player, item, fromPosition, target, toPosition)
	local foodPositions = {
		Position(32476, 31900, 4),
		Position(32477, 31900, 4),
		Position(32478, 31900, 4),
		Position(32479, 31900, 4),
		Position(32480, 31900, 4),
		Position(32481, 31900, 4)
	}

	local expectedFoodIds = {2682, 2676, 2679, 2674, 2681, 2678}
	local ladderPos = Position(32478, 31904, 4)

	-- print("Player used the item with actionid:", item.actionid, "and itemid:", item.itemid)

	if item.actionid == 50007 and item.itemid == 1945 then
		local allFoodsPresent = true

		for i, pos in ipairs(foodPositions) do
			local tile = Tile(pos)
			local foodItem = tile and tile:getItemById(expectedFoodIds[i])
			if not foodItem then
				allFoodsPresent = false
				-- print(string.format("Expected food item not found at position: (%d, %d, %d). Expected itemid: %d", pos.x, pos.y, pos.z, expectedFoodIds[i]))
				break
			end
		end

		if allFoodsPresent then
			-- print("All required food items are present. Creating ladder and removing food items.")
			Game.createItem(1386, 1, ladderPos)
			for i, pos in ipairs(foodPositions) do
				local tile = Tile(pos)
				local foodItem = tile:getItemById(expectedFoodIds[i])
				if foodItem then
					foodItem:remove()
					pos:sendMagicEffect(CONST_ME_MAGIC_BLUE)
				end
			end
			item:transform(item.itemid + 1)
		else
			-- print("Not all required food items are present.")
		end
	elseif item.actionid == 50007 and item.itemid == 1946 then
		local ladderItem = Tile(ladderPos):getItemById(1386)
		if ladderItem then
			ladderItem:remove()
			-- print("Ladder removed from position:", ladderPos)
		else
			-- print("No ladder found at position:", ladderPos)
		end
		item:transform(item.itemid - 1)
	else
		-- print("Actionid or itemid do not match expected values.")
	end

	return true
end
