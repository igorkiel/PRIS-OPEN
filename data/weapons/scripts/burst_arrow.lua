local area = createCombatArea({
    {1, 1, 1},
    {1, 3, 1},
    {1, 1, 1}
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)
-- combat:setParameter(COMBAT_PARAM_BLOCKARMOR, false)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

function onGetFormulaValues(player, level, magicLevel)
    local c = 1.2
    local d = 0.5
   
    local value = math.random(((level + (magicLevel * 1.5))*c*d)*0.6,((level + (magicLevel * 1.5))*c)*0.6)

    return -value
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

function onUseWeapon(player, variant)
    return combat:execute(player, variant)
end