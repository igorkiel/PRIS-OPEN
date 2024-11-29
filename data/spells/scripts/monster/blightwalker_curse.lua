local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SMALLCLOUDS)

-- Definindo a área manualmente
local area = createCombatArea({
    {0, 0, 0, 1, 0, 0, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 1, 1, 1, 1, 1, 0},
    {1, 1, 1, 1, 1, 1, 1},
    {0, 1, 1, 1, 1, 1, 0},
    {0, 0, 1, 1, 1, 0, 0},
    {0, 0, 0, 1, 0, 0, 0},
})

combat:setArea(area)

function onCastSpell(creature, variant)
    local damage = math.random(52, 154)
    for _, target in ipairs(combat:getTargets(creature, variant)) do
        creature:addDamageCondition(target, CONDITION_CURSED, DAMAGELIST_EXPONENTIAL_DAMAGE, damage)
    end
    return true
end
