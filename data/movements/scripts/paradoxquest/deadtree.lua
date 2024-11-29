function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	
	-- print("onStepIn function called")  -- Adicionado para verificar se a função está sendo chamada
	
	local poisonFieldId = 1496  -- ID do campo de veneno
	local poisonPositions = {
		Position(32497, 31889, 7),
		Position(32497, 31890, 7),
		Position(32498, 31890, 7),
		Position(32499, 31890, 7),
		Position(32500, 31890, 7),
		Position(32494, 31887, 7),
		Position(32494, 31889, 7)
	}
	
	if item.actionid == 50006 then
		-- print("ActionID 50006 detected")  -- Adicionado para verificar se a actionid correta foi detectada
		
		-- Aplicar dano físico ao jogador
		local damage = -200
		doTargetCombatHealth(0, player, COMBAT_PHYSICALDAMAGE, damage, damage, CONST_ME_HITBYPOISON)
		
		-- Criar campos de veneno nas posições especificadas
		for _, pos in ipairs(poisonPositions) do
			Game.createItem(poisonFieldId, 1, pos)
		end
		
		-- print("Damage applied and poison fields created")  -- Adicionado para confirmar que as ações foram executadas
	end
	
	return true
end
