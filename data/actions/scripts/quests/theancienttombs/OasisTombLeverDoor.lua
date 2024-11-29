local doorPosition = Position(33122, 32765, 14)
local openDoorItemId = 1240
local closedDoorItemId = 1239
local carrotStorage = 13345 -- Storage ID para a cenoura

local function revertCarrotAndLever(position, carrotPosition)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end

	local carrotItem = Tile(carrotPosition):getItemById(2684)
	if carrotItem then
		carrotItem:remove()
	end
end

local function closeDoor(playerId)
	local player = Player(playerId)
	if player then
		local doorItem = Tile(doorPosition):getItemById(openDoorItemId)
		if doorItem then
			doorItem:transform(closedDoorItemId)
		end
		player:setStorageValue(carrotStorage, -1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door has closed behind you.')
	end
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == closedDoorItemId then
		if player:getStorageValue(carrotStorage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You first must find the Carrot under one of the three hats to get the access!')
			return true
		end
	end

	if item.itemid ~= 1945 then
		return true
	end

	if math.random(3) == 1 then
		local hatPosition = Position(toPosition.x - 1, toPosition.y, toPosition.z)
		hatPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		doorPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		Game.createItem(2684, 1, hatPosition)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found the carrot! The door is open!')
		item:transform(1946)
		addEvent(revertCarrotAndLever, 4 * 1000, toPosition, hatPosition)

		local doorItem = Tile(doorPosition):getItemById(closedDoorItemId)
		if doorItem then
			doorItem:transform(openDoorItemId)
		end

		-- Conceder acesso temporário ao jogador
		player:setStorageValue(carrotStorage, 1)
		addEvent(closeDoor, 10 * 1000, player:getId()) -- Fecha a porta após 10 segundos (ajuste conforme necessário)
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You guessed wrong! Take this! Carrot changed now the Hat!')
	doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, -200, -200, CONST_ME_POFF)
	return true
end
