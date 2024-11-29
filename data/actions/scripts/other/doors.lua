local function closeAndLockDoor(door, originalItemId, position)
	addEvent(function()
		local tile = Tile(position)
		if tile then
			local creatures = tile:getCreatures()
			if #creatures == 0 then
				door:transform(originalItemId)
			else
				-- Se ainda houver criaturas, verificar novamente em 1 segundo
				closeAndLockDoor(door, originalItemId, position)
			end
		end
	end, 1000)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	
	if table.contains(questDoors, itemId) then	
		if player:getStorageValue(item.actionid) ~= -1 then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
			closeAndLockDoor(item, itemId, toPosition) -- Tranca a porta após o jogador passar
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "The door seems to be sealed against unwanted intruders.")
		end
		return true

	elseif table.contains(levelDoors, itemId) then	
		if item.actionid > 0 and player:getLevel() >= item.actionid - 1000 then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
			closeAndLockDoor(item, itemId, toPosition) -- Tranca a porta após o jogador passar
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "Only the worthy may pass.")
		end
		return true

	elseif table.contains(keys, itemId) then
		if target.actionid > 0 then
			if item.actionid == target.actionid and doors[target.itemid] then
				target:transform(doors[target.itemid])
				player:teleportTo(toPosition, true)
				closeAndLockDoor(target, target:getId() - 1, toPosition) -- Tranca a porta após o jogador passar
				return true
			end
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "The key does not match.")
			return true
		end
		return false
	end

	if table.contains(horizontalOpenDoors, itemId) or table.contains(verticalOpenDoors, itemId) then
		local doorCreature = Tile(toPosition):getTopCreature()
		if doorCreature then
			toPosition.x = toPosition.x + 1
			local query = Tile(toPosition):queryAdd(doorCreature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
			if query ~= RETURNVALUE_NOERROR then
				toPosition.x = toPosition.x - 1
				toPosition.y = toPosition.y + 1
				query = Tile(toPosition):queryAdd(doorCreature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
			end

			if query ~= RETURNVALUE_NOERROR then
				player:sendTextMessage(MESSAGE_STATUS_SMALL, Game.getReturnMessage(query))
				return true
			end

			doorCreature:teleportTo(toPosition, true)
		end

		if not table.contains(openSpecialDoors, itemId) then
			item:transform(itemId - 1)
		end
		return true
	end

	if doors[itemId] then
		if item.actionid == 0 then
			item:transform(doors[itemId])
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "It is locked.")
		end
		return true
	end
	return false
end
