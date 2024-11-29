local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_TELEPORT)

function onGetFormulaValues(player, level, magicLevel)
    local base = 45
	local variation = 10
	
	local formula = 3 * magicLevel + (2 * level)
	
	local min = (formula * (base - variation)) / 100
	local max = (formula * (base + variation)) / 100
    local value = math.random(min, max)

	return -value

end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onCastSpell(creature, variant, isHotkey)
    return combat:execute(creature, variant)
end