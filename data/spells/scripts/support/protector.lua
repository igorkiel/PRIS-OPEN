local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, false)

local condition = createConditionObject(CONDITION_ATTRIBUTES)
addConditionParam(condition, CONDITION_PARAM_TICKS, 10000)
addConditionParam(condition, CONDITION_PARAM_SUBID, 4)
addConditionParam(condition, CONDITION_PARAM_SKILL_SHIELDPERCENT, 220)
addConditionParam(condition, CONDITION_PARAM_BUFF, true)
setCombatCondition(combat, condition)

local disable = createConditionObject(CONDITION_PACIFIED)
addConditionParam(disable, CONDITION_PARAM_TICKS, 10000)
setCombatCondition(combat, disable)

local exhaust = createConditionObject(CONDITION_EXHAUST)
addConditionParam(exhaust, CONDITION_PARAM_SUBID, 1)
addConditionParam(exhaust, CONDITION_PARAM_TICKS, 10000)
setCombatCondition(combat, exhaust)

function onCastSpell(cid, var)
	return doCombat(cid, combat, var)
end
