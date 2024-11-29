local function ChangeBack()
	local ladderPos = Position(32479, 31904, 3)
	local ladderItem = Tile(ladderPos):getItemById(1386)
	if ladderItem then
		ladderItem:remove()
	end
end

function onUse(player, item, fromPosition, target, toPosition)
	local foodPositions = {
		Position(32478, 31903, 3),
		Position(32479, 31903, 3)
	}
	local expectedFoodIds = {2628, 2634}
	local ladderPos = Position(32479, 31904, 3)

	if item.actionid == 50008 and item.itemid == 1945 then
		local allFoodsPresent = true

		for i, pos in ipairs(foodPositions) do
			local tile = Tile(pos)
			local foodItem = tile and tile:getItemById(expectedFoodIds[i])
			if not foodItem then
				allFoodsPresent = false
				break
			end
		end

		if allFoodsPresent then
			addEvent(ChangeBack, 45000)
			Game.createItem(1386, 1, ladderPos)
			for i, pos in ipairs(foodPositions) do
				local tile = Tile(pos)
				local foodItem = tile:getItemById(expectedFoodIds[i])
				if foodItem then
					foodItem:remove()
					pos:sendMagicEffect(CONST_ME_BLOCKHIT)
				end
			end
			item:transform(item.itemid + 1)
		end
	elseif item.actionid == 50008 and item.itemid == 1946 then
		item:transform(item.itemid - 1)
	end

	return true
end
