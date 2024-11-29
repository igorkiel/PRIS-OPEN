local config = {
	[39511] = {
		fromPosition = Position(32740, 32393, 14),
		toPosition = Position(32740, 32394, 14)
	},
	[39512] = {
		teleportPlayer = true,
		fromPosition = Position(32739, 32391, 14),
		toPosition = Position(32739, 32392, 14)
	}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.actionid]
	if not useItem then
		print("entrou no not")
		return true
	end

	if useItem.teleportPlayer then
		player:teleportTo(Position(32713, 32393, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say('Beauty has to be rewarded! Muahahaha!', TALKTYPE_MONSTER_SAY)
	end

	local tapestry = Tile(useItem.fromPosition):getItemById(1872)
	if tapestry then
		tapestry:moveTo(useItem.toPosition)
	end
	return true
end
