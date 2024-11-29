local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)
combat:setArea(createCombatArea(AREA_CROSS6X6))

function onGetFormulaValues(player, level, maglevel)
	local position = player:getPosition()
	local spectators = Game.getSpectators(position, false, true, 6, 6, 6, 6)
	local enemyPlayers = 0

	for _, spectator in ipairs(spectators) do
		if spectator:isPlayer() then
			enemyPlayers = enemyPlayers + 1
		end
	end

	enemyPlayers = enemyPlayers - 1

	local min = (level / 6) + (maglevel * 4) + 32
	local max = (level / 7) + (maglevel * 11) + 40

	if enemyPlayers > 5 then
		min = min * 0.5
		max = max * 0.5
	end
	
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end
