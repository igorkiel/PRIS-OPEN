local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
function onGetFormulaValues(cid, level, maglevel)
	local position = cid:getPosition()
	local spectators = Game.getSpectators(position, false, true, 6, 6, 6, 6)
	local enemyPlayers = 0

	for _, spectator in ipairs(spectators) do
		if spectator:isPlayer() then
			enemyPlayers = enemyPlayers + 1
		end
	end
	enemyPlayers = enemyPlayers - 1
	min = -(level * 5.1 + maglevel * 6.95)
	max = -(level * 6.0 + maglevel * 9.2)

	if enemyPlayers > 5 then
		min = min * 0.5
		max = max * 0.5
	end
	
	return min, max
end

setCombatCallback(combat, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

arr = {
{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
}

local area = createCombatArea(arr)

setCombatArea(combat, area)

function onCastSpell(cid, var)

	return doCombat(cid, combat, var)
end