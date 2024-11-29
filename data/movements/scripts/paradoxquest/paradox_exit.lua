function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local exit1 = Position(32566, 31963, 1)

	if item.actionid == 50045 then
		player:teleportTo(exit1)
		exit1:sendMagicEffect(CONST_ME_TELEPORT)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT) -- Adicionando efeito de teleporte na posição original do jogador
		-- print("Player teleported to:", exit1)
	else
		-- print("Action ID does not match 50045.")
	end

	return true
end
