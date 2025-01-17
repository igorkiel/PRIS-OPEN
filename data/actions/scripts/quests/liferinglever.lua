local config = {
	bridgePositions = {
		Position(32410, 32232, 10),
		Position(32411, 32232, 10),
		Position(32412, 32232, 10),
		Position(32410, 32231, 10),
		Position(32411, 32231, 10),
		Position(32412, 32231, 10)
	},
	bridgeID = 1284,
	waterID = 493
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile, thing, creature
	for i = 1, #config.bridgePositions do
		tile = Tile(config.bridgePositions[i])
		if tile then
			thing, creature = tile:getItemById(item.itemid == 1945 and config.waterID or config.bridgeID), tile:getTopCreature()
			if thing then
				thing:transform(item.itemid == 1945 and config.bridgeID or config.waterID)
			end
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end
