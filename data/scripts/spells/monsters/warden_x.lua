local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setFormula(COMBAT_FORMULA_DAMAGE, -250, 0, -430, 0)
arr = {
{1, 0, 1},
{0, 2, 0},
{1, 0, 1}
}

local area = createCombatArea(arr)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("warden x")
spell:words("###475")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(true)
spell:register()