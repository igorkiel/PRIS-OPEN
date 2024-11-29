local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ICE)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onGetFormulaValues(player, level, maglevel)
	local base = 50
	local variation = 15
	
	local formula = 3 * maglevel + (2 * level)
	
	local min = (formula * (base - variation)) / 100
	local max = (formula * (base + variation)) / 100
	return -min, -max
end


combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local function countPlayersInArea(variant, creature)
    local spectators = Game.getSpectators(variant:getPosition(), false, true, 3, 3, 3, 3)
    local playerCount = 0
    for _, spectator in ipairs(spectators) do
        if spectator:isPlayer() then
			local spectator = spectator:getName()
			local user = creature:getName()
			if spectator ~= user then
            	playerCount = playerCount + 1
			end
        end
    end
    return playerCount
end

function onCastSpell(creature, variant, isHotkey)
	local playerCount = countPlayersInArea(variant, creature)
    if playerCount > 5 then
        combat:setFormula(-0.5, 0, -0.5, 0)
    else
        combat:setFormula(-1, 0, -1, 0)
    end

    return combat:execute(creature, variant)
end
