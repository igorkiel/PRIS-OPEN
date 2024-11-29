local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setArea(createCombatArea(AREA_BEAM5, AREADIAGONAL_BEAM5))

--[[
function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + (magicLevel * 1.8) + 11
	local max = (level / 5) + (magicLevel * 3) + 19
	return -min, -max
end
]]

function onGetFormulaValues(player, level, maglevel)
	local base = 60
	local variation = 20
	
	local formula = 3 * maglevel + (2 * level)
	
	local min = (formula * (base - variation)) / 100
	local max = (formula * (base + variation)) / 100
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant)
	return combat:execute(creature, variant)
end
