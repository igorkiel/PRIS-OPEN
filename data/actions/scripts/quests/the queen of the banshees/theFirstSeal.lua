local config = {
	[50000] = {position = Position(32259, 31891, 10), revert = true},
	[50001] = {position = Position(32259, 31890, 10), revert = true},
	[50002] = {position = Position(32266, 31860, 11), revert = true, special = true},

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

local function specialRevert(wallPosition, stairPosition, leverPosition)
	local stair = Tile(stairPosition):getItemById(410)
	if stair then
		stair:remove()
		Game.createItem(407, 1, stairPosition)
		Game.createItem(1498, 1, wallPosition)
		-- print("Special revert: stair removed, tile 407 created, wall recreated.")
	end

	revertWall(wallPosition, leverPosition)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- print("Item uniqueid:", item.uid)
	-- print("Item id:", item.itemid)

	local wall = config[item.uid]
	-- print("Wall configuration found:", wall)

	if not wall then
		player:sendCancelMessage('This lever has no associated wall configuration.')
		-- print("No configuration found for uniqueid:", item.uid)
		return true
	end

	if item.itemid == 1945 then
		removeWall(wall.position)
		item:transform(1946)
		-- print("Lever used at position:", toPosition)

		if wall.special then
			local stairPos = wall.position
			Game.createItem(410, 1, stairPos)
			-- print("Special case: Stair created at position:", stairPos)
			addEvent(specialRevert, config.time * 1000, wall.position, stairPos, toPosition)
		else
			if wall.revert then
				addEvent(revertWall, config.time * 1000, wall.position, toPosition)
			end
		end
	elseif item.itemid == 1946 then
		player:sendCancelMessage('The lever has already been used.')
		-- print("The lever has already been used.")
	end

	return true
end
