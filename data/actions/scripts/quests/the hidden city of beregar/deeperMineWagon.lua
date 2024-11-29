local config = {
	[1] = Position(32566, 31505, 9),
	[2] = Position(32611, 31514, 9)
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[player:getStorageValue(Storage.hiddenCityOfBeregar.RoyalRescue)]
	if not targetPosition then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have permission to use this yet.")
		return true
	end

	player:teleportTo(Position(32567, 31505, 9))

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end
