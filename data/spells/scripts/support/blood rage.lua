local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

local condition = createConditionObject(CONDITION_ATTRIBUTES)
addConditionParam(condition, CONDITION_PARAM_TICKS, 10000)
addConditionParam(condition, CONDITION_PARAM_SKILL_MELEEPERCENT, 135)
addConditionParam(condition, CONDITION_PARAM_SKILL_SHIELDPERCENT, -100)
addConditionParam(condition, CONDITION_PARAM_BUFF, true)
setCombatCondition(combat, condition)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
