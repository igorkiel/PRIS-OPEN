local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE) -- Assuming the spell deals earth damage
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20 * 1000)
condition:setFormula(0, -0.7, 0, -0.7) -- Ajuste os valores conforme necessário

combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
