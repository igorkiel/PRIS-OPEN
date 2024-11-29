function onStepOut(creature, item, position, fromPosition)
	if not creature:isPlayer() or creature:isInGhostMode() then
		return true
	end

	if item:getId() == 670 then
		item:transform(6594)
	else
		item:transform(item.itemid + 15)
	end
	item:decay()
	return true
end
