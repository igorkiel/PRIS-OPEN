local config = {
	[50098] = Position(32687, 31470, 13),
	[50099] = Position(32600, 31504, 13),
	[50100] = Position(32604, 31338, 11),
	[50101] = Position(32611, 31515, 9),
	[50102] = Position(32652, 31509, 10),
	[50103] = Position(32692, 31501, 11),
	[50104] = Position(32687, 31470, 13),
	[50105] = Position(32687, 31470, 13),
	[50106] = Position(32687, 31470, 13),
	[50107] = Position(32580, 31487, 9),
	[50108] = Position(32687, 31470, 13)
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end


	if player:getStorageValue(Storage.hiddenCityOfBeregar.OreWagon) == 1 then
		player:teleportTo(targetPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif player:getStorageValue(Storage.hiddenCityOfBeregar.OreWagon) < 1 then
		--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't know how to use this yet.")
		player:teleportTo(targetPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end
