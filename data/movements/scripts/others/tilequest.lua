local stairsPosition = Position(32482, 32170, 14)

function onStepIn(creature, item, position, fromPosition)
	-- create stairs
	if item.actionid == 51023 then
		local stairsItem = Tile(stairsPosition):getItemById(351)
		if stairsItem then
			stairsItem:transform(8280)
		else
		end
		item:transform(425)
	end
	return true
end
