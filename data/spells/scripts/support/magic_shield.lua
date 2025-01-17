local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_MANASHIELD)
condition:setParameter(CONDITION_PARAM_TICKS, 200000)
combat:addCondition(condition)

function onCastSpell(creature, variant)
	creature:addBuff(BUFF_UTAMO_VITA)
	return combat:execute(creature, variant)
end
