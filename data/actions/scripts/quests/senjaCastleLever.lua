local wallPositions = {
	Position(32186, 31626, 8),
	Position(32187, 31626, 8),
	Position(32188, 31626, 8),
	Position(32189, 31626, 8)
}

local leverDelay = 10
local wallReturnDelay = 20

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getAttribute(ITEM_ATTRIBUTE_UNIQUEID) and player:getStorageValue(item:getId()) > os.time() then
		player:sendCancelMessage("Voce precisa esperar antes de usar a alavanca novamente.")
		return true
	end

	for i = 1, #wallPositions do
		local wallItem = Tile(wallPositions[i]):getItemById(1498)
		if wallItem then
			wallItem:getPosition():sendMagicEffect(CONST_ME_POFF)
			wallItem:remove()
		end
	end

	if item:getId() == 1945 then
		item:transform(1946)
	elseif item:getId() == 1946 then
		item:transform(1945)
	end

	player:setStorageValue(item:getId(), os.time() + leverDelay)

	addEvent(function()
		for i = 1, #wallPositions do
			local tile = Tile(wallPositions[i])
			if tile and not tile:getItemById(1498) then
				Game.createItem(1498, 1, wallPositions[i])
				wallPositions[i]:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			end
		end

		local lever = Tile(item:getPosition()):getItemById(1946) or Tile(item:getPosition()):getItemById(1945)
		if lever then
			lever:transform(1945)
		end
	end, wallReturnDelay * 1000)

	return true
end
