function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position(32571, 31509, 9))
	if not tile:getItemById(7122) then
		player:teleportTo(Position(32580, 31487, 9))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You need to build a bridge to pass the gap.", TALKTYPE_MONSTER_SAY)
		return true
	end
	
	player:setStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue, 2)
	player:teleportTo(Position(32578, 31507, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("You safely passed the gap but your bridge collapsed behind you.", TALKTYPE_MONSTER_SAY)

	local items = tile:getItems()
	for i = 1, tile:getItemCount() do
		local tmpItem = items[i]
		if isInArray({7122, 5770}, tmpItem:getId()) then
			tmpItem:remove()
		end
	end

	local tempTile = tile:getItemById(5770)
	if tempTile then
		tile:remove()
		local newItem = Game.createItem(460, 1, tile:getPosition())
		if newItem then
			newItem:setActionId(50109)
		end


	end

	return true
end
