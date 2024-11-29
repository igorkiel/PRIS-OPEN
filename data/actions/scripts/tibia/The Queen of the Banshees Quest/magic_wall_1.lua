local config = {
	[50017] = {position = Position(32259, 31891, 10), revert = true},
	[50016] = {position = Position(32259, 31890, 10), revert = true},
	-- [50002] = {position = Position(32266, 31860, 11)},

	time = 120 -- Tempo em segundos
}

local function revertWall(wallPosition, leverPosition)
	local leverItem = Tile(leverPosition):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end

	Game.createItem(1498, 1, wallPosition)
	-- print("Wall reverted at position:", wallPosition)
end

local function removeWall(position)
	local tile = position:getTile()
	if not tile then
		return
	end

	local thing = tile:getItemById(1498)
	if thing then
		thing:remove()
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
		-- print("Wall removed at position:", position)
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		player:sendCancelMessage('The lever has already been used.')
		return true
	end

	local wall = config[item.actionid]
	if not wall then
		player:sendCancelMessage('This lever has no associated wall configuration.')
		return true
	end

	removeWall(wall.position)
	if wall.revert then
		addEvent(revertWall, config.time * 1000, wall.position, toPosition)
	end
	item:transform(1946)
	-- print("Lever used at position:", toPosition)
	return true
end
